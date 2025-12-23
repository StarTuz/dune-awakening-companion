import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/base.dart';
import '../providers/base_provider.dart';
import '../../characters/providers/character_provider.dart';
import '../../../shared/theme/app_colors.dart';

class BaseManagementScreen extends ConsumerWidget {
  const BaseManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersProvider);
    final basesAsync = ref.watch(basesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Base Management'),
      ),
      body: charactersAsync.when(
        data: (characters) => basesAsync.when(
          data: (bases) {
            if (characters.isEmpty) {
              return const Center(
                child: Text('Create a character first to add bases.'),
              );
            }
            if (bases.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No bases yet.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showAddDialog(context, ref, characters),
                      child: const Text('Add Base'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: bases.length,
              itemBuilder: (context, index) {
                final base = bases[index];
                final character = characters.firstWhere(
                  (c) => c.id == base.characterId,
                  orElse: () => characters.first,
                );
                return _BaseCard(
                  base: base,
                  characterName: character.name,
                  onEdit: () => _showEditDialog(context, ref, base),
                  onDelete: () => _showDeleteDialog(context, ref, base),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => charactersAsync.when(
          data: (characters) {
            if (characters.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create a character first.')),
              );
              return;
            }
            _showAddDialog(context, ref, characters);
          },
          loading: () {},
          error: (_, __) {},
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(
    BuildContext context,
    WidgetRef ref,
    List characters,
  ) {
    final nameController = TextEditingController();
    final expirationController = TextEditingController();
    String? selectedCharacterId;
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Base'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Character'),
                items: characters.map<DropdownMenuItem<String>>((character) {
                  return DropdownMenuItem<String>(
                    value: character.id,
                    child: Text(character.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCharacterId = value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Base Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: expirationController,
                decoration: const InputDecoration(
                  labelText: 'Power Expiration',
                  hintText: 'YYYY-MM-DD HH:MM',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      selectedDate = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      expirationController.text =
                          DateFormat('yyyy-MM-dd HH:mm').format(selectedDate!);
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    selectedCharacterId != null &&
                    selectedDate != null) {
                  ref.read(basesProvider.notifier).createBase(
                        selectedCharacterId!,
                        nameController.text,
                        selectedDate!,
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

  void _showEditDialog(BuildContext context, WidgetRef ref, Base base) {
    final nameController = TextEditingController(text: base.name);
    final expirationController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(base.powerExpirationTime),
    );
    DateTime? selectedDate = base.powerExpirationTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Base'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Base Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: expirationController,
                decoration: const InputDecoration(
                  labelText: 'Power Expiration',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
                    );
                    if (time != null) {
                      selectedDate = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      expirationController.text =
                          DateFormat('yyyy-MM-dd HH:mm').format(selectedDate!);
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && selectedDate != null) {
                  ref.read(basesProvider.notifier).updateBase(
                        base.copyWith(
                          name: nameController.text,
                          powerExpirationTime: selectedDate,
                        ),
                      );
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Base base) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Base'),
        content: Text('Are you sure you want to delete ${base.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(basesProvider.notifier).deleteBase(base.id, base.characterId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Base base;
  final String characterName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BaseCard({
    required this.base,
    required this.characterName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hoursRemaining = base.hoursRemaining;
    final color = DuneColors.getStatusColor(hoursRemaining);
    final statusText = hoursRemaining > 0
        ? '${hoursRemaining.toStringAsFixed(1)}h remaining'
        : 'Expired';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(base.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Character: $characterName'),
            const SizedBox(height: 4),
            Text(
              statusText,
              style: TextStyle(color: color),
            ),
            Text(
              'Expires: ${DateFormat('yyyy-MM-dd HH:mm').format(base.powerExpirationTime)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
