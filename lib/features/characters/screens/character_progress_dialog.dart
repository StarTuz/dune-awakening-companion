import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../augmentations/models/augmentation.dart';
import '../../augmentations/providers/augmentation_provider.dart';
import '../../factions/models/faction_progress.dart';
import '../../factions/providers/faction_progress_provider.dart';
import '../../specializations/providers/character_specialization_provider.dart';
import '../models/character.dart';

class CharacterProgressDialog extends ConsumerWidget {
  const CharacterProgressDialog({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${character.name} Progress'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Specializations'),
              Tab(text: 'Factions'),
              Tab(text: 'Augments'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _SpecializationsTab(character: character),
            _FactionProgressTab(character: character),
            _AugmentationsTab(character: character),
          ],
        ),
      ),
    );
  }
}

class _SpecializationsTab extends ConsumerStatefulWidget {
  const _SpecializationsTab({required this.character});

  final Character character;

  @override
  ConsumerState<_SpecializationsTab> createState() =>
      _SpecializationsTabState();
}

class _SpecializationsTabState extends ConsumerState<_SpecializationsTab> {
  bool _initialized = false;
  late final Map<String, double> _levels = {
    'Combat': 0,
    'Crafting': 0,
    'Gathering': 0,
    'Exploration': 0,
    'Sabotage': 0,
  };

  @override
  Widget build(BuildContext context) {
    final specializationAsync =
        ref.watch(characterSpecializationProvider(widget.character.id));

    return specializationAsync.when(
      data: (specialization) {
        if (!_initialized) {
          _levels['Combat'] = specialization.combatLevel.toDouble();
          _levels['Crafting'] = specialization.craftingLevel.toDouble();
          _levels['Gathering'] = specialization.gatheringLevel.toDouble();
          _levels['Exploration'] = specialization.explorationLevel.toDouble();
          _levels['Sabotage'] = specialization.sabotageLevel.toDouble();
          _initialized = true;
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.auto_graph),
                title: const Text('Total Level'),
                subtitle: Text('${specialization.totalLevel} / 500'),
              ),
            ),
            const SizedBox(height: 12),
            ..._levels.entries.map(
              (entry) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}: ${entry.value.round()}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Slider(
                        value: entry.value,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: entry.value.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            _levels[entry.key] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final updated = specialization.copyWith(
                  combatLevel: _levels['Combat']!.round(),
                  craftingLevel: _levels['Crafting']!.round(),
                  gatheringLevel: _levels['Gathering']!.round(),
                  explorationLevel: _levels['Exploration']!.round(),
                  sabotageLevel: _levels['Sabotage']!.round(),
                );
                await ref
                    .read(characterSpecializationEditorProvider)
                    .save(updated);
                _initialized = false;
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Specializations saved')),
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Specializations'),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _FactionProgressTab extends ConsumerWidget {
  const _FactionProgressTab({required this.character});

  final Character character;

  static const _factions = [
    'Atreides',
    'Harkonnen',
    'Fremen',
    'Smugglers',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(factionProgressProvider(character.id));

    return Scaffold(
      body: progressAsync.when(
        data: (entries) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (entries.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No faction progress yet. Add your first entry.'),
                ),
              ),
            ...entries.map(
              (entry) => Card(
                child: ListTile(
                  title: Text(entry.factionName),
                  subtitle: Text(
                    'Rank ${entry.currentRank}/20 • ${entry.contractsCompleted} contracts',
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        onPressed: () =>
                            _showFactionDialog(context, ref, entry),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(factionProgressEditorProvider)
                            .delete(entry.id, character.id),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFactionDialog(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Add Faction'),
      ),
    );
  }

  void _showFactionDialog(
    BuildContext context,
    WidgetRef ref,
    FactionProgress? existing,
  ) {
    String selectedFaction = existing?.factionName ?? _factions.first;
    final rankController = TextEditingController(
      text: (existing?.currentRank ?? 1).toString(),
    );
    final reputationController = TextEditingController(
      text: existing?.reputationPoints?.toString() ?? '',
    );
    final contractsController = TextEditingController(
      text: (existing?.contractsCompleted ?? 0).toString(),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(existing == null
              ? 'Add Faction Progress'
              : 'Edit Faction Progress'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedFaction,
                items: _factions
                    .map((faction) =>
                        DropdownMenuItem(value: faction, child: Text(faction)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedFaction = value);
                  }
                },
                decoration: const InputDecoration(labelText: 'Faction'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: rankController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Rank (1-20)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reputationController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Reputation Points'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contractsController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Contracts Completed'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final progress = (existing ??
                        FactionProgress(
                          id: const Uuid().v4(),
                          characterId: character.id,
                          factionName: selectedFaction,
                          updatedAt: DateTime.now(),
                        ))
                    .copyWith(
                  factionName: selectedFaction,
                  currentRank:
                      (int.tryParse(rankController.text) ?? 1).clamp(1, 20),
                  reputationPoints: int.tryParse(reputationController.text),
                  contractsCompleted:
                      int.tryParse(contractsController.text) ?? 0,
                );
                await ref.read(factionProgressEditorProvider).save(progress);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AugmentationsTab extends ConsumerWidget {
  const _AugmentationsTab({required this.character});

  final Character character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final augmentationsAsync = ref.watch(augmentationsProvider(character.id));

    return Scaffold(
      body: augmentationsAsync.when(
        data: (augmentations) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (augmentations.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No augmentations tracked yet.'),
                ),
              ),
            ...augmentations.map(
              (augmentation) => Card(
                child: ListTile(
                  title: Text(augmentation.name),
                  subtitle: Text(
                    '${augmentation.slot}${augmentation.sourceBoss == null ? '' : ' • ${augmentation.sourceBoss}'}',
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      Checkbox(
                        value: augmentation.isEquipped,
                        onChanged: (value) {
                          ref.read(augmentationEditorProvider).save(
                                augmentation.copyWith(
                                    isEquipped: value ?? false),
                              );
                        },
                      ),
                      IconButton(
                        onPressed: () =>
                            _showAugmentationDialog(context, ref, augmentation),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(augmentationEditorProvider)
                            .delete(augmentation.id, character.id),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAugmentationDialog(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Add Augment'),
      ),
    );
  }

  void _showAugmentationDialog(
    BuildContext context,
    WidgetRef ref,
    Augmentation? existing,
  ) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final slotController = TextEditingController(text: existing?.slot ?? '');
    final bossController =
        TextEditingController(text: existing?.sourceBoss ?? '');
    final notesController = TextEditingController(text: existing?.notes ?? '');
    bool equipped = existing?.isEquipped ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title:
              Text(existing == null ? 'Add Augmentation' : 'Edit Augmentation'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: slotController,
                  decoration: const InputDecoration(labelText: 'Slot'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bossController,
                  decoration: const InputDecoration(labelText: 'Source Boss'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: equipped,
                  onChanged: (value) => setState(() => equipped = value),
                  title: const Text('Equipped'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final augmentation = (existing ??
                        Augmentation(
                          id: const Uuid().v4(),
                          characterId: character.id,
                          name: '',
                          slot: '',
                          updatedAt: DateTime.now(),
                        ))
                    .copyWith(
                  name: nameController.text,
                  slot: slotController.text,
                  sourceBoss:
                      bossController.text.isEmpty ? null : bossController.text,
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                  isEquipped: equipped,
                );
                await ref.read(augmentationEditorProvider).save(augmentation);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
