import 'field_timer_preset.dart';

enum FieldTimerState { idle, armed, firing }

/// The full state payload for one field timer session.
///
/// Immutable — [FieldTimerService] produces new instances on each tick/event.
class FieldTimerSession {
  const FieldTimerSession.idle()
      : state = FieldTimerState.idle,
        totalDuration = Duration.zero,
        elapsed = Duration.zero,
        cues = const [],
        escalationCount = 0;

  const FieldTimerSession({
    required this.state,
    required this.totalDuration,
    required this.elapsed,
    required this.cues,
    required this.escalationCount,
  });

  final FieldTimerState state;
  final Duration totalDuration;
  final Duration elapsed;
  final List<FieldTimerCue> cues;

  /// How many times the T=0 page has been re-sent via escalation.
  final int escalationCount;

  Duration get remaining => (totalDuration - elapsed).isNegative
      ? Duration.zero
      : totalDuration - elapsed;

  bool get isIdle => state == FieldTimerState.idle;
  bool get isArmed => state == FieldTimerState.armed;
  bool get isFiring => state == FieldTimerState.firing;

  /// Fraction 0.0→1.0 of the window elapsed (for progress bar).
  double get progress => totalDuration == Duration.zero
      ? 0
      : elapsed.inMilliseconds / totalDuration.inMilliseconds;

  /// Which cue stage fires next (largest offsetFromEnd among unfired = soonest to fire).
  FieldTimerCue? get nextCue => cues.where((c) => !c.fired).firstOrNull;

  FieldTimerSession copyWith({
    FieldTimerState? state,
    Duration? totalDuration,
    Duration? elapsed,
    List<FieldTimerCue>? cues,
    int? escalationCount,
  }) =>
      FieldTimerSession(
        state: state ?? this.state,
        totalDuration: totalDuration ?? this.totalDuration,
        elapsed: elapsed ?? this.elapsed,
        cues: cues ?? this.cues,
        escalationCount: escalationCount ?? this.escalationCount,
      );
}
