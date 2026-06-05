import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

import '../../bases/providers/base_provider.dart';
import '../../characters/models/character.dart';
import '../../characters/providers/character_provider.dart';
import '../models/base_calculator_state.dart';
import '../providers/base_calculator_plan_provider.dart';

/// Collects plan metadata and saves or updates a calculator snapshot.
Future<bool?> showBaseCalculatorSavePlanDialog({
  required BuildContext context,
  required WidgetRef ref,
  required BaseCalculatorState state,
  String? initialName,
  String? initialCharacterId,
  String? initialBaseId,
  String? existingPlanId,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => _SavePlanDialog(
      state: state,
      initialName: initialName,
      initialCharacterId: initialCharacterId,
      initialBaseId: initialBaseId,
      existingPlanId: existingPlanId,
    ),
  );
}

class _SavePlanDialog extends ConsumerStatefulWidget {
  const _SavePlanDialog({
    required this.state,
    this.initialName,
    this.initialCharacterId,
    this.initialBaseId,
    this.existingPlanId,
  });

  final BaseCalculatorState state;
  final String? initialName;
  final String? initialCharacterId;
  final String? initialBaseId;
  final String? existingPlanId;

  @override
  ConsumerState<_SavePlanDialog> createState() => _SavePlanDialogState();
}

class _SavePlanDialogState extends ConsumerState<_SavePlanDialog> {
  late final TextEditingController _nameController;
  String? _characterId;
  String? _baseId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _characterId = widget.initialCharacterId;
    _baseId = widget.initialBaseId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save({required bool asNew}) async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    try {
      final editor = ref.read(baseCalculatorPlanEditorProvider);
      if (!asNew &&
          widget.existingPlanId != null &&
          widget.existingPlanId!.isNotEmpty) {
        await editor.updateExisting(
          planId: widget.existingPlanId!,
          name: name,
          state: widget.state,
          characterId: _characterId,
          baseId: _baseId,
        );
      } else {
        await editor.saveNew(
          name: name,
          state: widget.state,
          characterId: _characterId,
          baseId: _baseId,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.baseCalculatorPlanSaved)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final charactersAsync = ref.watch(charactersProvider);
    final basesAsync = ref.watch(basesProvider);
    final canUpdate = widget.existingPlanId != null;

    return AlertDialog(
      title: Text(l10n.baseCalculatorSavePlan),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.baseCalculatorPlanName,
                hintText: l10n.baseCalculatorPlanNameHint,
              ),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              enabled: !_saving,
            ),
            const SizedBox(height: 16),
            charactersAsync.when(
              data: (characters) => _CharacterDropdown(
                characters: characters,
                value: _characterId,
                enabled: !_saving,
                onChanged: (value) {
                  setState(() {
                    _characterId = value;
                    if (value == null ||
                        _baseId == null ||
                        !basesAsync.maybeWhen(
                          data: (bases) => bases
                              .any((b) => b.id == _baseId && b.characterId == value),
                          orElse: () => false,
                        )) {
                      _baseId = null;
                    }
                  });
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            basesAsync.when(
              data: (bases) {
                final filtered = _characterId == null
                    ? bases
                    : bases.where((b) => b.characterId == _characterId).toList();
                return DropdownButtonFormField<String?>(
                  value: filtered.any((b) => b.id == _baseId) ? _baseId : null,
                  decoration: InputDecoration(
                    labelText: l10n.baseCalculatorLinkBase,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.baseCalculatorNone),
                    ),
                    ...filtered.map(
                      (base) => DropdownMenuItem<String?>(
                        value: base.id,
                        child: Text(base.name),
                      ),
                    ),
                  ],
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _baseId = value),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        if (canUpdate)
          TextButton(
            onPressed: _saving ? null : () => _save(asNew: true),
            child: Text(l10n.baseCalculatorSaveAsNew),
          ),
        FilledButton(
          onPressed: _saving ? null : () => _save(asNew: !canUpdate),
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(canUpdate ? l10n.baseCalculatorUpdatePlan : l10n.save),
        ),
      ],
    );
  }
}

class _CharacterDropdown extends StatelessWidget {
  const _CharacterDropdown({
    required this.characters,
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final List<Character> characters;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String?>(
      value: characters.any((c) => c.id == value) ? value : null,
      decoration: InputDecoration(
        labelText: l10n.baseCalculatorLinkCharacter,
      ),
      items: [
        DropdownMenuItem<String?>(
          value: null,
          child: Text(l10n.baseCalculatorNone),
        ),
        ...characters.map(
          (character) => DropdownMenuItem<String?>(
            value: character.id,
            child: Text(character.name),
          ),
        ),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}
