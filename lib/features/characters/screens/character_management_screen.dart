import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../models/character.dart';
import '../providers/character_provider.dart';
import '../../bases/models/base.dart';
import '../../bases/providers/base_provider.dart';
import '../../../core/utils/constants.dart';
import '../../../core/providers/image_service_provider.dart';
import '../../../shared/theme/app_colors.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

class CharacterManagementScreen extends ConsumerWidget {
  const CharacterManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Management'),
      ),
      body: charactersAsync.when(
        data: (characters) => characters.isEmpty
            ? const Center(
                child: Text('No characters yet. Add one to get started.'),
              )
            : ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];

                  final serverInfo = character.serverType == 'Private' &&
                          character.provider != null
                      ? '${character.provider} - ${character.world}'
                      : character.world;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      subtitle: Text(
                          '${character.region} - $serverInfo - ${character.sietch}'),
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
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: DuneColors.primaryAccent,
                            onPressed: () =>
                                _showEditDialog(context, ref, character),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: DuneColors.error,
                            onPressed: () =>
                                _showDeleteDialog(context, ref, character),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final worldController = TextEditingController();
    final sietchController = TextEditingController();
    String? selectedRegion;
    String? selectedServerType;
    String? selectedProvider;
    String? selectedWorld;
    List<String> availableWorlds = [];
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
                      selectedProvider = null;
                      selectedWorld = null;
                      worldController.clear();
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Show provider dropdown only for Private servers
                if (selectedServerType == AppConstants.serverTypePrivate) ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Provider'),
                    value: selectedProvider,
                    items: AppConstants.privateProviders
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
                // Show world dropdown for Official, text field for Private
                if (selectedServerType == AppConstants.serverTypeOfficial)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'World'),
                    value: selectedWorld,
                    items:
                        availableWorlds.map<DropdownMenuItem<String>>((world) {
                      return DropdownMenuItem<String>(
                        value: world,
                        child: Text(world),
                      );
                    }).toList(),
                    onChanged: selectedRegion != null
                        ? (value) => setState(() => selectedWorld = value)
                        : null,
                  )
                else if (selectedServerType == AppConstants.serverTypePrivate)
                  TextField(
                    controller: worldController,
                    decoration: const InputDecoration(
                      labelText: 'World/Server Name',
                      hintText: 'Enter private server name',
                    ),
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
                final worldValue =
                    selectedServerType == AppConstants.serverTypeOfficial
                        ? selectedWorld
                        : worldController.text;

                if (nameController.text.isNotEmpty &&
                    selectedRegion != null &&
                    selectedServerType != null &&
                    (selectedServerType == AppConstants.serverTypeOfficial
                        ? selectedWorld != null
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
    final worldController = TextEditingController(
      text: character.serverType == AppConstants.serverTypePrivate
          ? character.world
          : '',
    );
    final sietchController = TextEditingController(text: character.sietch);

    String? selectedRegion = character.region;
    String? selectedServerType = character.serverType;
    String? selectedProvider = character.provider;
    String? selectedWorld =
        character.serverType == AppConstants.serverTypeOfficial
            ? character.world
            : null;
    List<String> availableWorlds =
        AppConstants.getWorldsForRegion(character.region);

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
                      selectedProvider = null;
                      selectedWorld = null;
                      worldController.clear();
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (selectedServerType == AppConstants.serverTypePrivate) ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Provider'),
                    value: selectedProvider,
                    items: AppConstants.privateProviders
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
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'World'),
                    value: selectedWorld,
                    items:
                        availableWorlds.map<DropdownMenuItem<String>>((world) {
                      return DropdownMenuItem<String>(
                        value: world,
                        child: Text(world),
                      );
                    }).toList(),
                    onChanged: selectedRegion != null
                        ? (value) => setState(() => selectedWorld = value)
                        : null,
                  )
                else if (selectedServerType == AppConstants.serverTypePrivate)
                  TextField(
                    controller: worldController,
                    decoration: const InputDecoration(
                      labelText: 'World/Server Name',
                    ),
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
                final worldValue =
                    selectedServerType == AppConstants.serverTypeOfficial
                        ? selectedWorld
                        : worldController.text;

                if (nameController.text.isNotEmpty &&
                    selectedRegion != null &&
                    selectedServerType != null &&
                    (selectedServerType == AppConstants.serverTypeOfficial
                        ? selectedWorld != null
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

  void _showAddBaseDialog(
      BuildContext context, WidgetRef ref, String characterId) {
    final nameController = TextEditingController();
    final daysController = TextEditingController();
    final hoursController = TextEditingController();
    final minutesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

                ref.read(basesProvider.notifier).createBase(
                      characterId,
                      nameController.text,
                      expirationTime,
                    );
                Navigator.of(context).pop(); // Close add dialog
                Navigator.of(context).pop(); // Close base management dialog
              }
            },
            child: const Text('Add'),
          ),
        ],
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                        updatedAt: DateTime.now(),
                      ),
                    );
                Navigator.of(context).pop(); // Close edit dialog
                Navigator.of(context).pop(); // Close base management dialog
              }
            },
            child: const Text('Save'),
          ),
        ],
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
