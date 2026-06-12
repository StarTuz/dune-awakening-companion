import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/field_timer_preset.dart';
import '../models/field_timer_session.dart';
import 'field_timer_audio_service.dart';
import 'field_timer_notification_service.dart';
import 'field_timer_settings.dart';

/// State machine for one field timer session.
///
/// Lifecycle: Idle → Armed (tick every 1 s; cue dispatch) → Firing (escalation)
///            → Idle (via ackEnd) or Armed (via ackRestart).
class FieldTimerService extends StateNotifier<FieldTimerSession> {
  FieldTimerService(this._audio, this._notifications)
      : super(const FieldTimerSession.idle());

  final FieldTimerAudioService _audio;
  final FieldTimerNotificationService _notifications;

  Timer? _tickTimer;
  Timer? _escalationTimer;

  // Localised strings injected before arm() so the service doesn't need context.
  String _firingTitle = 'Reset aggro now';
  String _firingBody = 'Sand harvest window elapsed. Pick up your sandcrawler.';

  void setNotificationStrings(String title, String body) {
    _firingTitle = title;
    _firingBody = body;
  }

  // ── Public API ─────────────────────────────────────────────────────────

  Future<void> arm(Duration duration,
      {int? cueCount, Duration? cueSpacing}) async {
    await cancel(); // clean up any previous session

    final count = cueCount ?? await FieldTimerSettings.getCueCount();
    final spacing = cueSpacing ??
        Duration(seconds: await FieldTimerSettings.getCueSpacingSeconds());

    final preset = FieldTimerPreset(
      id: '_custom',
      labelKey: '',
      duration: duration,
      cueCount: count,
      cueSpacing: spacing,
    );

    final cues = preset.buildCues();

    state = FieldTimerSession(
      state: FieldTimerState.armed,
      totalDuration: duration,
      elapsed: Duration.zero,
      cues: cues,
      escalationCount: 0,
    );

    _startTick();
    debugPrint(
        '[FieldTimer] Armed for ${duration.inSeconds}s, $count cues at ${spacing.inSeconds}s spacing');
  }

  Future<void> ackRestart() async {
    if (state.isIdle) return;
    final duration = state.totalDuration;
    final cueCount = state.cues.isEmpty
        ? 0
        : state.cues.map((c) => c.stage).reduce((a, b) => a > b ? a : b);
    final spacing = state.cues.length > 1
        ? state.cues[state.cues.length - 1].offsetFromEnd -
            state.cues[state.cues.length - 2].offsetFromEnd
        : const Duration(seconds: 30);
    await _clearEscalation();
    await _notifications.cancelAll();
    await _audio.stopAll();
    await arm(duration, cueCount: cueCount, cueSpacing: spacing);
    debugPrint('[FieldTimer] Restarted');
  }

  Future<void> ackEnd() async {
    await cancel();
    debugPrint('[FieldTimer] Ended by user');
  }

  Future<void> cancel() async {
    _tickTimer?.cancel();
    _tickTimer = null;
    await _clearEscalation();
    await _notifications.cancelAll();
    await _audio.stopAll();
    state = const FieldTimerSession.idle();
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _escalationTimer?.cancel();
    super.dispose();
  }

  // ── Internal ───────────────────────────────────────────────────────────

  void _startTick() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!state.isArmed) return;

    final newElapsed = state.elapsed + const Duration(seconds: 1);
    final remaining = state.totalDuration - newElapsed;

    // Dispatch any cues whose offset has been crossed.
    final updatedCues = state.cues.map((cue) {
      if (!cue.fired && remaining <= cue.offsetFromEnd) {
        _dispatchCue(cue.stage);
        return cue.copyWith(fired: true);
      }
      return cue;
    }).toList();

    if (remaining <= Duration.zero) {
      // T=0: transition to firing
      _tickTimer?.cancel();
      _tickTimer = null;
      state = state.copyWith(
        state: FieldTimerState.firing,
        elapsed: state.totalDuration,
        cues: updatedCues,
        escalationCount: 0,
      );
      _onFired();
    } else {
      state = state.copyWith(elapsed: newElapsed, cues: updatedCues);
    }
  }

  void _dispatchCue(int stage) {
    debugPrint('[FieldTimer] Cue stage $stage');
    _audio.playCueStage(stage);
  }

  void _onFired() {
    debugPrint('[FieldTimer] FIRED — sending page');
    _audio.playPage();
    _notifications.showTimerFired(
      title: _firingTitle,
      body: _firingBody,
      escalationCount: 0,
    );
    // Pre-schedule exact-alarm wakeup notifications so escalation pages fire
    // even when the screen is off and the Dart isolate is throttled.
    _scheduleBackgroundEscalations();
    _startEscalation();
  }

  Future<void> _scheduleBackgroundEscalations() async {
    final intervalSeconds =
        await FieldTimerSettings.getEscalationIntervalSeconds();
    await _notifications.scheduleEscalations(
      intervalSeconds: intervalSeconds,
      title: _firingTitle,
      body: _firingBody,
    );
  }

  Future<void> _startEscalation() async {
    final intervalSeconds =
        await FieldTimerSettings.getEscalationIntervalSeconds();
    _escalationTimer?.cancel();
    _escalationTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => _escalate(),
    );
  }

  void _escalate() {
    if (!state.isFiring) {
      _escalationTimer?.cancel();
      return;
    }
    final count = state.escalationCount + 1;
    state = state.copyWith(escalationCount: count);
    debugPrint('[FieldTimer] Escalation #$count');
    _audio.playPage();
    _notifications.showTimerFired(
      title: _firingTitle,
      body: _firingBody,
      escalationCount: count,
    );
  }

  Future<void> _clearEscalation() async {
    _escalationTimer?.cancel();
    _escalationTimer = null;
  }
}
