import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_colors.dart';
import '../models/field_timer_preset.dart';
import '../models/field_timer_session.dart';
import '../providers/field_timer_provider.dart';

class FieldTimerScreen extends ConsumerStatefulWidget {
  const FieldTimerScreen({super.key});

  @override
  ConsumerState<FieldTimerScreen> createState() => _FieldTimerScreenState();
}

class _FieldTimerScreenState extends ConsumerState<FieldTimerScreen> {
  /// Custom duration the user is editing (null = using preset).
  Duration? _customDuration;

  /// Selected preset index in [sandHarvestPresets].
  int _selectedPresetIndex = 1; // default 3:00

  Duration get _activeDuration =>
      _customDuration ?? sandHarvestPresets[_selectedPresetIndex].duration;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(fieldTimerProvider);

    // Inject localized strings into the service before any arm call.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fieldTimerProvider.notifier).setNotificationStrings(
            l10n.fieldTimerFiringTitle,
            l10n.fieldTimerFiringBody,
            cueTitle: l10n.fieldTimerCueTitle,
            cueBody: l10n.fieldTimerCueBody,
          );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fieldTimerTitle),
      ),
      body: switch (session.state) {
        FieldTimerState.idle => _IdleBody(
            selectedPresetIndex: _selectedPresetIndex,
            customDuration: _customDuration,
            onPresetSelected: (i) => setState(() {
              _selectedPresetIndex = i;
              _customDuration = null;
            }),
            onCustomDuration: (d) => setState(() => _customDuration = d),
            onStart: _arm,
          ),
        FieldTimerState.armed =>
          _ArmedBody(session: session, onCancel: _cancel),
        FieldTimerState.firing => _FiringBody(
            session: session,
            onRestart: _restart,
            onEnd: _end,
          ),
      },
    );
  }

  Future<void> _arm() async {
    await ref.read(fieldTimerProvider.notifier).arm(_activeDuration);
  }

  Future<void> _cancel() async {
    await ref.read(fieldTimerProvider.notifier).cancel();
  }

  Future<void> _restart() async {
    await ref.read(fieldTimerProvider.notifier).ackRestart();
  }

  Future<void> _end() async {
    await ref.read(fieldTimerProvider.notifier).ackEnd();
  }
}

// ── Idle body ─────────────────────────────────────────────────────────────────

class _IdleBody extends StatelessWidget {
  const _IdleBody({
    required this.selectedPresetIndex,
    required this.customDuration,
    required this.onPresetSelected,
    required this.onCustomDuration,
    required this.onStart,
  });

  final int selectedPresetIndex;
  final Duration? customDuration;
  final ValueChanged<int> onPresetSelected;
  final ValueChanged<Duration> onCustomDuration;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isCustom = customDuration != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Disclaimer
          Card(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.fieldTimerDisclaimer,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section label
          Text(
            l10n.fieldTimerSandHarvest,
            style: theme.textTheme.titleMedium
                ?.copyWith(color: DuneColors.cautionPrimary),
          ),
          const SizedBox(height: 12),

          // Preset chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < sandHarvestPresets.length; i++)
                _PresetChip(
                  label: _formatDuration(sandHarvestPresets[i].duration),
                  selected: !isCustom && selectedPresetIndex == i,
                  onTap: () => onPresetSelected(i),
                ),
              // Custom chip
              _PresetChip(
                label: isCustom
                    ? _formatDuration(customDuration!)
                    : l10n.fieldTimerCustom,
                selected: isCustom,
                onTap: () => _pickCustomDuration(context),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Large duration display
          Center(
            child: Text(
              isCustom
                  ? _formatDuration(customDuration!)
                  : _formatDuration(
                      sandHarvestPresets[selectedPresetIndex].duration),
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: DuneColors.cautionPrimary,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Start button
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            label: Text(l10n.fieldTimerStart),
            style: FilledButton.styleFrom(
              backgroundColor: DuneColors.cautionPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          const SizedBox(height: 24),
          // Keep-app-open hint
          Center(
            child: Text(
              l10n.fieldTimerKeepAppOpenHint,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomDuration(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: customDuration != null ? '${customDuration!.inSeconds ~/ 60}' : '',
    );

    final result = await showDialog<Duration>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.fieldTimerCustomDurationTitle),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.fieldTimerCustomDurationLabel,
            suffixText: l10n.fieldTimerMinutes,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final minutes = int.tryParse(controller.text);
              if (minutes != null && minutes > 0) {
                Navigator.pop(ctx, Duration(minutes: minutes));
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (result != null) onCustomDuration(result);
  }
}

// ── Armed body ────────────────────────────────────────────────────────────────

class _ArmedBody extends StatelessWidget {
  const _ArmedBody({required this.session, required this.onCancel});

  final FieldTimerSession session;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final remaining = session.remaining;
    final nextCue = session.nextCue;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),

          // Big countdown
          Text(
            _formatDuration(remaining),
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: _countdownColor(remaining, session.totalDuration),
              letterSpacing: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.fieldTimerRemaining,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          // Progress bar with cue markers
          _CueProgressBar(session: session),
          const SizedBox(height: 16),

          // Next cue hint
          if (nextCue != null)
            Text(
              l10n.fieldTimerNextCueIn(
                nextCue.stage,
                _formatDuration(remaining - nextCue.offsetFromEnd),
              ),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),

          const Spacer(),

          // Cancel
          OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.stop),
            label: Text(l10n.fieldTimerCancel),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.fieldTimerKeepAppOpenHint,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _countdownColor(Duration remaining, Duration total) {
    if (total == Duration.zero) return DuneColors.cautionPrimary;
    final fraction = remaining.inSeconds / total.inSeconds;
    if (fraction < 0.25) return DuneColors.criticalPrimary;
    if (fraction < 0.5) return DuneColors.warningPrimary;
    return DuneColors.cautionPrimary;
  }
}

// ── Firing body ───────────────────────────────────────────────────────────────

class _FiringBody extends StatelessWidget {
  const _FiringBody({
    required this.session,
    required this.onRestart,
    required this.onEnd,
  });

  final FieldTimerSession session;
  final VoidCallback onRestart;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          // Alert icon
          const Icon(
            Icons.warning_rounded,
            size: 80,
            color: DuneColors.criticalPrimary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.fieldTimerFiringTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: DuneColors.criticalPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.fieldTimerFiringBody,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (session.escalationCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              l10n.fieldTimerEscalationCount(session.escalationCount),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const Spacer(),

          // Reset aggro (restart)
          FilledButton.icon(
            onPressed: onRestart,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.fieldTimerResetAggro),
            style: FilledButton.styleFrom(
              backgroundColor: DuneColors.criticalPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 12),

          // End run
          OutlinedButton.icon(
            onPressed: onEnd,
            icon: const Icon(Icons.check_circle_outline),
            label: Text(l10n.fieldTimerEndRun),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Progress bar with cue markers ─────────────────────────────────────────────

class _CueProgressBar extends StatelessWidget {
  const _CueProgressBar({required this.session});

  final FieldTimerSession session;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: 24,
          child: Stack(
            children: [
              // Background track
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: session.progress,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: DuneColors.cautionPrimary,
                    minHeight: 8,
                  ),
                ),
              ),
              // Cue markers
              for (final cue in session.cues)
                Positioned(
                  left: _markerX(cue, width),
                  top: 0,
                  bottom: 0,
                  child: _CueMarker(stage: cue.stage, fired: cue.fired),
                ),
            ],
          ),
        );
      },
    );
  }

  double _markerX(FieldTimerCue cue, double totalWidth) {
    if (session.totalDuration == Duration.zero) return 0;
    final fraction = 1.0 -
        (cue.offsetFromEnd.inMilliseconds /
            session.totalDuration.inMilliseconds);
    return (fraction * totalWidth - 8).clamp(0.0, totalWidth - 16);
  }
}

class _CueMarker extends StatelessWidget {
  const _CueMarker({required this.stage, required this.fired});

  final int stage;
  final bool fired;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: fired
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
            : DuneColors.warningPrimary,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$stage',
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ── Preset chip ───────────────────────────────────────────────────────────────

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: DuneColors.cautionPrimary.withOpacity(0.2),
      checkmarkColor: DuneColors.cautionPrimary,
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _formatDuration(Duration d) {
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$m:$s';
}
