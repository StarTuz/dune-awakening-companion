import 'dart:io';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/image_service_provider.dart';
import '../../characters/models/character.dart';
import '../../characters/providers/character_provider.dart';
import '../../quest_journal/models/quest.dart';
import '../../quest_journal/providers/quest_provider.dart';
import '../models/journal_entry.dart';
import '../models/journal_template.dart';
import '../providers/journal_provider.dart';

/// RPG journal tab: a per-character chronicle with biography, dated entries,
/// tags, search, optional location/mood, quest links and screenshots.
/// See `docs/RESEARCH_RPG_JOURNAL_NOTES.md` (Phases 1–3).
class CharacterJournalTab extends ConsumerStatefulWidget {
  const CharacterJournalTab({super.key, required this.character});

  final Character character;

  @override
  ConsumerState<CharacterJournalTab> createState() =>
      _CharacterJournalTabState();
}

class _CharacterJournalTabState extends ConsumerState<CharacterJournalTab> {
  String? _selectedTag;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Phase 3: a light parchment/aged-paper theme for the journal surface.
  /// Cursive Google Fonts are intentionally deferred (no network font
  /// dependency); we lean on italics + warm tones instead.
  ThemeData _parchmentTheme(BuildContext context) {
    final base = Theme.of(context);
    const parchment = Color(0xFFF4EAD2);
    const surface = Color(0xFFFBF4E1);
    const ink = Color(0xFF4A3B2A);
    const inkMuted = Color(0xFF6B5B47);
    return base.copyWith(
      scaffoldBackgroundColor: parchment,
      cardTheme: base.cardTheme.copyWith(color: surface),
      colorScheme: base.colorScheme.copyWith(
        surface: surface,
        onSurface: ink,
        // Material 3 IconButtons tint with onSurfaceVariant; without this the
        // edit/delete icons render near-invisible on the parchment card.
        onSurfaceVariant: inkMuted,
      ),
      iconTheme: base.iconTheme.copyWith(color: ink),
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entriesAsync =
        ref.watch(characterJournalProvider(widget.character.id));
    final character = ref.watch(charactersProvider).maybeWhen(
          data: (characters) => characters.firstWhere(
            (c) => c.id == widget.character.id,
            orElse: () => widget.character,
          ),
          orElse: () => widget.character,
        );

    return Theme(
      data: _parchmentTheme(context),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: entriesAsync.when(
            data: (entries) {
              final allTags = <String>{
                for (final entry in entries) ...entry.tags,
              }.toList()
                ..sort();
              final visibleEntries = entries.where(_matchesFilters).toList();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _BiographyCard(
                    character: character,
                    onEdit: () => _editBiography(character),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: l10n.journalSearchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: _searchQuery.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            ),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                  if (allTags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: Text(l10n.journalFilterAllTags),
                          selected: _selectedTag == null,
                          onSelected: (_) =>
                              setState(() => _selectedTag = null),
                        ),
                        ...allTags.map(
                          (tag) => FilterChip(
                            label: Text(tag),
                            selected: _selectedTag == tag,
                            onSelected: (selected) => setState(
                              () => _selectedTag = selected ? tag : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (entries.isEmpty)
                    _EmptyHint(text: l10n.journalEmpty)
                  else if (visibleEntries.isEmpty)
                    _EmptyHint(text: l10n.journalNoMatches)
                  else
                    ...visibleEntries.map(
                      (entry) => _JournalEntryCard(
                        entry: entry,
                        onEdit: () => _showEditor(entry),
                        onDelete: () => _confirmDelete(entry),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showEditor(null),
            icon: const Icon(Icons.add),
            label: Text(l10n.journalNewEntry),
          ),
        ),
      ),
    );
  }

  bool _matchesFilters(JournalEntry entry) {
    if (_selectedTag != null && !entry.tags.contains(_selectedTag)) {
      return false;
    }
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return true;
    final haystack = [
      entry.title,
      entry.body,
      entry.location ?? '',
      entry.mood ?? '',
      ...entry.tags,
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }

  // Dialogs deliberately use the State's `context`, which sits above the
  // parchment Theme, so editors render in the normal app theme rather than
  // inheriting half-overridden parchment colors (which made dialog text
  // unreadable).
  Future<void> _editBiography(Character character) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: character.biography ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.journalEditBiography),
        content: TextField(
          controller: controller,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l10n.journalBiographyTitle,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (saved == true) {
      final trimmed = controller.text.trim();
      await ref.read(charactersProvider.notifier).updateCharacter(
            character.copyWith(
              biography: trimmed.isEmpty ? null : trimmed,
              updatedAt: DateTime.now(),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.journalBiographySaved)),
        );
      }
    }
    controller.dispose();
  }

  Future<void> _confirmDelete(JournalEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.journalDeleteConfirmTitle),
        content: Text(l10n.journalDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    // Only remove screenshots we copied into our managed directory; never
    // touch a user's original file that a legacy entry may still reference.
    final imagePath = entry.imagePath;
    if (imagePath != null && imagePath.contains('journal_images')) {
      await ref.read(imageServiceProvider).deleteJournalImage(imagePath);
    }
    await ref.read(journalEditorProvider).delete(entry.id, widget.character.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.journalDeletedSnack)),
      );
    }
  }

  Future<void> _showEditor(JournalEntry? existing) async {
    final l10n = AppLocalizations.of(context)!;
    final quests =
        await ref.read(questsByCharacterProvider(widget.character.id).future);
    if (!mounted) return;

    final result = await showDialog<JournalEntry>(
      context: context,
      builder: (context) => _JournalEntryEditorDialog(
        characterId: widget.character.id,
        existing: existing,
        quests: quests,
      ),
    );

    if (result == null) return;
    await ref.read(journalEditorProvider).save(result);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.journalSavedSnack)),
      );
    }
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class _BiographyCard extends StatelessWidget {
  const _BiographyCard({required this.character, required this.onEdit});

  final Character character;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bio = character.biography?.trim() ?? '';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.journalBiographyTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.journalEditBiography,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  bio.isEmpty ? l10n.journalBiographyEmpty : bio,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalEntryCard extends ConsumerWidget {
  const _JournalEntryCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  final JournalEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title =
        entry.title.trim().isEmpty ? l10n.journalUntitled : entry.title.trim();
    final subtitleParts = <String>[
      DateFormat.yMMMd().format(entry.entryDate),
      if (entry.location != null && entry.location!.trim().isNotEmpty)
        entry.location!.trim(),
      if (entry.mood != null && entry.mood!.trim().isNotEmpty)
        entry.mood!.trim(),
    ];

    final linkedQuestTitle = entry.questId == null
        ? null
        : ref.watch(questsByCharacterProvider(entry.characterId)).maybeWhen(
              data: (quests) {
                for (final quest in quests) {
                  if (quest.id == entry.questId) return quest.title;
                }
                return null;
              },
              orElse: () => null,
            );

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
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleParts.join(' • '),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.journalEditEntry,
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  tooltip: l10n.delete,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            if (entry.imagePath != null && entry.imagePath!.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(entry.imagePath!),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => const SizedBox(
                    height: 160,
                    child: Center(child: Icon(Icons.broken_image_outlined)),
                  ),
                ),
              ),
            ],
            if (entry.body.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              MarkdownBody(
                data: entry.body.trim(),
                shrinkWrap: true,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
              ),
            ],
            if (linkedQuestTitle != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.link, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${l10n.journalEntryQuestLabel}: $linkedQuestTitle',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
            if (entry.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    entry.tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _JournalEntryEditorDialog extends ConsumerStatefulWidget {
  const _JournalEntryEditorDialog({
    required this.characterId,
    required this.existing,
    required this.quests,
  });

  final String characterId;
  final JournalEntry? existing;
  final List<Quest> quests;

  @override
  ConsumerState<_JournalEntryEditorDialog> createState() =>
      _JournalEntryEditorDialogState();
}

class _JournalEntryEditorDialogState
    extends ConsumerState<_JournalEntryEditorDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _tagsController;
  late final TextEditingController _locationController;
  late final TextEditingController _moodController;
  late final String _entryId;
  late DateTime _entryDate;
  String? _questId;
  String? _imagePath;
  String? _titleError;
  bool _previewBody = false;
  bool _savingImage = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _entryId = existing?.id ?? const Uuid().v4();
    _titleController = TextEditingController(text: existing?.title ?? '');
    _bodyController = TextEditingController(text: existing?.body ?? '');
    _tagsController =
        TextEditingController(text: existing?.tags.join(', ') ?? '');
    _locationController = TextEditingController(text: existing?.location ?? '');
    _moodController = TextEditingController(text: existing?.mood ?? '');
    _entryDate = existing?.entryDate ?? DateTime.now();
    _questId = existing?.questId;
    _imagePath = existing?.imagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    _locationController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    final picked = result?.files.single.path;
    if (picked == null) return;

    setState(() => _savingImage = true);
    // Copy/resize into an app-managed directory so the screenshot can be
    // bundled into ZIP backups instead of pointing at a transient path.
    final saved =
        await ref.read(imageServiceProvider).saveJournalImage(picked, _entryId);
    if (!mounted) return;
    setState(() {
      _imagePath = saved ?? picked;
      _savingImage = false;
    });
  }

  void _applyTemplate(JournalTemplate template) {
    setState(() {
      if (_titleController.text.trim().isEmpty) {
        _titleController.text = template.title;
      }
      _bodyController.text = template.body;
      final existingTags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
      for (final tag in template.tags) {
        if (!existingTags.contains(tag)) existingTags.add(tag);
      }
      _tagsController.text = existingTags.join(', ');
      _titleError = null;
      _previewBody = false;
    });
  }

  /// Wrap the current selection (or insert at the cursor) with Markdown syntax.
  void _wrapSelection(String prefix, String suffix) {
    final value = _bodyController.value;
    final selection = value.selection;
    final text = value.text;
    final start = selection.start < 0 ? text.length : selection.start;
    final end = selection.end < 0 ? text.length : selection.end;
    final selected = text.substring(start, end);
    final replacement = '$prefix$selected$suffix';
    final newText = text.replaceRange(start, end, replacement);
    _bodyController.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: start + prefix.length + selected.length,
      ),
      composing: TextRange.empty,
    );
  }

  /// Prefix the line at the cursor with Markdown line syntax (heading, list).
  void _prefixLine(String linePrefix) {
    final value = _bodyController.value;
    final text = value.text;
    final caret =
        value.selection.start < 0 ? text.length : value.selection.start;
    var lineStart = caret;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }
    final newText = text.replaceRange(lineStart, lineStart, linePrefix);
    _bodyController.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: caret + linePrefix.length),
      composing: TextRange.empty,
    );
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      setState(() => _titleError = l10n.journalTitleRequired);
      return;
    }
    final now = DateTime.now();
    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    final entry = (widget.existing ??
            JournalEntry(
              id: _entryId,
              characterId: widget.characterId,
              title: '',
              entryDate: _entryDate,
              createdAt: now,
              updatedAt: now,
            ))
        .copyWith(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      tags: tags,
      entryDate: _entryDate,
      location: _emptyToNull(_locationController.text),
      mood: _emptyToNull(_moodController.text),
      questId: _questId,
      imagePath: _imagePath,
    );

    Navigator.of(context).pop(entry);
  }

  static String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Widget _buildBodyEditor(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: l10n.journalFormatBold,
              visualDensity: VisualDensity.compact,
              onPressed: _previewBody ? null : () => _wrapSelection('**', '**'),
              icon: const Icon(Icons.format_bold),
            ),
            IconButton(
              tooltip: l10n.journalFormatItalic,
              visualDensity: VisualDensity.compact,
              onPressed: _previewBody ? null : () => _wrapSelection('_', '_'),
              icon: const Icon(Icons.format_italic),
            ),
            IconButton(
              tooltip: l10n.journalFormatHeading,
              visualDensity: VisualDensity.compact,
              onPressed: _previewBody ? null : () => _prefixLine('## '),
              icon: const Icon(Icons.title),
            ),
            IconButton(
              tooltip: l10n.journalFormatBulletList,
              visualDensity: VisualDensity.compact,
              onPressed: _previewBody ? null : () => _prefixLine('- '),
              icon: const Icon(Icons.format_list_bulleted),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => setState(() => _previewBody = !_previewBody),
              icon: Icon(
                _previewBody ? Icons.edit_outlined : Icons.visibility_outlined,
                size: 18,
              ),
              label: Text(
                _previewBody
                    ? l10n.journalToggleEdit
                    : l10n.journalTogglePreview,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (_previewBody)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 120),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: _bodyController.text.trim().isEmpty
                ? Text(
                    l10n.journalEntryBodyLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : MarkdownBody(
                    data: _bodyController.text,
                    shrinkWrap: true,
                  ),
          )
        else
          TextField(
            controller: _bodyController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: l10n.journalEntryBodyLabel,
              helperText: l10n.journalMarkdownHint,
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        widget.existing == null ? l10n.journalNewEntry : l10n.journalEditEntry,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.existing == null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: PopupMenuButton<JournalTemplate>(
                  onSelected: _applyTemplate,
                  itemBuilder: (context) => [
                    for (final template in JournalTemplate.all(l10n))
                      PopupMenuItem<JournalTemplate>(
                        value: template,
                        child: Text(template.label),
                      ),
                  ],
                  child: Chip(
                    avatar: const Icon(Icons.auto_awesome, size: 18),
                    label: Text(l10n.journalUseTemplate),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.journalEntryTitleLabel,
                errorText: _titleError,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.journalEntryDateLabel,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat.yMMMd().format(_entryDate)),
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _entryDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _entryDate = picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(l10n.journalEntryDateLabel),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildBodyEditor(l10n),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: l10n.journalEntryLocationLabel,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _moodController,
                    decoration: InputDecoration(
                      labelText: l10n.journalEntryMoodLabel,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: l10n.journalEntryTagsLabel,
              ),
            ),
            if (widget.quests.isNotEmpty) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                value: _questId,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.journalEntryQuestLabel,
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.journalEntryNoQuest),
                  ),
                  ...widget.quests.map(
                    (quest) => DropdownMenuItem<String?>(
                      value: quest.id,
                      child: Text(
                        quest.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _questId = value),
              ),
            ],
            const SizedBox(height: 12),
            if (_imagePath != null && _imagePath!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_imagePath!),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => const SizedBox(
                    height: 120,
                    child: Center(child: Icon(Icons.broken_image_outlined)),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _imagePath = null),
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.journalRemoveImage),
              ),
            ] else
              OutlinedButton.icon(
                onPressed: _savingImage ? null : _pickImage,
                icon: _savingImage
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.image_outlined),
                label: Text(l10n.journalAddImage),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
