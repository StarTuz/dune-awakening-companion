import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../characters/models/character.dart';
import '../../characters/providers/character_provider.dart';
import '../models/blueprint.dart';
import '../models/blueprint_catalog.dart';
import '../providers/blueprint_provider.dart';
import '../providers/blueprint_settings_provider.dart';

const _schematicRespawnDuration = Duration(minutes: 45);

/// Sentinel value for the "All regions" filter.
const String _allRegions = '__all__';

String _regionPrefKey(String characterId) => 'blueprint_region:$characterId';
String _viewModePrefKey(String characterId) => 'blueprint_view:$characterId';

/// View-mode values for the per-character "View by" segmented control.
const String _viewBySchematic = 'schematic';
const String _viewBySite = 'site';

class BlueprintTrackerScreen extends ConsumerStatefulWidget {
  const BlueprintTrackerScreen({super.key});

  @override
  ConsumerState<BlueprintTrackerScreen> createState() =>
      _BlueprintTrackerScreenState();
}

class _BlueprintTrackerScreenState
    extends ConsumerState<BlueprintTrackerScreen> {
  String? _selectedCharacterId;
  String _statusFilter = 'all';

  /// Selected region filter — sentinel `_allRegions` means show every region.
  /// Cached per-character in-memory so flipping between characters is snappy.
  final Map<String, String> _regionFilterByCharacter = {};

  /// Characters whose region preference has been loaded from disk at least
  /// once. Prevents redundant SharedPreferences hits on every rebuild.
  final Set<String> _regionPrefLoadedFor = {};

  /// Per-character "View by" mode ('schematic' or 'site').
  final Map<String, String> _viewModeByCharacter = {};
  final Set<String> _viewPrefLoadedFor = {};

  String _regionFilter(String characterId) =>
      _regionFilterByCharacter[characterId] ?? _allRegions;

  String _viewMode(String characterId) =>
      _viewModeByCharacter[characterId] ?? _viewBySchematic;

  Future<void> _ensureRegionPrefLoaded(String characterId) async {
    if (_regionPrefLoadedFor.contains(characterId)) return;
    _regionPrefLoadedFor.add(characterId);
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_regionPrefKey(characterId));
      if (!mounted) return;
      if (stored != null && stored != _regionFilterByCharacter[characterId]) {
        setState(() {
          _regionFilterByCharacter[characterId] = stored;
        });
      }
    } catch (_) {
      // SharedPreferences plugin unavailable (e.g. in unit/widget tests
      // without setMockInitialValues). Fall back to in-memory state.
    }
  }

  Future<void> _ensureViewPrefLoaded(String characterId) async {
    if (_viewPrefLoadedFor.contains(characterId)) return;
    _viewPrefLoadedFor.add(characterId);
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_viewModePrefKey(characterId));
      if (!mounted) return;
      if (stored != null && stored != _viewModeByCharacter[characterId]) {
        setState(() {
          _viewModeByCharacter[characterId] = stored;
        });
      }
    } catch (_) {
      // SharedPreferences plugin unavailable in tests; in-memory fallback.
    }
  }

  Future<void> _setRegionFilter(String characterId, String region) async {
    setState(() {
      _regionFilterByCharacter[characterId] = region;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_regionPrefKey(characterId), region);
    } catch (_) {
      // Same as above; persistence is best-effort.
    }
  }

  Future<void> _setViewMode(String characterId, String mode) async {
    setState(() {
      _viewModeByCharacter[characterId] = mode;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_viewModePrefKey(characterId), mode);
    } catch (_) {
      // Same as above; persistence is best-effort.
    }
  }

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(charactersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blueprints / Schematics'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              final characterId = _selectedCharacterId;
              if (characterId != null) {
                ref.invalidate(blueprintsByCharacterProvider(characterId));
              }
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: charactersAsync.when(
        data: (characters) => _buildContent(context, characters),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: charactersAsync.maybeWhen(
        data: (characters) => characters.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () => _showBlueprintDialog(context, characters),
                icon: const Icon(Icons.add),
                label: const Text('Add Blueprint'),
              ),
        orElse: () => null,
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Character> characters) {
    if (characters.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Add a character first, then track unique schematic discoveries.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    _selectedCharacterId ??= characters.first.id;
    final selectedCharacterId = _selectedCharacterId!;
    // Fire-and-forget pref loads; setState reruns build when they land.
    _ensureRegionPrefLoaded(selectedCharacterId);
    _ensureViewPrefLoaded(selectedCharacterId);
    final blueprintsAsync =
        ref.watch(blueprintsByCharacterProvider(selectedCharacterId));

    return Column(
      children: [
        _buildHeader(context, characters, selectedCharacterId),
        Expanded(
          child: blueprintsAsync.when(
            data: (blueprints) =>
                _buildBlueprintList(selectedCharacterId, blueprints),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    List<Character> characters,
    String selectedCharacterId,
  ) {
    final activeRegion = _regionFilter(selectedCharacterId);
    final regions = blueprintCatalogRegions();
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.map_outlined),
                const SizedBox(width: 8),
                Text(
                  activeRegion == _allRegions ? 'All Regions' : activeRegion,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Checklist seeded from IGN guide data. Track each discovery per character, then add personal notes or future quest/map links as needed.',
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCharacterId,
              items: characters
                  .map(
                    (character) => DropdownMenuItem(
                      value: character.id,
                      child: Text(character.name),
                    ),
                  )
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Character',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedCharacterId = value);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: activeRegion,
              isExpanded: true,
              items: [
                const DropdownMenuItem(
                  value: _allRegions,
                  child: Text('All Regions'),
                ),
                for (final region in regions)
                  DropdownMenuItem(
                    value: region,
                    child: Text(region),
                  ),
              ],
              decoration: const InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value == null) return;
                _setRegionFilter(selectedCharacterId, value);
              },
            ),
            const SizedBox(height: 12),
            const Text('Status'),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _statusFilter == 'all',
                  onSelected: (_) => setState(() => _statusFilter = 'all'),
                ),
                ChoiceChip(
                  label: const Text('Locked'),
                  selected: _statusFilter == 'locked',
                  onSelected: (_) => setState(() => _statusFilter = 'locked'),
                ),
                ChoiceChip(
                  label: const Text('Unlocked'),
                  selected: _statusFilter == 'unlocked',
                  onSelected: (_) => setState(() => _statusFilter = 'unlocked'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('View by:'),
                const SizedBox(width: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: _viewBySchematic,
                      label: Text('Schematic'),
                      icon: Icon(Icons.list_alt),
                    ),
                    ButtonSegment(
                      value: _viewBySite,
                      label: Text('Site'),
                      icon: Icon(Icons.place_outlined),
                    ),
                  ],
                  selected: {_viewMode(selectedCharacterId)},
                  onSelectionChanged: (selection) {
                    _setViewMode(selectedCharacterId, selection.first);
                  },
                  showSelectedIcon: false,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _AutoRespawnTimerSwitch(),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueprintList(String characterId, List<Blueprint> blueprints) {
    final rows = _buildChecklistRows(characterId, blueprints);
    final collectedCount = rows.where((row) => row.isUnlocked).length;
    final filtered = rows.where(_passesStatusFilter).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No blueprints match this filter yet.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final body = _viewMode(characterId) == _viewBySite
        ? _buildSiteGroupedBody(characterId, blueprints)
        : _buildSchematicBody(characterId, filtered);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: LinearProgressIndicator(
            value: rows.isEmpty ? 0 : collectedCount / rows.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('$collectedCount / ${rows.length} collected'),
          ),
        ),
        Expanded(child: body),
      ],
    );
  }

  bool _passesStatusFilter(_BlueprintChecklistRow row) {
    return switch (_statusFilter) {
      'locked' => !row.isUnlocked,
      'unlocked' => row.isUnlocked,
      _ => true,
    };
  }

  Widget _buildSchematicBody(
    String characterId,
    List<_BlueprintChecklistRow> filtered,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _buildBlueprintCard(characterId, filtered[index]);
      },
    );
  }

  /// Site-grouped view — one section per (region, location) pool. A
  /// schematic that drops in multiple sites appears in each pool's
  /// section (its unlock state is shared, so checking it in one site
  /// also ticks it everywhere it appears).
  Widget _buildSiteGroupedBody(
    String characterId,
    List<Blueprint> blueprints,
  ) {
    final sections = _buildPoolSections(characterId, blueprints);
    final visibleSections = sections
        .map((section) => _PoolSection(
              region: section.region,
              location: section.location,
              rows: section.rows.where(_passesStatusFilter).toList(),
              totalRows: section.rows.length,
              unlockedRows: section.rows.where((r) => r.isUnlocked).length,
            ))
        .where((section) => section.rows.isNotEmpty)
        .toList();

    if (visibleSections.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No blueprints match this filter yet.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      itemCount: visibleSections.length,
      itemBuilder: (context, index) {
        final section = visibleSections[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == visibleSections.length - 1 ? 0 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.location,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            section.region,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${section.unlockedRows} / ${section.totalRows}',
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              ...section.rows.map((row) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildBlueprintCard(characterId, row),
                  )),
            ],
          ),
        );
      },
    );
  }

  /// Build per-(region, location) groupings of catalog + custom rows
  /// for the Site view. A schematic with N sources contributes a row to
  /// each of its N sections.
  List<_PoolSection> _buildPoolSections(
    String characterId,
    List<Blueprint> blueprints,
  ) {
    final regionFilter = _regionFilter(characterId);
    final byName = {
      for (final blueprint in blueprints) _key(blueprint.name): blueprint,
    };

    // Use an insertion-ordered map so the section order mirrors the
    // catalog's declared order (Hagga first, Sheol last, etc.).
    final pools = <String, _PoolSection>{};
    String poolKey(String region, String location) => '$region|$location';
    _PoolSection sectionFor(String region, String location) {
      return pools.putIfAbsent(
        poolKey(region, location),
        () => _PoolSection(region: region, location: location, rows: []),
      );
    }

    for (final entry in blueprintCatalog) {
      for (final source in entry.sources) {
        if (regionFilter != _allRegions && source.region != regionFilter) {
          continue;
        }
        sectionFor(source.region, source.location).rows.add(
              _BlueprintChecklistRow(
                entry: entry,
                blueprint: byName[_key(entry.name)],
              ),
            );
      }
    }

    // Custom blueprints (not in catalog) — bucket each into a section
    // keyed by its persisted region + sourceLocation.
    for (final blueprint in blueprints) {
      final inCatalog = blueprintCatalog
          .any((entry) => _key(entry.name) == _key(blueprint.name));
      if (inCatalog) continue;
      if (regionFilter != _allRegions && blueprint.region != regionFilter) {
        continue;
      }
      final location =
          (blueprint.sourceLocation == null || blueprint.sourceLocation!.trim().isEmpty)
              ? '(unspecified)'
              : blueprint.sourceLocation!;
      sectionFor(blueprint.region, location).rows.add(
            _BlueprintChecklistRow(blueprint: blueprint),
          );
    }

    return pools.values.toList();
  }

  Widget _buildBlueprintCard(
    String characterId,
    _BlueprintChecklistRow row,
  ) {
    return _BlueprintCard(
      row: row,
      onToggle: () => _toggleChecklistRow(characterId, row),
      onToggleRespawnTimer: row.blueprint == null
          ? null
          : (isEnabled) => ref
              .read(blueprintEditorProvider)
              .setRespawnTimerEnabled(row.blueprint!, isEnabled),
      onResetRespawn: row.blueprint == null
          ? null
          : () => ref
              .read(blueprintEditorProvider)
              .resetRespawnTimer(row.blueprint!),
      onEdit: () => _showBlueprintDialog(
        context,
        null,
        existing: row.blueprint ?? row.entry?.toBlueprint(characterId),
      ),
      onDelete: row.blueprint == null
          ? null
          : () => _confirmDelete(context, row.blueprint!),
    );
  }

  List<_BlueprintChecklistRow> _buildChecklistRows(
    String characterId,
    List<Blueprint> blueprints,
  ) {
    final regionFilter = _regionFilter(characterId);
    final byName = {
      for (final blueprint in blueprints) _key(blueprint.name): blueprint,
    };
    bool inFilter(List<String> regions, String? blueprintRegion) {
      if (regionFilter == _allRegions) return true;
      if (regions.contains(regionFilter)) return true;
      return blueprintRegion == regionFilter;
    }

    final catalogRows = blueprintCatalog
        .where((entry) =>
            inFilter(entry.regions, byName[_key(entry.name)]?.region))
        .map((entry) => _BlueprintChecklistRow(
              entry: entry,
              blueprint: byName[_key(entry.name)],
            ));

    final customRows = blueprints
        .where((blueprint) => !blueprintCatalog
            .any((entry) => _key(entry.name) == _key(blueprint.name)))
        .where((blueprint) => inFilter(const [], blueprint.region))
        .map((blueprint) => _BlueprintChecklistRow(blueprint: blueprint));

    return [...catalogRows, ...customRows];
  }

  Future<void> _toggleChecklistRow(
    String characterId,
    _BlueprintChecklistRow row,
  ) async {
    final autoStart =
        ref.read(blueprintSettingsProvider).autoStartRespawnTimer;
    final existing = row.blueprint;
    if (existing != null) {
      await ref.read(blueprintEditorProvider).toggleUnlocked(
            existing,
            autoStartRespawnTimer: autoStart,
          );
      return;
    }

    final now = DateTime.now();
    final blueprint = row.entry!.toBlueprint(characterId).copyWith(
          isUnlocked: true,
          unlockedAt: now,
          respawnTimerEnabled: autoStart,
          updatedAt: now,
        );
    await ref.read(blueprintEditorProvider).save(blueprint);
  }

  Future<void> _showBlueprintDialog(
    BuildContext context,
    List<Character>? providedCharacters, {
    Blueprint? existing,
  }) async {
    final characters =
        providedCharacters ?? ref.read(charactersProvider).valueOrNull ?? [];
    if (!context.mounted || characters.isEmpty) return;

    final now = DateTime.now();
    String characterId =
        existing?.characterId ?? _selectedCharacterId ?? characters.first.id;
    String category = existing?.category ?? 'Schematic';
    String sourceType = existing?.sourceType ?? 'Unknown';
    bool isUnlocked = existing?.isUnlocked ?? false;
    bool respawnTimerEnabled = existing?.respawnTimerEnabled ?? false;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final sourceController =
        TextEditingController(text: existing?.sourceLocation ?? '');
    final materialsController = TextEditingController(
      text: existing?.requiredMaterials.join('\n') ?? '',
    );
    final notesController = TextEditingController(text: existing?.notes ?? '');
    final questController =
        TextEditingController(text: existing?.questId ?? '');
    final mapPinController =
        TextEditingController(text: existing?.mapPinId ?? '');

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add Blueprint' : 'Edit Blueprint'),
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
                  decoration: const InputDecoration(labelText: 'Character'),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => characterId = value);
                    }
                  },
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                DropdownButtonFormField<String>(
                  value: category,
                  items: const [
                    DropdownMenuItem(
                      value: 'Schematic',
                      child: Text('Schematic'),
                    ),
                    DropdownMenuItem(value: 'Weapon', child: Text('Weapon')),
                    DropdownMenuItem(value: 'Armor', child: Text('Armor')),
                    DropdownMenuItem(value: 'Tool', child: Text('Tool')),
                    DropdownMenuItem(
                        value: 'Building', child: Text('Building')),
                    DropdownMenuItem(value: 'Vehicle', child: Text('Vehicle')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => category = value);
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: sourceType,
                  items: const [
                    DropdownMenuItem(value: 'Unknown', child: Text('Unknown')),
                    DropdownMenuItem(value: 'Vendor', child: Text('Vendor')),
                    DropdownMenuItem(value: 'Quest', child: Text('Quest')),
                    DropdownMenuItem(value: 'Chest', child: Text('Chest')),
                    DropdownMenuItem(value: 'Trainer', child: Text('Trainer')),
                    DropdownMenuItem(value: 'Drop', child: Text('Drop')),
                    DropdownMenuItem(
                        value: 'Crafting', child: Text('Crafting')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  decoration: const InputDecoration(labelText: 'Source type'),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => sourceType = value);
                    }
                  },
                ),
                TextField(
                  controller: sourceController,
                  decoration: const InputDecoration(
                    labelText: 'Source / location',
                    hintText: 'Example: cave, outpost, NPC, or coordinates',
                  ),
                ),
                TextField(
                  controller: materialsController,
                  decoration: const InputDecoration(
                    labelText: 'Required materials',
                    hintText: 'One material per line',
                  ),
                  minLines: 2,
                  maxLines: 4,
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  minLines: 2,
                  maxLines: 4,
                ),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text('Future links'),
                  children: [
                    TextField(
                      controller: questController,
                      decoration:
                          const InputDecoration(labelText: 'Quest ID/link'),
                    ),
                    TextField(
                      controller: mapPinController,
                      decoration:
                          const InputDecoration(labelText: 'Map pin ID/link'),
                    ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Unlocked'),
                  value: isUnlocked,
                  onChanged: (value) => setDialogState(() {
                    isUnlocked = value;
                    if (!isUnlocked) {
                      respawnTimerEnabled = false;
                    }
                  }),
                ),
                if (isUnlocked)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Respawn timer'),
                    subtitle: const Text('Estimate 45 minutes after pickup'),
                    value: respawnTimerEnabled,
                    onChanged: (value) =>
                        setDialogState(() => respawnTimerEnabled = value),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final materials = materialsController.text
                    .split('\n')
                    .map((line) => line.trim())
                    .where((line) => line.isNotEmpty)
                    .toList();
                final unlockedAt =
                    isUnlocked ? existing?.unlockedAt ?? now : null;
                final shouldRunTimer = isUnlocked && respawnTimerEnabled;

                final activeRegion = _regionFilter(characterId);
                final defaultedRegion = activeRegion == _allRegions
                    ? Blueprint.defaultRegion
                    : activeRegion;
                final blueprint = Blueprint(
                  id: existing?.id ?? const Uuid().v4(),
                  characterId: characterId,
                  name: name,
                  category: category,
                  region: existing?.region ?? defaultedRegion,
                  sourceType: sourceType == 'Unknown' ? null : sourceType,
                  sourceLocation: _emptyToNull(sourceController.text),
                  requiredMaterials: materials,
                  notes: _emptyToNull(notesController.text),
                  isUnlocked: isUnlocked,
                  unlockedAt: unlockedAt,
                  respawnTimerEnabled: shouldRunTimer,
                  questId: _emptyToNull(questController.text),
                  mapPinId: _emptyToNull(mapPinController.text),
                  createdAt: existing?.createdAt ?? now,
                  updatedAt: now,
                );

                await ref.read(blueprintEditorProvider).save(blueprint);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Blueprint blueprint) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Blueprint?'),
        content: Text('Delete "${blueprint.name}" from this character?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(blueprintEditorProvider).delete(blueprint);
    }
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _key(String value) => value.trim().toLowerCase();
}

class _BlueprintChecklistRow {
  final BlueprintCatalogEntry? entry;
  final Blueprint? blueprint;

  const _BlueprintChecklistRow({
    this.entry,
    this.blueprint,
  });

  String get name => blueprint?.name ?? entry!.name;

  String get category => blueprint?.category ?? entry!.category;

  /// Display string for the source(s) of this schematic. For catalog rows
  /// with multiple drop sites, lists them all separated by " · ".
  String get location {
    if (entry != null) {
      return entry!.sources.map((s) => s.label).join(' · ');
    }
    final bp = blueprint!;
    final loc = bp.sourceLocation;
    if (loc == null || loc.trim().isEmpty) return bp.region;
    return '${bp.region}, $loc';
  }

  /// Primary region label shown next to category in the card subtitle.
  /// For multi-source schematics, joins regions with " / ".
  String get regionLabel {
    if (entry != null) {
      return entry!.regions.join(' / ');
    }
    return blueprint?.region ?? Blueprint.defaultRegion;
  }

  String? get sourceType =>
      blueprint?.sourceType ?? (entry == null ? null : 'Chest');

  List<String> get requiredMaterials =>
      blueprint?.requiredMaterials ?? const [];

  String? get notes => blueprint?.notes;

  String? get questId => blueprint?.questId;

  String? get mapPinId => blueprint?.mapPinId;

  bool get isUnlocked => blueprint?.isUnlocked ?? false;

  DateTime? get unlockedAt => blueprint?.unlockedAt;

  bool get respawnTimerEnabled => blueprint?.respawnTimerEnabled ?? false;

  bool get isSeeded => entry != null;
}

class _BlueprintCard extends StatelessWidget {
  final _BlueprintChecklistRow row;
  final VoidCallback onToggle;
  final ValueChanged<bool>? onToggleRespawnTimer;
  final VoidCallback? onResetRespawn;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const _BlueprintCard({
    required this.row,
    required this.onToggle,
    required this.onToggleRespawnTimer,
    required this.onResetRespawn,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: row.isUnlocked,
                  onChanged: (_) => onToggle(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('${row.category} • ${row.regionLabel}'),
                      if (row.isUnlocked) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            FilterChip(
                              label: const Text('Respawn timer'),
                              avatar: Checkbox(
                                value: row.respawnTimerEnabled,
                                onChanged: onToggleRespawnTimer == null
                                    ? null
                                    : (value) => onToggleRespawnTimer!(
                                          value ?? false,
                                        ),
                                visualDensity: VisualDensity.compact,
                              ),
                              selected: row.respawnTimerEnabled,
                              onSelected: onToggleRespawnTimer,
                            ),
                            if (row.respawnTimerEnabled &&
                                row.unlockedAt != null)
                              _RespawnTimerChip(
                                unlockedAt: row.unlockedAt!,
                                onReset: onResetRespawn,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                ),
                if (onDelete != null)
                  IconButton(
                    tooltip: row.isSeeded ? 'Reset' : 'Delete',
                    onPressed: onDelete,
                    icon: Icon(row.isSeeded ? Icons.restart_alt : Icons.delete),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(row.location),
            if (row.sourceType != null) ...[
              const SizedBox(height: 12),
              Chip(label: Text(row.sourceType!)),
            ],
            if (row.requiredMaterials.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: row.requiredMaterials
                    .map((material) => Chip(label: Text(material)))
                    .toList(),
              ),
            ],
            if (row.notes != null) ...[
              const SizedBox(height: 12),
              Text(row.notes!),
            ],
            if (row.questId != null || row.mapPinId != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  if (row.questId != null)
                    Chip(label: Text('Quest: ${row.questId}')),
                  if (row.mapPinId != null)
                    Chip(label: Text('Map pin: ${row.mapPinId}')),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RespawnTimerChip extends StatelessWidget {
  final DateTime unlockedAt;
  final VoidCallback? onReset;

  const _RespawnTimerChip({
    required this.unlockedAt,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (tick) => tick),
      builder: (context, snapshot) {
        final remaining = _remainingRespawnTime(unlockedAt);
        final isReady = remaining <= Duration.zero;
        final colorScheme = Theme.of(context).colorScheme;

        return InputChip(
          avatar: Icon(
            isReady ? Icons.check_circle_outline : Icons.timer_outlined,
            size: 18,
          ),
          label: Text(
            isReady
                ? 'Respawn ready'
                : 'Respawns in ${_formatRespawnDuration(remaining)}',
          ),
          tooltip: 'Schematic respawn estimate: 45 minutes',
          onPressed: onReset,
          deleteIcon: const Icon(Icons.restart_alt, size: 18),
          onDeleted: onReset,
          backgroundColor: isReady
              ? colorScheme.secondaryContainer
              : colorScheme.surfaceContainerHighest,
        );
      },
    );
  }

  Duration _remainingRespawnTime(DateTime unlockedAt) {
    final readyAt = unlockedAt.add(_schematicRespawnDuration);
    return readyAt.difference(DateTime.now());
  }

  String _formatRespawnDuration(Duration duration) {
    final clamped = duration.isNegative ? Duration.zero : duration;
    final minutes = clamped.inMinutes;
    final seconds = clamped.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

/// One pool in the Site view — a (region, location) bucket containing
/// every schematic that drops at that site. `totalRows` and
/// `unlockedRows` are pre-filter counts used for the section's
/// "X / N collected" chip; `rows` is the post-status-filter list
/// actually rendered.
class _PoolSection {
  final String region;
  final String location;
  final List<_BlueprintChecklistRow> rows;
  final int totalRows;
  final int unlockedRows;

  _PoolSection({
    required this.region,
    required this.location,
    required this.rows,
    int? totalRows,
    int? unlockedRows,
  })  : totalRows = totalRows ?? rows.length,
        unlockedRows =
            unlockedRows ?? rows.where((r) => r.isUnlocked).length;
}

/// Compact in-header toggle for the per-user "auto-start respawn timer
/// when I unlock a schematic" preference. Lives on the tracker screen
/// (rather than the global Settings screen) because the rest of this
/// feature uses literal English strings — moving it to Settings would
/// require localising it across all 7 ARB files.
class _AutoRespawnTimerSwitch extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoStart =
        ref.watch(blueprintSettingsProvider).autoStartRespawnTimer;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Auto-start respawn timer'),
              Text(
                'When I tick a schematic as unlocked, also start its '
                '45-minute chest cooldown.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Switch(
          value: autoStart,
          onChanged: (value) => ref
              .read(blueprintSettingsProvider.notifier)
              .setAutoStartRespawnTimer(value),
        ),
      ],
    );
  }
}
