import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dune_awakening_companion/features/field_timers/models/field_timer_preset.dart';
import 'package:dune_awakening_companion/features/field_timers/services/field_timer_audio_service.dart';
import 'package:dune_awakening_companion/features/field_timers/services/field_timer_notification_service.dart';
import 'package:dune_awakening_companion/features/field_timers/services/field_timer_service.dart';

class _FakeAudioService extends FieldTimerAudioService {
  final List<int> playedStages = [];
  int pagePlays = 0;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> playCueStage(int stage) async {
    playedStages.add(stage);
  }

  @override
  Future<void> playPage() async {
    pagePlays++;
  }

  @override
  Future<void> stopAll() async {}
}

class _FakeNotificationService extends FieldTimerNotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> scheduleTimeline({
    required Duration totalDuration,
    required List<FieldTimerCue> cues,
    required int escalationIntervalSeconds,
    required String cueTitle,
    required String cueBody,
    required String pageTitle,
    required String pageBody,
  }) async =>
      false; // OS timeline never arms in tests — in-app path stays active.

  @override
  Future<void> showTimerFired({
    required String title,
    required String body,
    required int escalationCount,
  }) async {}

  @override
  Future<void> cancelAll() async {}
}

/// Verifies the countdown is wall-clock anchored: if the Dart isolate is
/// frozen (power save / Doze) and ticks stop arriving, the next tick must
/// snap elapsed to true wall-clock time instead of lagging by the freeze.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  late DateTime fakeNow;
  late _FakeAudioService audio;

  FieldTimerService buildService() {
    audio = _FakeAudioService();
    return FieldTimerService(
      audio,
      _FakeNotificationService(),
      now: () => fakeNow,
    );
  }

  test('elapsed is derived from the wall clock, not tick count', () async {
    fakeNow = DateTime(2026, 6, 12, 12, 0, 0);
    final service = buildService();
    await service.arm(const Duration(minutes: 3), cueCount: 0);

    // Simulate the isolate being frozen for 90 s: wall clock advances but
    // only a single tick arrives afterwards.
    fakeNow = fakeNow.add(const Duration(seconds: 90));
    service.debugTick();

    expect(service.state.elapsed, const Duration(seconds: 90));
    await service.cancel();
  });

  test('crossing T=0 during a freeze transitions to firing on next tick',
      () async {
    fakeNow = DateTime(2026, 6, 12, 12, 0, 0);
    final service = buildService();
    await service.arm(const Duration(minutes: 3), cueCount: 0);

    fakeNow = fakeNow.add(const Duration(minutes: 5));
    service.debugTick();

    expect(service.state.isFiring, isTrue);
    await service.cancel();
  });

  test(
      'cues crossed during a freeze are all marked fired but only the most '
      'urgent stage plays', () async {
    fakeNow = DateTime(2026, 6, 12, 12, 0, 0);
    final service = buildService();
    await service.arm(
      const Duration(minutes: 3),
      cueCount: 4,
      cueSpacing: const Duration(seconds: 30),
    );

    // Jump to 10 s before T=0 — all four cues (120/90/60/30 s out) crossed.
    fakeNow =
        fakeNow.add(const Duration(minutes: 3) - const Duration(seconds: 10));
    service.debugTick();

    expect(service.state.cues.where((c) => c.fired).length, 4);
    expect(service.state.isArmed, isTrue);
    // No barrage: a single catch-up tick plays only the latest stage (4).
    expect(audio.playedStages, [4]);
    await service.cancel();
  });
}
