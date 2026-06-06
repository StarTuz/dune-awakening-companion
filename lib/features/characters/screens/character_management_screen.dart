import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/character.dart';
import '../providers/character_provider.dart';
import '../../bases/models/base.dart';
import '../../bases/providers/base_provider.dart';
import 'character_progress_dialog.dart';
import '../../../core/utils/constants.dart';
import '../../../core/providers/image_service_provider.dart';
import '../../../shared/theme/app_colors.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

class CharacterManagementScreen extends ConsumerWidget {
  const CharacterManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Management'),
      ),
      body: charactersAsync.when(
        data: (allCharacters) {
          final showClosedOnly = ref.watch(closedWorldCharacterFilterProvider);
          final characters = showClosedOnly
              ? allCharacters
                  .where((c) =>
                      AppConstants.isClosedWorld(c.world) &&
                      !c.closedWorldAcknowledged)
                  .toList()
              : allCharacters;
          return Column(
            children: [
              if (showClosedOnly)
                _ClosedWorldFilterBanner(
                  onClear: () => ref
                      .read(closedWorldCharacterFilterProvider.notifier)
                      .state = false,
                ),
              Expanded(
                child: characters.isEmpty
                    ? Center(
                        child: Text(showClosedOnly
                            ? l10n.characterFilterClosedWorldsEmpty
                            : 'No characters yet. Add one to get started.'),
                      )
                    : ListView.builder(
                        itemCount: characters.length,
                        itemBuilder: (context, index) {
                          final character = characters[index];

                          final serverInfo = AppConstants.usesFreeformWorldName(
                                      character.serverType) &&
                                  character.provider != null
                              ? '${character.provider} - ${character.world}'
                              : character.world;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundImage: character.portraitPath != null
                                    ? FileImage(File(character.portraitPath!))
                                    : null,
                                child: character.portraitPath == null
                                    ? const Icon(Icons.person, size: 32)
                                    : null,
                              ),
                              title: Text(character.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      '${character.region} - $serverInfo - ${character.sietch}'),
                                  if (AppConstants.isClosedWorld(
                                          character.world) &&
                                      !character.closedWorldAcknowledged)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: _ClosedWorldBadge(
                                        onDismiss: () => _dismissClosedWorld(
                                            context, ref, character, l10n),
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _showBaseManagementDialog(
                                        context, ref, character),
                                    icon: const Icon(Icons.home_work, size: 18),
                                    label: const Text('Bases'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _showProgressDialog(
                                      context,
                                      character,
                                    ),
                                    icon: const Icon(Icons.insights, size: 18),
                                    label: const Text('Progress'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: DuneColors.primaryAccent,
                                    onPressed: () => _showEditDialog(
                                        context, ref, character),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: DuneColors.error,
                                    onPressed: () => _showDeleteDialog(
                                        context, ref, character),
                                  ),
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
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Acknowledge (dismiss) the closed-world notice for [character], with an
  /// Undo action. Non-destructive: only flips the acknowledgement flag.
  void _dismissClosedWorld(BuildContext context, WidgetRef ref,
      Character character, AppLocalizations l10n) {
    ref.read(charactersProvider.notifier).updateCharacter(
          character.copyWith(
            closedWorldAcknowledged: true,
            updatedAt: DateTime.now(),
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.characterClosedWorldDismissed),
        action: SnackBarAction(
          label: l10n.actionUndo,
          onPressed: () =>
              ref.read(charactersProvider.notifier).updateCharacter(
                    character.copyWith(
                      closedWorldAcknowledged: false,
                      updatedAt: DateTime.now(),
                    ),
                  ),
        ),
      ),
    );
  }

  // Sentinel dropdown value that switches the Official world picker into
  // free-text entry, so a character can be recorded on any world (including
  // ones not in the bundled list, e.g. after future migrations).
  static const String _customWorldSentinel = '__custom_world__';

  /// Official-server world picker: a per-region dropdown that marks closed
  /// worlds and offers a "custom world" option revealing a free-text field.
  Widget _buildOfficialWorldField({
    required BuildContext context,
    required String? region,
    required List<String> availableWorlds,
    required String? selectedWorld,
    required bool customWorld,
    required TextEditingController worldController,
    required void Function(String?) onSelectWorld,
    required void Function(bool useCustom) onUseCustom,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'World'),
          value: customWorld ? _customWorldSentinel : selectedWorld,
          items: [
            ...availableWorlds.map((world) {
              final label = AppConstants.isClosedWorld(world)
                  ? '$world ${l10n.characterWorldClosedSuffix}'
                  : world;
              return DropdownMenuItem<String>(
                value: world,
                child: Text(label, overflow: TextOverflow.ellipsis),
              );
            }),
            DropdownMenuItem<String>(
              value: _customWorldSentinel,
              child: Text(l10n.characterWorldCustomOption),
            ),
          ],
          onChanged: region != null
              ? (value) {
                  if (value == _customWorldSentinel) {
                    onUseCustom(true);
                  } else {
                    onUseCustom(false);
                    onSelectWorld(value);
                  }
                }
              : null,
        ),
        if (customWorld) ...[
          const SizedBox(height: 12),
          TextField(
            controller: worldController,
            decoration: InputDecoration(
              labelText: l10n.characterWorldCustomLabel,
              hintText: l10n.characterWorldCustomHint,
            ),
          ),
        ],
      ],
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final worldController = TextEditingController();
    final sietchController = TextEditingController();
    String? selectedRegion;
    String? selectedServerType;
    String? selectedProvider;
    String? selectedWorld;
    String? selectedPrimaryClass;
    List<String> availableWorlds = [];
    bool customWorld = false;
    String? selectedPortraitPath; // Portrait path

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Character'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Portrait picker
                GestureDetector(
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: false,
                    );
                    if (result != null && result.files.single.path != null) {
                      setState(() {
                        selectedPortraitPath = result.files.single.path;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: selectedPortraitPath != null
                        ? FileImage(File(selectedPortraitPath!))
                        : null,
                    child: selectedPortraitPath == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 32),
                              SizedBox(height: 4),
                              Text('Add Portrait',
                                  style: TextStyle(fontSize: 10)),
                            ],
                          )
                        : null,
                  ),
                ),
                if (selectedPortraitPath != null)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedPortraitPath = null;
                      });
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Remove', style: TextStyle(fontSize: 12)),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Character Name',
                    hintText: 'Enter character name',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Region'),
                  value: selectedRegion,
                  items: AppConstants.regions
                      .map<DropdownMenuItem<String>>((region) {
                    return DropdownMenuItem<String>(
                      value: region,
                      child: Text(region),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value;
                      selectedWorld = null;
                      customWorld = false;
                      worldController.clear();
                      availableWorlds = value != null
                          ? AppConstants.getWorldsForRegion(value)
                          : [];
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Server Type'),
                  value: selectedServerType,
                  items: AppConstants.serverTypes
                      .map<DropdownMenuItem<String>>((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedServerType = value;
                      selectedProvider =
                          value == AppConstants.serverTypeSelfHosted
                              ? AppConstants.serverTypeSelfHosted
                              : null;
                      selectedWorld = null;
                      customWorld = false;
                      worldController.clear();
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Show provider dropdown for non-official server types.
                if (AppConstants.getProvidersForServerType(selectedServerType)
                    .isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Provider'),
                    value: selectedProvider,
                    items: AppConstants.getProvidersForServerType(
                            selectedServerType)
                        .map<DropdownMenuItem<String>>((provider) {
                      return DropdownMenuItem<String>(
                        value: provider,
                        child: Text(provider),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedProvider = value),
                  ),
                  const SizedBox(height: 16),
                ],
                // Show world dropdown for Official, text field for other server types.
                if (selectedServerType == AppConstants.serverTypeOfficial)
                  _buildOfficialWorldField(
                    context: context,
                    region: selectedRegion,
                    availableWorlds: availableWorlds,
                    selectedWorld: selectedWorld,
                    customWorld: customWorld,
                    worldController: worldController,
                    onSelectWorld: (value) =>
                        setState(() => selectedWorld = value),
                    onUseCustom: (useCustom) => setState(() {
                      customWorld = useCustom;
                      if (!useCustom) worldController.clear();
                    }),
                  )
                else if (AppConstants.usesFreeformWorldName(selectedServerType))
                  TextField(
                    controller: worldController,
                    decoration: InputDecoration(
                      labelText: 'World/Server Name',
                      hintText: selectedServerType ==
                              AppConstants.serverTypeSelfHosted
                          ? 'Enter self-hosted world/server name'
                          : 'Enter private server name',
                    ),
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Starting Class'),
                  value: selectedPrimaryClass,
                  items: AppConstants.primaryClasses
                      .map<DropdownMenuItem<String>>((className) {
                    return DropdownMenuItem<String>(
                      value: className,
                      child: Text(className),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedPrimaryClass = value);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: sietchController,
                  decoration: const InputDecoration(
                    labelText: 'Sietch',
                    hintText: 'Enter sietch name',
                  ),
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
              onPressed: () {
                final isOfficial =
                    selectedServerType == AppConstants.serverTypeOfficial;
                final worldValue = isOfficial
                    ? (customWorld
                        ? worldController.text.trim()
                        : selectedWorld)
                    : worldController.text;

                if (nameController.text.isNotEmpty &&
                    selectedRegion != null &&
                    selectedServerType != null &&
                    (isOfficial
                        ? (customWorld
                            ? worldController.text.trim().isNotEmpty
                            : selectedWorld != null)
                        : (worldController.text.isNotEmpty &&
                            selectedProvider != null)) &&
                    sietchController.text.isNotEmpty) {
                  final imageService = ref.read(imageServiceProvider);
                  ref
                      .read(charactersProvider.notifier)
                      .createCharacterWithPortrait(
                        nameController.text,
                        selectedRegion!,
                        selectedServerType!,
                        selectedProvider,
                        worldValue!,
                        sietchController.text,
                        selectedPrimaryClass,
                        selectedPortraitPath,
                        imageService,
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, Character character) {
    final nameController = TextEditingController(text: character.name);
    List<String> availableWorlds =
        AppConstants.getWorldsForRegion(character.region);
    final bool isOfficialInit =
        character.serverType == AppConstants.serverTypeOfficial;
    // Existing Official characters whose world is no longer in the bundled list
    // (renamed/legacy spelling, or already off-list) open in custom mode so the
    // strict dropdown never receives an out-of-list value.
    bool customWorld =
        isOfficialInit && !availableWorlds.contains(character.world);

    final worldController = TextEditingController(
      text: AppConstants.usesFreeformWorldName(character.serverType) ||
              customWorld
          ? character.world
          : '',
    );
    final sietchController = TextEditingController(text: character.sietch);

    String? selectedRegion = character.region;
    String? selectedServerType = character.serverType;
    String? selectedProvider = character.provider;
    String? selectedWorld =
        isOfficialInit && !customWorld ? character.world : null;
    String? selectedPrimaryClass = character.primaryClass;

    // Portrait state - start with existing portrait
    String? selectedPortraitPath = character.portraitPath;
    bool portraitChanged = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Character'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Portrait picker
                GestureDetector(
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: false,
                    );
                    if (result != null && result.files.single.path != null) {
                      setState(() {
                        selectedPortraitPath = result.files.single.path;
                        portraitChanged = true;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: selectedPortraitPath != null
                        ? FileImage(File(selectedPortraitPath!))
                        : null,
                    child: selectedPortraitPath == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 32),
                              SizedBox(height: 4),
                              Text('Add Portrait',
                                  style: TextStyle(fontSize: 10)),
                            ],
                          )
                        : null,
                  ),
                ),
                if (selectedPortraitPath != null)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedPortraitPath = null;
                        portraitChanged = true;
                      });
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Remove', style: TextStyle(fontSize: 12)),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Character Name',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Region'),
                  value: selectedRegion,
                  items: AppConstants.regions
                      .map<DropdownMenuItem<String>>((region) {
                    return DropdownMenuItem<String>(
                      value: region,
                      child: Text(region),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value;
                      selectedWorld = null;
                      customWorld = false;
                      worldController.clear();
                      availableWorlds = value != null
                          ? AppConstants.getWorldsForRegion(value)
                          : [];
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Server Type'),
                  value: selectedServerType,
                  items: AppConstants.serverTypes
                      .map<DropdownMenuItem<String>>((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedServerType = value;
                      selectedProvider =
                          value == AppConstants.serverTypeSelfHosted
                              ? AppConstants.serverTypeSelfHosted
                              : null;
                      selectedWorld = null;
                      customWorld = false;
                      worldController.clear();
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (AppConstants.getProvidersForServerType(selectedServerType)
                    .isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Provider'),
                    value: selectedProvider,
                    items: AppConstants.getProvidersForServerType(
                            selectedServerType)
                        .map<DropdownMenuItem<String>>((provider) {
                      return DropdownMenuItem<String>(
                        value: provider,
                        child: Text(provider),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedProvider = value),
                  ),
                  const SizedBox(height: 16),
                ],
                if (selectedServerType == AppConstants.serverTypeOfficial)
                  _buildOfficialWorldField(
                    context: context,
                    region: selectedRegion,
                    availableWorlds: availableWorlds,
                    selectedWorld: selectedWorld,
                    customWorld: customWorld,
                    worldController: worldController,
                    onSelectWorld: (value) =>
                        setState(() => selectedWorld = value),
                    onUseCustom: (useCustom) => setState(() {
                      customWorld = useCustom;
                      if (!useCustom) worldController.clear();
                    }),
                  )
                else if (AppConstants.usesFreeformWorldName(selectedServerType))
                  TextField(
                    controller: worldController,
                    decoration: InputDecoration(
                      labelText: 'World/Server Name',
                      hintText: selectedServerType ==
                              AppConstants.serverTypeSelfHosted
                          ? 'Enter self-hosted world/server name'
                          : 'Enter private server name',
                    ),
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Starting Class'),
                  value: selectedPrimaryClass,
                  items: AppConstants.primaryClasses
                      .map<DropdownMenuItem<String>>((className) {
                    return DropdownMenuItem<String>(
                      value: className,
                      child: Text(className),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedPrimaryClass = value);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: sietchController,
                  decoration: const InputDecoration(
                    labelText: 'Sietch',
                  ),
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
              onPressed: () {
                final isOfficial =
                    selectedServerType == AppConstants.serverTypeOfficial;
                final worldValue = isOfficial
                    ? (customWorld
                        ? worldController.text.trim()
                        : selectedWorld)
                    : worldController.text;

                if (nameController.text.isNotEmpty &&
                    selectedRegion != null &&
                    selectedServerType != null &&
                    (isOfficial
                        ? (customWorld
                            ? worldController.text.trim().isNotEmpty
                            : selectedWorld != null)
                        : (worldController.text.isNotEmpty &&
                            selectedProvider != null)) &&
                    sietchController.text.isNotEmpty) {
                  final updatedCharacter = character.copyWith(
                    name: nameController.text,
                    region: selectedRegion,
                    serverType: selectedServerType,
                    provider: selectedProvider,
                    world: worldValue,
                    sietch: sietchController.text,
                    primaryClass: selectedPrimaryClass,
                    // Moving to a different world clears a previous dismissal so
                    // the notice can re-appear if the new world is also closed.
                    closedWorldAcknowledged: worldValue == character.world
                        ? character.closedWorldAcknowledged
                        : false,
                    updatedAt: DateTime.now(),
                  );

                  if (portraitChanged) {
                    // Portrait was changed, use special method
                    final imageService = ref.read(imageServiceProvider);
                    ref
                        .read(charactersProvider.notifier)
                        .updateCharacterWithPortrait(
                          updatedCharacter,
                          selectedPortraitPath,
                          portraitChanged,
                          imageService,
                        );
                  } else {
                    // No portrait change, use regular update
                    ref
                        .read(charactersProvider.notifier)
                        .updateCharacter(updatedCharacter);
                  }

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Character'),
        content: Text('Are you sure you want to delete ${character.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final imageService = ref.read(imageServiceProvider);
              final baseRepository = ref.read(baseRepositoryProvider);
              ref.read(charactersProvider.notifier).deleteCharacter(
                    character.id,
                    imageService,
                    baseRepository,
                  );
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showBaseManagementDialog(
      BuildContext context, WidgetRef ref, Character character) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: Scaffold(
            appBar: AppBar(
              title: Text('${character.name} - Bases'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  _showAddBaseDialog(dialogContext, ref, character.id),
              tooltip: AppLocalizations.of(dialogContext)?.addBaseTooltip ??
                  'Add Base',
              child: const Icon(Icons.add),
            ),
            body: FutureBuilder<List<Base>>(
              future: ref
                  .read(baseRepositoryProvider)
                  .getByCharacterId(character.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final characterBases = snapshot.data ?? [];

                if (characterBases.isEmpty) {
                  return const Center(
                    child: Text('No bases yet. Add one using the + button!'),
                  );
                }

                return ListView.builder(
                  itemCount: characterBases.length,
                  itemBuilder: (context, index) {
                    final base = characterBases[index];
                    final now = DateTime.now();
                    final difference = base.powerExpirationTime.difference(now);
                    final daysRemaining = difference.inDays;
                    final hoursRemaining = difference.inHours % 24;
                    final minutesRemaining = difference.inMinutes % 60;
                    final totalHours = difference.inMinutes / 60.0;

                    final statusColor = DuneColors.getStatusColor(totalHours);
                    final statusText = totalHours > 0
                        ? 'Power: ${daysRemaining}d ${hoursRemaining}h ${minutesRemaining}m remaining'
                        : 'Power: Expired';

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(base.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Power Status
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Power Expires: ${DateFormat('yyyy-MM-dd HH:mm').format(base.powerExpirationTime)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: DuneColors.primaryAccent,
                              tooltip: AppLocalizations.of(context)
                                      ?.updateCountdownTooltip ??
                                  'Update countdown',
                              onPressed: () =>
                                  _showEditBaseDialog(dialogContext, ref, base),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: DuneColors.error,
                              onPressed: () => _showDeleteBaseDialog(
                                  dialogContext, ref, base),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showProgressDialog(BuildContext context, Character character) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 720),
          child: CharacterProgressDialog(character: character),
        ),
      ),
    );
  }

  void _showAddBaseDialog(
      BuildContext context, WidgetRef ref, String characterId) {
    final nameController = TextEditingController();
    final daysController = TextEditingController();
    final hoursController = TextEditingController();
    final minutesController = TextEditingController();
    bool notificationsEnabled = true;
    bool useCustomThresholds = false;
    final warningController = TextEditingController(text: '48');
    final criticalController = TextEditingController(text: '24');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Base'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Base Name',
                    hintText: 'e.g., Main Base, Mining Outpost',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Power Down In:', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: daysController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Days',
                          hintText: '0',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hours',
                          hintText: '0',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          hintText: '0',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: notificationsEnabled,
                  onChanged: (value) =>
                      setState(() => notificationsEnabled = value),
                  title: const Text('Notifications'),
                  subtitle:
                      const Text('Allow alerts and tray badges for this base'),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: useCustomThresholds,
                  onChanged: notificationsEnabled
                      ? (value) => setState(() => useCustomThresholds = value)
                      : null,
                  title: const Text('Custom alert thresholds'),
                  subtitle: const Text('Override the app-wide 48h / 24h rules'),
                ),
                if (useCustomThresholds) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: warningController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Warning Hours',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: criticalController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Critical Hours',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final days = int.tryParse(daysController.text) ?? 0;
                  final hours = int.tryParse(hoursController.text) ?? 0;
                  final minutes = int.tryParse(minutesController.text) ?? 0;

                  final expirationTime = DateTime.now().add(
                    Duration(days: days, hours: hours, minutes: minutes),
                  );

                  final warningThreshold = useCustomThresholds
                      ? int.tryParse(warningController.text)
                      : null;
                  final criticalThreshold = useCustomThresholds
                      ? int.tryParse(criticalController.text)
                      : null;

                  ref.read(basesProvider.notifier).createBase(
                        characterId,
                        nameController.text,
                        expirationTime,
                        notificationsEnabled: notificationsEnabled,
                        warningThresholdHours: warningThreshold,
                        criticalThresholdHours: criticalThreshold,
                      );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBaseDialog(BuildContext context, WidgetRef ref, Base base) {
    final nameController = TextEditingController(text: base.name);
    final now = DateTime.now();
    final difference = base.powerExpirationTime.difference(now);
    final daysRemaining = difference.inDays;
    final hoursRemaining = difference.inHours % 24;
    final minutesRemaining = difference.inMinutes % 60;

    final daysController =
        TextEditingController(text: daysRemaining.toString());
    final hoursController =
        TextEditingController(text: hoursRemaining.toString());
    final minutesController =
        TextEditingController(text: minutesRemaining.toString());
    bool notificationsEnabled = base.notificationsEnabled;
    bool useCustomThresholds = base.warningThresholdHours != null ||
        base.criticalThresholdHours != null;
    final warningController = TextEditingController(
      text: (base.warningThresholdHours ?? 48).toString(),
    );
    final criticalController = TextEditingController(
      text: (base.criticalThresholdHours ?? 24).toString(),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Base'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Base Name',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Power Down In:', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: daysController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Days',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hours',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: notificationsEnabled,
                  onChanged: (value) =>
                      setState(() => notificationsEnabled = value),
                  title: const Text('Notifications'),
                  subtitle:
                      const Text('Allow alerts and tray badges for this base'),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: useCustomThresholds,
                  onChanged: notificationsEnabled
                      ? (value) => setState(() => useCustomThresholds = value)
                      : null,
                  title: const Text('Custom alert thresholds'),
                  subtitle: const Text('Override the app-wide 48h / 24h rules'),
                ),
                if (useCustomThresholds) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: warningController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Warning Hours',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: criticalController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Critical Hours',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final days = int.tryParse(daysController.text) ?? 0;
                  final hours = int.tryParse(hoursController.text) ?? 0;
                  final minutes = int.tryParse(minutesController.text) ?? 0;

                  final expirationTime = DateTime.now().add(
                    Duration(days: days, hours: hours, minutes: minutes),
                  );

                  ref.read(basesProvider.notifier).updateBase(
                        base.copyWith(
                          name: nameController.text,
                          powerExpirationTime: expirationTime,
                          notificationsEnabled: notificationsEnabled,
                          warningThresholdHours: useCustomThresholds
                              ? int.tryParse(warningController.text)
                              : null,
                          criticalThresholdHours: useCustomThresholds
                              ? int.tryParse(criticalController.text)
                              : null,
                          updatedAt: DateTime.now(),
                        ),
                      );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteBaseDialog(BuildContext context, WidgetRef ref, Base base) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Base'),
        content: Text('Are you sure you want to delete "${base.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(basesProvider.notifier)
                  .deleteBase(base.id, base.characterId);
              Navigator.of(context).pop(); // Close delete dialog
              Navigator.of(context).pop(); // Close base management dialog
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Non-destructive notice shown on a character whose world closed in the
/// 2026-05-26 server migration. See [AppConstants.isClosedWorld].
class _ClosedWorldBadge extends StatelessWidget {
  const _ClosedWorldBadge({this.onDismiss});

  /// When provided, renders a dismiss (×) affordance that acknowledges the
  /// notice for this character.
  final VoidCallback? onDismiss;

  /// Opens Funcom's official migration guide in the system browser. Falls back
  /// to a snackbar if the platform can't open a browser (e.g. missing handler).
  Future<void> _openGuide(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    bool opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(AppConstants.serverMigrationGuideUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }
    if (!opened) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.characterClosedWorldOpenFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Tooltip(
      message: l10n.characterClosedWorldTooltip,
      child: InkWell(
        onTap: () => _openGuide(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: DuneColors.warningPrimary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DuneColors.warningPrimary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 14, color: DuneColors.warningPrimary),
              const SizedBox(width: 4),
              Text(
                l10n.characterClosedWorldBadge,
                style: const TextStyle(
                  color: DuneColors.warningPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.open_in_new,
                  size: 12, color: DuneColors.warningPrimary),
              if (onDismiss != null) ...[
                const SizedBox(width: 6),
                Tooltip(
                  message: l10n.characterClosedWorldDismiss,
                  child: InkWell(
                    onTap: onDismiss,
                    borderRadius: BorderRadius.circular(10),
                    child: const Icon(Icons.close,
                        size: 13, color: DuneColors.warningPrimary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Banner shown above the character list when filtered to closed-world
/// characters (e.g. arrived via the dashboard "On closed worlds" stat).
class _ClosedWorldFilterBanner extends StatelessWidget {
  const _ClosedWorldFilterBanner({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: DuneColors.warningPrimary.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.filter_alt,
                size: 18, color: DuneColors.warningPrimary),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.characterFilterClosedWorldsActive)),
            TextButton(
              onPressed: onClear,
              child: Text(l10n.actionClear),
            ),
          ],
        ),
      ),
    );
  }
}
