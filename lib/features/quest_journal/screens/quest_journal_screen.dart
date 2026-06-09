import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';
import '../../characters/models/character.dart';
import '../../characters/providers/character_provider.dart';
import '../models/quest.dart';
import '../models/quest_step.dart';
import '../providers/quest_provider.dart';

class QuestJournalScreen extends ConsumerStatefulWidget {
  const QuestJournalScreen({super.key, this.showAppBar = true});

  /// Set false when embedded in a host that provides its own app bar
  /// (e.g. the Journal hub's Quests tab).
  final bool showAppBar;

  @override
  ConsumerState<QuestJournalScreen> createState() => _QuestJournalScreenState();
}

class _QuestJournalScreenState extends ConsumerState<QuestJournalScreen> {
  String? selectedCharacterId;
  String _searchQuery = '';
  String? _statusFilter;
  String? _typeFilter;

  List<Quest> _applyFilters(List<Quest> quests) {
    return quests.where((q) {
      if (_statusFilter != null && q.status != _statusFilter) return false;
      if (_typeFilter != null && q.questType != _typeFilter) return false;
      if (_searchQuery.trim().isNotEmpty) {
        final s = _searchQuery.toLowerCase();
        final inTitle = q.title.toLowerCase().contains(s);
        final inDesc = q.description?.toLowerCase().contains(s) ?? false;
        final inNotes = q.notes?.toLowerCase().contains(s) ?? false;
        if (!inTitle && !inDesc && !inNotes) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final charactersAsync = ref.watch(charactersProvider);
    final questsAsync = selectedCharacterId == null
        ? ref.watch(questsProvider)
        : ref.watch(questsByCharacterProvider(selectedCharacterId!));

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(l10n.questJournalTitle),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          charactersAsync.when(
            data: (characters) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: DropdownButtonFormField<String?>(
                value: selectedCharacterId,
                decoration: InputDecoration(
                  labelText: l10n.questFilterByCharacter,
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.questAllCharacters),
                  ),
                  ...characters.map(
                    (character) => DropdownMenuItem<String?>(
                      value: character.id,
                      child: Text(character.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCharacterId = value;
                  });
                },
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('${l10n.error}: $error'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.questSearchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              l10n.questFilterStatus,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilterChip(
                  label: Text(l10n.questStatusAll),
                  selected: _statusFilter == null,
                  onSelected: (_) => setState(() => _statusFilter = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.questStatusActive),
                  selected: _statusFilter == 'active',
                  onSelected: (_) => setState(() => _statusFilter = 'active'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.questStatusBlocked),
                  selected: _statusFilter == 'blocked',
                  onSelected: (_) => setState(() => _statusFilter = 'blocked'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.questStatusCompleted),
                  selected: _statusFilter == 'completed',
                  onSelected: (_) =>
                      setState(() => _statusFilter = 'completed'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              l10n.questFilterType,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilterChip(
                  label: Text(l10n.questTypeAll),
                  selected: _typeFilter == null,
                  onSelected: (_) => setState(() => _typeFilter = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.questTypeGeneral),
                  selected: _typeFilter == 'general',
                  onSelected: (_) => setState(() => _typeFilter = 'general'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.questTypeStory),
                  selected: _typeFilter == 'story',
                  onSelected: (_) => setState(() => _typeFilter = 'story'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.questTypeContract),
                  selected: _typeFilter == 'contract',
                  onSelected: (_) => setState(() => _typeFilter = 'contract'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.questTypeChallenge),
                  selected: _typeFilter == 'challenge',
                  onSelected: (_) => setState(() => _typeFilter = 'challenge'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: questsAsync.when(
              data: (quests) => charactersAsync.when(
                data: (characters) {
                  final filtered = _applyFilters(quests);
                  if (quests.isEmpty) {
                    return Center(child: Text(l10n.questEmptyNoData));
                  }
                  if (filtered.isEmpty) {
                    return Center(child: Text(l10n.questEmptyHint));
                  }

                  final characterMap = {for (final c in characters) c.id: c};

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final quest = filtered[index];
                      final character = characterMap[quest.characterId];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(quest.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (character != null) Text(character.name),
                              Text(
                                '${quest.questType} • ${quest.status}'
                                '${quest.missionType == null ? '' : ' • ${quest.missionType}'}',
                              ),
                              if (quest.isLandsraadContract)
                                Text(l10n.questLandsraadContract),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              _showQuestDetails(context, quest, character),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final chars = ref.read(charactersProvider).valueOrNull ?? [];
          if (chars.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.questNoCharactersYet)),
            );
            return;
          }
          _showQuestDialog(context, ref);
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.questAddQuest),
      ),
    );
  }

  void _showQuestDialog(BuildContext context, WidgetRef ref,
      {Quest? existing}) {
    final l10n = AppLocalizations.of(context)!;
    final charactersValue = ref.read(charactersProvider);
    final characters = charactersValue.valueOrNull ?? const <Character>[];
    String? characterId = existing?.characterId ??
        selectedCharacterId ??
        (characters.isNotEmpty ? characters.first.id : null);
    String questType = existing?.questType ?? 'general';
    String status = existing?.status ?? 'active';
    String? missionType = existing?.missionType;
    bool isLandsraad = existing?.isLandsraadContract ?? false;
    bool isRepeatable = existing?.isRepeatable ?? false;
    DateTime? reminderAt = existing?.reminderAt;
    final titleController = TextEditingController(text: existing?.title ?? '');
    final descriptionController =
        TextEditingController(text: existing?.description ?? '');
    final notesController = TextEditingController(text: existing?.notes ?? '');
    final xpController = TextEditingController(
      text: existing?.specializationXpGained?.toString() ?? '',
    );
    final dateFmt = DateFormat.yMMMd().add_jm();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title:
              Text(existing == null ? l10n.questAddTitle : l10n.questEditTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: characterId,
                  items: characters
                      .map(
                        (character) => DropdownMenuItem(
                          value: character.id,
                          child: Text(character.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => characterId = value),
                  decoration:
                      InputDecoration(labelText: l10n.questCharacterLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: l10n.questTitleLabel),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: questType,
                  items: [
                    DropdownMenuItem(
                        value: 'general', child: Text(l10n.questTypeGeneral)),
                    DropdownMenuItem(
                        value: 'story', child: Text(l10n.questTypeStory)),
                    DropdownMenuItem(
                        value: 'contract', child: Text(l10n.questTypeContract)),
                    DropdownMenuItem(
                        value: 'challenge',
                        child: Text(l10n.questTypeChallenge)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => questType = value);
                  },
                  decoration: InputDecoration(labelText: l10n.questTypeLabel),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: status,
                  items: [
                    DropdownMenuItem(
                        value: 'active', child: Text(l10n.questStatusActive)),
                    DropdownMenuItem(
                        value: 'blocked', child: Text(l10n.questStatusBlocked)),
                    DropdownMenuItem(
                        value: 'completed',
                        child: Text(l10n.questStatusCompleted)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => status = value);
                  },
                  decoration: InputDecoration(labelText: l10n.questStatusLabel),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: missionType,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.questMissionTypeNone),
                    ),
                    DropdownMenuItem(
                      value: 'Combat',
                      child: Text(l10n.questMissionCombat),
                    ),
                    DropdownMenuItem(
                      value: 'Crafting',
                      child: Text(l10n.questMissionCrafting),
                    ),
                    DropdownMenuItem(
                      value: 'Gathering',
                      child: Text(l10n.questMissionGathering),
                    ),
                    DropdownMenuItem(
                      value: 'Exploration',
                      child: Text(l10n.questMissionExploration),
                    ),
                    DropdownMenuItem(
                      value: 'Sabotage',
                      child: Text(l10n.questMissionSabotage),
                    ),
                  ],
                  onChanged: (value) => setState(() => missionType = value),
                  decoration:
                      InputDecoration(labelText: l10n.questMissionTypeLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration:
                      InputDecoration(labelText: l10n.questDescriptionLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: l10n.questNotesLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: xpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.questSpecXpLabel),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: isLandsraad,
                  onChanged: (value) => setState(() => isLandsraad = value),
                  title: Text(l10n.questLandsraadContract),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: isRepeatable,
                  onChanged: (value) => setState(() => isRepeatable = value),
                  title: Text(l10n.questRepeatable),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.questReminderLabel,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: reminderAt == null
                      ? Text(l10n.questReminderNone)
                      : Text(l10n
                          .questReminderScheduled(dateFmt.format(reminderAt!))),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          final d = await showDatePicker(
                            context: context,
                            initialDate: reminderAt ?? now,
                            firstDate: now.subtract(const Duration(days: 1)),
                            lastDate: now.add(const Duration(days: 365 * 5)),
                          );
                          if (d == null || !context.mounted) return;
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              reminderAt ?? now,
                            ),
                          );
                          if (t == null) return;
                          setState(() {
                            reminderAt = DateTime(
                              d.year,
                              d.month,
                              d.day,
                              t.hour,
                              t.minute,
                            );
                          });
                        },
                        child: Text(l10n.questPickDateTime),
                      ),
                      TextButton(
                        onPressed: () => setState(() => reminderAt = null),
                        child: Text(l10n.questClearReminder),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: characterId == null
                  ? null
                  : () async {
                      final quest = (existing ??
                              Quest(
                                id: const Uuid().v4(),
                                characterId: characterId!,
                                title: '',
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              ))
                          .copyWith(
                        characterId: characterId,
                        title: titleController.text,
                        description: descriptionController.text.isEmpty
                            ? null
                            : descriptionController.text,
                        notes: notesController.text.isEmpty
                            ? null
                            : notesController.text,
                        status: status,
                        questType: questType,
                        missionType: missionType,
                        isLandsraadContract: isLandsraad,
                        isRepeatable: isRepeatable,
                        specializationXpGained: int.tryParse(xpController.text),
                        reminderAt: reminderAt,
                      );
                      await ref.read(questEditorProvider).saveQuest(quest);
                      if (context.mounted) Navigator.of(context).pop();
                    },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuestDetails(
    BuildContext context,
    Quest quest,
    Character? character,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _QuestDetailsSheet(
        quest: quest,
        character: character,
        onEdit: () => _showQuestDialog(context, ref, existing: quest),
      ),
    );
  }
}

class _QuestDetailsSheet extends ConsumerWidget {
  const _QuestDetailsSheet({
    required this.quest,
    required this.character,
    required this.onEdit,
  });

  final Quest quest;
  final Character? character;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stepsAsync = ref.watch(questStepsProvider(quest.id));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(quest.title),
                  subtitle: Text(character?.name ?? ''),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit),
                        tooltip: l10n.edit,
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(questEditorProvider)
                              .deleteQuest(quest.id, quest.characterId);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.delete),
                        tooltip: l10n.delete,
                      ),
                    ],
                  ),
                ),
                if (quest.description != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(quest.description!),
                    ),
                  ),
                if (quest.reminderAt != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.questReminderScheduled(
                        DateFormat.yMMMd().add_jm().format(quest.reminderAt!),
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.questStepsHeading,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: stepsAsync.when(
                    data: (steps) => CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        if (quest.notes != null && quest.notes!.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(quest.notes!),
                                ),
                              ),
                            ),
                          ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text(
                              l10n.questDragToReorder,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                        SliverReorderableList(
                          itemCount: steps.length,
                          onReorder: (oldIndex, newIndex) async {
                            if (newIndex > oldIndex) newIndex--;
                            final list = List<QuestStep>.from(steps);
                            final item = list.removeAt(oldIndex);
                            list.insert(newIndex, item);
                            await ref.read(questEditorProvider).reorderSteps(
                                  quest.id,
                                  quest.characterId,
                                  list,
                                );
                          },
                          itemBuilder: (context, index) {
                            final step = steps[index];
                            return Card(
                              key: ValueKey(step.id),
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: CheckboxListTile(
                                value: step.isCompleted,
                                title: Text(step.title),
                                subtitle: step.notes == null
                                    ? null
                                    : Text(step.notes!),
                                onChanged: (value) {
                                  ref.read(questEditorProvider).saveStep(
                                        step.copyWith(
                                          isCompleted: value ?? false,
                                          completedAt: value == true
                                              ? DateTime.now()
                                              : null,
                                        ),
                                        quest.characterId,
                                      );
                                },
                                secondary: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ReorderableDragStartListener(
                                      index: index,
                                      child: Icon(
                                        Icons.drag_handle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 20),
                                      onPressed: () => _showStepDialogForSheet(
                                        context,
                                        ref,
                                        quest,
                                        existing: step,
                                      ),
                                      tooltip: l10n.edit,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 20),
                                      onPressed: () => ref
                                          .read(questEditorProvider)
                                          .deleteStep(step.id, quest.id),
                                      tooltip: l10n.delete,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('${l10n.error}: $error')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () => _showStepDialogForSheet(
                      context,
                      ref,
                      quest,
                    ),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.questAddStep),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showStepDialogForSheet(
  BuildContext context,
  WidgetRef ref,
  Quest quest, {
  QuestStep? existing,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final titleController = TextEditingController(text: existing?.title ?? '');
  final notesController = TextEditingController(text: existing?.notes ?? '');

  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        existing == null ? l10n.questAddStep : l10n.questEditStep,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: l10n.questStepTitleLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: InputDecoration(labelText: l10n.questNotesLabel),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () async {
            if (existing == null) {
              final existingSteps =
                  await ref.read(questRepositoryProvider).getSteps(quest.id);
              final step = QuestStep(
                id: const Uuid().v4(),
                questId: quest.id,
                title: titleController.text,
                notes:
                    notesController.text.isEmpty ? null : notesController.text,
                sortOrder: existingSteps.length,
                createdAt: DateTime.now(),
              );
              await ref
                  .read(questEditorProvider)
                  .saveStep(step, quest.characterId);
            } else {
              await ref.read(questEditorProvider).saveStep(
                    existing.copyWith(
                      title: titleController.text,
                      notes: notesController.text.isEmpty
                          ? null
                          : notesController.text,
                    ),
                    quest.characterId,
                  );
            }
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(l10n.save),
        ),
      ],
    ),
  );
}
