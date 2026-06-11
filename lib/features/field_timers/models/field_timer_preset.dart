/// An immutable preset definition for a field timer (e.g. "Sand Harvest 3:00").
class FieldTimerPreset {
  const FieldTimerPreset({
    required this.id,
    required this.labelKey,
    required this.duration,
    this.cueCount = 3,
    this.cueSpacing = const Duration(seconds: 30),
  });

  final String id;

  /// ARB key used to look up the localised label.
  final String labelKey;

  final Duration duration;

  /// How many pre-alarm cues to play (0 disables cue track).
  final int cueCount;

  /// Time between consecutive cue stages, counted back from T=0.
  final Duration cueSpacing;

  /// Generates the cue schedule for this preset.
  /// Returns cues sorted ascending by [offsetFromEnd] (earliest fire first).
  List<FieldTimerCue> buildCues() {
    if (cueCount == 0) return const [];
    return List.generate(cueCount, (i) {
      final stage = cueCount - i;
      final offsetFromEnd = cueSpacing * (i + 1);
      return FieldTimerCue(stage: stage, offsetFromEnd: offsetFromEnd);
    })
      ..removeWhere((c) => c.offsetFromEnd >= duration)
      ..sort((a, b) => b.offsetFromEnd.compareTo(a.offsetFromEnd));
  }
}

/// A single pre-alarm cue event in a timer session.
class FieldTimerCue {
  FieldTimerCue({
    required this.stage,
    required this.offsetFromEnd,
    this.fired = false,
  });

  /// 1-based stage index — higher stages are more urgent (closer to T=0).
  final int stage;

  /// How far before T=0 this cue fires (e.g. Duration(seconds: 60)).
  final Duration offsetFromEnd;

  bool fired;

  FieldTimerCue copyWith({bool? fired}) => FieldTimerCue(
        stage: stage,
        offsetFromEnd: offsetFromEnd,
        fired: fired ?? this.fired,
      );
}

/// Built-in sand harvest presets. All values are editable by the user at
/// run-time; these serve as seeds only.
const sandHarvestPresets = [
  FieldTimerPreset(
    id: 'sand_230',
    labelKey: 'fieldTimerPreset230',
    duration: Duration(minutes: 2, seconds: 30),
  ),
  FieldTimerPreset(
    id: 'sand_300',
    labelKey: 'fieldTimerPreset300',
    duration: Duration(minutes: 3),
  ),
  FieldTimerPreset(
    id: 'sand_330',
    labelKey: 'fieldTimerPreset330',
    duration: Duration(minutes: 3, seconds: 30),
  ),
  FieldTimerPreset(
    id: 'sand_400',
    labelKey: 'fieldTimerPreset400',
    duration: Duration(minutes: 4),
  ),
];
