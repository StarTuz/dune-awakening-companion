import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/constants.dart';
import '../../augmentations/models/augmentation.dart';
import '../../augmentations/models/augmentation_catalog.dart';
import '../../augmentations/providers/augmentation_provider.dart';
import '../../class_quests/models/class_quest_catalog.dart';
import '../../class_quests/models/class_quest_progress.dart';
import '../../class_quests/providers/class_quest_provider.dart';
import '../../factions/models/faction_progress.dart';
import '../../factions/providers/faction_progress_provider.dart';
import '../../skills/models/character_skill.dart';
import '../../skills/models/skill_catalog.dart';
import '../../skills/providers/skill_provider.dart';
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
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${character.name} Progress'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Specializations'),
              Tab(text: 'Class Quests'),
              Tab(text: 'Skill Planner'),
              Tab(text: 'Factions'),
              Tab(text: 'Augments'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _SpecializationsTab(character: character),
            _ClassQuestsTab(character: character),
            _SkillPlannerTab(character: character),
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

class _ClassQuestsTab extends ConsumerWidget {
  const _ClassQuestsTab({required this.character});

  final Character character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(classQuestProgressProvider(character.id));

    return progressAsync.when(
      data: (progressEntries) {
        final byQuestId = {
          for (final progress in progressEntries) progress.questId: progress,
        };
        final basicSkipped = character.primaryClass == null
            ? 'Set this character’s starting class to auto-skip that basic unlock quest.'
            : '${character.primaryClass} basic training is treated as already available for this character.';

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('Class Quests'),
                subtitle: Text(
                  '$basicSkipped Planetologist is always tracked as a secondary unlock.',
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...classQuestCatalog.map(
              (entry) => _ClassQuestCard(
                character: character,
                entry: entry,
                progress: byQuestId[entry.id],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _ClassQuestCard extends ConsumerWidget {
  const _ClassQuestCard({
    required this.character,
    required this.entry,
    required this.progress,
  });

  final Character character;
  final ClassQuestCatalogEntry entry;
  final ClassQuestProgress? progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStartingClassBasic =
        entry.isBasic && character.primaryClass == entry.className;
    final effectiveStatus = isStartingClassBasic
        ? ClassQuestStatus.notRequired
        : progress?.status ?? ClassQuestStatus.notStarted;
    final stepsAsync = progress == null
        ? const AsyncValue<List<ClassQuestStepProgress>>.data([])
        : ref.watch(classQuestStepsProvider(progress!.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.className} - ${_tierLabel(entry.tier)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(entry.questName),
                    ],
                  ),
                ),
                Chip(label: Text(_statusLabel(effectiveStatus))),
              ],
            ),
            const SizedBox(height: 8),
            Text('Trainer: ${entry.trainerName}'),
            Text('Location: ${entry.trainerLocation}'),
            const SizedBox(height: 8),
            Text(entry.summary),
            if (entry.prerequisites.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.prerequisites
                    .map((item) => Chip(label: Text(item)))
                    .toList(),
              ),
            ],
            if (entry.rewards != null) ...[
              const SizedBox(height: 8),
              Text('Rewards: ${entry.rewards}'),
            ],
            if (entry.notes != null) ...[
              const SizedBox(height: 8),
              Text(entry.notes!),
            ],
            const SizedBox(height: 12),
            stepsAsync.when(
              data: (stepProgressEntries) {
                final completedSteps = {
                  for (final step in stepProgressEntries)
                    if (step.isCompleted) step.stepId,
                };
                return Column(
                  children: [
                    if (!isStartingClassBasic)
                      ...entry.steps.map(
                        (step) => CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: completedSteps.contains(step.id),
                          title: Text(step.title),
                          subtitle:
                              step.details == null ? null : Text(step.details!),
                          onChanged: (value) {
                            ref.read(classQuestEditorProvider).toggleStep(
                                  characterId: character.id,
                                  questId: entry.id,
                                  stepId: step.id,
                                  isCompleted: value ?? false,
                                );
                          },
                        ),
                      ),
                    if (isStartingClassBasic)
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.check_circle_outline),
                        title: Text(
                          'Basic unlock skipped by starting class choice',
                        ),
                      ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => Text('Step error: $error'),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (!isStartingClassBasic &&
                    effectiveStatus == ClassQuestStatus.notStarted)
                  OutlinedButton(
                    onPressed: () =>
                        ref.read(classQuestEditorProvider).setStatus(
                              characterId: character.id,
                              questId: entry.id,
                              status: ClassQuestStatus.inProgress,
                            ),
                    child: const Text('Start'),
                  ),
                if (!isStartingClassBasic &&
                    effectiveStatus != ClassQuestStatus.completed)
                  FilledButton(
                    onPressed: () =>
                        ref.read(classQuestEditorProvider).setStatus(
                              characterId: character.id,
                              questId: entry.id,
                              status: ClassQuestStatus.completed,
                            ),
                    child: const Text('Complete'),
                  ),
                if (!isStartingClassBasic &&
                    effectiveStatus != ClassQuestStatus.notStarted)
                  TextButton(
                    onPressed: () =>
                        ref.read(classQuestEditorProvider).setStatus(
                              characterId: character.id,
                              questId: entry.id,
                              status: ClassQuestStatus.notStarted,
                            ),
                    child: const Text('Reset status'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _tierLabel(String tier) {
    return tier == ClassQuestTier.basic ? 'Basic Unlock' : 'Advanced Chain';
  }

  String _statusLabel(String status) {
    return switch (status) {
      ClassQuestStatus.notRequired => 'Not required',
      ClassQuestStatus.inProgress => 'In progress',
      ClassQuestStatus.completed => 'Completed',
      _ => 'Not started',
    };
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

class _AugmentationsTab extends ConsumerStatefulWidget {
  const _AugmentationsTab({required this.character});

  final Character character;

  @override
  ConsumerState<_AugmentationsTab> createState() => _AugmentationsTabState();
}

class _AugmentationsTabState extends ConsumerState<_AugmentationsTab> {
  String _augmentationSearchQuery = '';
  final TextEditingController _augmentationSearchController =
      TextEditingController();

  @override
  void dispose() {
    _augmentationSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final augmentationsAsync =
        ref.watch(augmentationsProvider(widget.character.id));

    return Scaffold(
      body: augmentationsAsync.when(
        data: (augmentations) {
          final rows = _buildAugmentationRows(augmentations);
          final visibleRows =
              rows.where(_passesAugmentationSearchFilter).toList();
          final acquiredCount = rows.where((row) => row.isAcquired).length;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '$acquiredCount / ${augmentationCatalog.length} '
                    'catalog augments acquired',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _augmentationSearchController,
                decoration: InputDecoration(
                  labelText: 'Search augments',
                  hintText: 'Name, slot, source, notes',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _augmentationSearchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            _augmentationSearchController.clear();
                            setState(() => _augmentationSearchQuery = '');
                          },
                          icon: const Icon(Icons.clear),
                        ),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) =>
                    setState(() => _augmentationSearchQuery = value),
              ),
              const SizedBox(height: 8),
              ...visibleRows.map(
                (row) => Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: row.isAcquired,
                      onChanged: (_) => _toggleAcquired(ref, row),
                    ),
                    title: Text(row.name),
                    subtitle: Text(row.subtitle),
                    trailing: Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (row.isAcquired)
                          Tooltip(
                            message: 'Equipped',
                            child: Checkbox(
                              value: row.isEquipped,
                              onChanged: (value) {
                                final augmentation = row.augmentation;
                                if (augmentation == null) return;
                                ref.read(augmentationEditorProvider).save(
                                      augmentation.copyWith(
                                        isEquipped: value ?? false,
                                      ),
                                    );
                              },
                            ),
                          ),
                        IconButton(
                          onPressed: () => _showAugmentationDialog(
                            context,
                            ref,
                            row.augmentation,
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                        if (!row.isSeeded)
                          IconButton(
                            onPressed: () =>
                                ref.read(augmentationEditorProvider).delete(
                                      row.augmentation!.id,
                                      widget.character.id,
                                    ),
                            icon: const Icon(Icons.delete),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (visibleRows.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No augmentations match this search.'),
                  ),
                ),
            ],
          );
        },
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

  List<_AugmentationChecklistRow> _buildAugmentationRows(
    List<Augmentation> augmentations,
  ) {
    final byName = {
      for (final augmentation in augmentations)
        _augmentationKey(augmentation.name): augmentation,
    };
    final catalogRows = augmentationCatalog.map(
      (entry) => _AugmentationChecklistRow(
        entry: entry,
        augmentation: byName[_augmentationKey(entry.name)],
      ),
    );
    final customRows = augmentations
        .where((augmentation) => !augmentationCatalog.any(
              (entry) =>
                  _augmentationKey(entry.name) ==
                  _augmentationKey(augmentation.name),
            ))
        .map((augmentation) => _AugmentationChecklistRow(
              augmentation: augmentation,
            ));
    return [...catalogRows, ...customRows];
  }

  bool _passesAugmentationSearchFilter(_AugmentationChecklistRow row) {
    final query = _augmentationSearchQuery.trim().toLowerCase();
    if (query.isEmpty) return true;
    return row.searchText.contains(query);
  }

  Future<void> _toggleAcquired(
    WidgetRef ref,
    _AugmentationChecklistRow row,
  ) async {
    final now = DateTime.now();
    final existing = row.augmentation;
    if (existing != null) {
      final isAcquired = existing.acquiredAt != null;
      await ref.read(augmentationEditorProvider).save(
            existing.copyWith(
              acquiredAt: isAcquired ? null : now,
              isEquipped: isAcquired ? false : existing.isEquipped,
            ),
          );
      return;
    }

    final entry = row.entry!;
    await ref.read(augmentationEditorProvider).save(
          Augmentation(
            id: const Uuid().v4(),
            characterId: widget.character.id,
            name: entry.name,
            slot: entry.slot,
            sourceBoss: entry.sourceLabel,
            notes: '${entry.sourceGroup} • Tier ${entry.tier} ${entry.rarity}',
            acquiredAt: now,
            updatedAt: now,
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
                          characterId: widget.character.id,
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

class _AugmentationChecklistRow {
  final AugmentationCatalogEntry? entry;
  final Augmentation? augmentation;

  const _AugmentationChecklistRow({
    this.entry,
    this.augmentation,
  });

  bool get isSeeded => entry != null;

  String get name => augmentation?.name ?? entry!.name;

  String get slot => augmentation?.slot ?? entry!.slot;

  bool get isAcquired => augmentation?.acquiredAt != null;

  bool get isEquipped => augmentation?.isEquipped ?? false;

  String get subtitle {
    final parts = <String>[
      slot,
      if (entry != null) 'Tier ${entry!.tier} ${entry!.rarity}',
      if (entry != null) entry!.sourceGroup,
      if (augmentation?.sourceBoss != null) augmentation!.sourceBoss!,
    ];
    return parts.join(' • ');
  }

  String get searchText {
    return [
      name,
      slot,
      subtitle,
      entry?.sourceLabel,
      augmentation?.notes,
    ].whereType<String>().join(' ').toLowerCase();
  }
}

String _augmentationKey(String value) => value.trim().toLowerCase();

class _SkillPlannerTab extends ConsumerStatefulWidget {
  const _SkillPlannerTab({required this.character});

  final Character character;

  @override
  ConsumerState<_SkillPlannerTab> createState() => _SkillPlannerTabState();
}

class _SkillPlannerTabState extends ConsumerState<_SkillPlannerTab> {
  String _selectedClass = AppConstants.classBeneGesserit;

  @override
  void initState() {
    super.initState();
    if (widget.character.primaryClass != null &&
        AppConstants.allProgressionClasses
            .contains(widget.character.primaryClass)) {
      _selectedClass = widget.character.primaryClass!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(skillCatalogProvider);
    final skillsAsync = ref.watch(characterSkillsProvider(widget.character.id));

    return Scaffold(
      body: skillsAsync.when(
        data: (characterSkills) {
          final skillMap = {for (final s in characterSkills) s.skillId: s};
          final classSkills =
              catalog.where((s) => s.className == _selectedClass).toList();
          final trees = classSkills.map((s) => s.treeName).toSet().toList();

          int totalPoints = 0;
          for (final s in characterSkills) {
            final catalogEntry = catalog.firstWhere((c) => c.id == s.skillId,
                orElse: () => catalog.first);
            totalPoints += s.currentRank * catalogEntry.pointCostPerRank;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedClass,
                        items: AppConstants.allProgressionClasses
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedClass = val);
                        },
                        decoration: const InputDecoration(labelText: 'Class'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Total Points Spent'),
                        Text(
                          '$totalPoints / 200',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: totalPoints > 200 ? Colors.red : null,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: trees.length,
                  itemBuilder: (context, index) {
                    final treeName = trees[index];
                    final treeSkills = classSkills
                        .where((s) => s.treeName == treeName)
                        .toList();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              treeName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Divider(),
                            ...treeSkills.map((skill) {
                              final charSkill = skillMap[skill.id];
                              final currentRank = charSkill?.currentRank ?? 0;
                              final targetRank = charSkill?.targetRank ?? 0;
                              final isEquipped = charSkill?.isEquipped ?? false;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(skill.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              _SkillTypeBadge(type: skill.type),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Cost: ${skill.pointCostPerRank} pt/rank',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          if (skill.type == 'active' ||
                                              skill.type == 'technique') ...[
                                            const Text('Equip: '),
                                            Checkbox(
                                              value: isEquipped,
                                              onChanged: currentRank > 0
                                                  ? (val) => _updateSkill(
                                                      skill,
                                                      charSkill,
                                                      currentRank,
                                                      targetRank,
                                                      val ?? false)
                                                  : null,
                                            ),
                                          ],
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text('Rank: ',
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.remove,
                                                        size: 16),
                                                    onPressed: currentRank > 0
                                                        ? () => _updateSkill(
                                                            skill,
                                                            charSkill,
                                                            currentRank - 1,
                                                            targetRank,
                                                            isEquipped)
                                                        : null,
                                                  ),
                                                  Text(
                                                      '$currentRank / ${skill.maxRank}'),
                                                  IconButton(
                                                    icon: const Icon(Icons.add,
                                                        size: 16),
                                                    onPressed: currentRank <
                                                            skill.maxRank
                                                        ? () => _updateSkill(
                                                            skill,
                                                            charSkill,
                                                            currentRank + 1,
                                                            targetRank,
                                                            isEquipped)
                                                        : null,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text('Target: ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey)),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.remove,
                                                        size: 16),
                                                    color: Colors.grey,
                                                    onPressed: targetRank > 0
                                                        ? () => _updateSkill(
                                                            skill,
                                                            charSkill,
                                                            currentRank,
                                                            targetRank - 1,
                                                            isEquipped)
                                                        : null,
                                                  ),
                                                  Text(
                                                      '$targetRank / ${skill.maxRank}',
                                                      style: const TextStyle(
                                                          color: Colors.grey)),
                                                  IconButton(
                                                    icon: const Icon(Icons.add,
                                                        size: 16),
                                                    color: Colors.grey,
                                                    onPressed: targetRank <
                                                            skill.maxRank
                                                        ? () => _updateSkill(
                                                            skill,
                                                            charSkill,
                                                            currentRank,
                                                            targetRank + 1,
                                                            isEquipped)
                                                        : null,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _updateSkill(SkillCatalogEntry catalogEntry, CharacterSkill? existing,
      int newCurrent, int newTarget, bool newEquipped) {
    if (newTarget < newCurrent) newTarget = newCurrent;

    if (newCurrent == 0) newEquipped = false;

    final updated = (existing ??
            CharacterSkill(
              id: const Uuid().v4(),
              characterId: widget.character.id,
              skillId: catalogEntry.id,
              currentRank: 0,
              isEquipped: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ))
        .copyWith(
      currentRank: newCurrent,
      targetRank: newTarget,
      isEquipped: newEquipped,
      updatedAt: DateTime.now(),
    );

    ref.read(characterSkillEditorProvider).save(updated);
  }
}

class _SkillTypeBadge extends StatelessWidget {
  const _SkillTypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, bg, fg) = switch (type) {
      'active' => ('ABILITY', scheme.primary, scheme.onPrimary),
      'technique' => ('TECHNIQUE', scheme.secondary, scheme.onSecondary),
      _ => (
          'PASSIVE',
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
