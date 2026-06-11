import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/features/field_timers/models/field_timer_preset.dart';
import 'package:dune_awakening_companion/features/field_timers/models/field_timer_session.dart';

void main() {
  group('FieldTimerPreset.buildCues', () {
    test('returns empty list when cueCount is 0', () {
      const preset = FieldTimerPreset(
        id: 'test',
        labelKey: 'k',
        duration: Duration(minutes: 3),
        cueCount: 0,
        cueSpacing: Duration(seconds: 30),
      );
      expect(preset.buildCues(), isEmpty);
    });

    test('cue count matches requested count', () {
      const preset = FieldTimerPreset(
        id: 'test',
        labelKey: 'k',
        duration: Duration(minutes: 3),
        cueCount: 3,
        cueSpacing: Duration(seconds: 30),
      );
      final cues = preset.buildCues();
      expect(cues.length, 3);
    });

    test('cue stages are numbered 1..cueCount', () {
      const preset = FieldTimerPreset(
        id: 'test',
        labelKey: 'k',
        duration: Duration(minutes: 3),
        cueCount: 4,
        cueSpacing: Duration(seconds: 30),
      );
      final stages = preset.buildCues().map((c) => c.stage).toList();
      expect(stages, [1, 2, 3, 4]);
    });

    test('cue offsets decrease by spacing from the end', () {
      // cueCount=3, spacing=30s → offsets should be 90s, 60s, 30s (earliest first)
      const preset = FieldTimerPreset(
        id: 'test',
        labelKey: 'k',
        duration: Duration(minutes: 3),
        cueCount: 3,
        cueSpacing: Duration(seconds: 30),
      );
      final offsets =
          preset.buildCues().map((c) => c.offsetFromEnd.inSeconds).toList();
      expect(offsets, [90, 60, 30]);
    });

    test('cues beyond duration are clamped / none exceed duration', () {
      // 4 cues at 60s spacing on a 2:30 timer → only 2 fit (120s, 60s)
      const preset = FieldTimerPreset(
        id: 'test',
        labelKey: 'k',
        duration: Duration(minutes: 2, seconds: 30),
        cueCount: 4,
        cueSpacing: Duration(seconds: 60),
      );
      final cues = preset.buildCues();
      for (final c in cues) {
        expect(c.offsetFromEnd < preset.duration, isTrue,
            reason: 'Cue at ${c.offsetFromEnd} exceeds duration');
      }
    });

    test('all cues start unfired', () {
      const preset = FieldTimerPreset(
        id: 'test',
        labelKey: 'k',
        duration: Duration(minutes: 3),
        cueCount: 3,
        cueSpacing: Duration(seconds: 30),
      );
      expect(preset.buildCues().every((c) => !c.fired), isTrue);
    });
  });

  group('FieldTimerSession', () {
    test('idle session has zero remaining', () {
      const s = FieldTimerSession.idle();
      expect(s.isIdle, isTrue);
      expect(s.remaining, Duration.zero);
    });

    test('remaining = totalDuration - elapsed', () {
      const s = FieldTimerSession(
        state: FieldTimerState.armed,
        totalDuration: Duration(minutes: 3),
        elapsed: Duration(seconds: 30),
        cues: [],
        escalationCount: 0,
      );
      expect(s.remaining, const Duration(minutes: 2, seconds: 30));
    });

    test('remaining clamps to zero when elapsed > totalDuration', () {
      const s = FieldTimerSession(
        state: FieldTimerState.firing,
        totalDuration: Duration(minutes: 3),
        elapsed: Duration(minutes: 4),
        cues: [],
        escalationCount: 0,
      );
      expect(s.remaining, Duration.zero);
    });

    test('progress is 0.0 at start', () {
      const s = FieldTimerSession(
        state: FieldTimerState.armed,
        totalDuration: Duration(minutes: 3),
        elapsed: Duration.zero,
        cues: [],
        escalationCount: 0,
      );
      expect(s.progress, 0.0);
    });

    test('progress is 1.0 when elapsed == totalDuration', () {
      const s = FieldTimerSession(
        state: FieldTimerState.firing,
        totalDuration: Duration(minutes: 3),
        elapsed: Duration(minutes: 3),
        cues: [],
        escalationCount: 0,
      );
      expect(s.progress, 1.0);
    });

    test('nextCue returns first unfired cue', () {
      final cues = [
        FieldTimerCue(
            stage: 1, offsetFromEnd: const Duration(seconds: 90), fired: true),
        FieldTimerCue(
            stage: 2, offsetFromEnd: const Duration(seconds: 60), fired: false),
        FieldTimerCue(
            stage: 3, offsetFromEnd: const Duration(seconds: 30), fired: false),
      ];
      final s = FieldTimerSession(
        state: FieldTimerState.armed,
        totalDuration: const Duration(minutes: 3),
        elapsed: Duration.zero,
        cues: cues,
        escalationCount: 0,
      );
      expect(s.nextCue?.stage, 2);
    });

    test('nextCue returns null when all cues are fired', () {
      final cues = [
        FieldTimerCue(
            stage: 1, offsetFromEnd: const Duration(seconds: 30), fired: true),
      ];
      final s = FieldTimerSession(
        state: FieldTimerState.armed,
        totalDuration: const Duration(minutes: 3),
        elapsed: Duration.zero,
        cues: cues,
        escalationCount: 0,
      );
      expect(s.nextCue, isNull);
    });

    test('copyWith replaces only specified fields', () {
      const original = FieldTimerSession(
        state: FieldTimerState.armed,
        totalDuration: Duration(minutes: 3),
        elapsed: Duration(seconds: 10),
        cues: [],
        escalationCount: 0,
      );
      final updated = original.copyWith(escalationCount: 2);
      expect(updated.escalationCount, 2);
      expect(updated.state, FieldTimerState.armed);
      expect(updated.elapsed, const Duration(seconds: 10));
    });
  });

  group('FieldTimerCue', () {
    test('copyWith(fired: true) creates a fired copy', () {
      final cue =
          FieldTimerCue(stage: 1, offsetFromEnd: const Duration(seconds: 30));
      expect(cue.fired, isFalse);
      final fired = cue.copyWith(fired: true);
      expect(fired.fired, isTrue);
      expect(fired.stage, 1);
    });
  });
}
