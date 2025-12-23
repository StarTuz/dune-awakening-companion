import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../bases/models/base.dart';
import '../../bases/providers/base_provider.dart';
import '../../characters/models/character.dart';
import '../../characters/providers/character_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/navigation/main_navigation.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basesAsync = ref.watch(basesProvider);
    final charactersAsync = ref.watch(charactersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(basesProvider);
              ref.invalidate(charactersProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(basesProvider);
          ref.invalidate(charactersProvider);
          // Wait a bit for providers to reload
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: basesAsync.when(
        data: (bases) => charactersAsync.when(
          data: (characters) {
            // Filter bases that are expiring soon (< 48 hours)
            final expiringBases = bases.where((base) {
              return base.hoursRemaining < 48;
            }).toList();

            // Sort by most urgent first
            expiringBases.sort((a, b) => a.hoursRemaining.compareTo(b.hoursRemaining));

            if (expiringBases.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'All bases are safe!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('No bases expire in the next 48 hours.'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: expiringBases.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final base = expiringBases[index];
                
                // Find the character for this base
                Character? character;
                try {
                  character = characters.firstWhere((c) => c.id == base.characterId);
                } catch (e) {
                  return const SizedBox.shrink();
                }

                final now = DateTime.now();
                final difference = base.powerExpirationTime.difference(now);
                final daysRemaining = difference.inDays;
                final hoursRemaining = difference.inHours % 24;
                final minutesRemaining = difference.inMinutes % 60;
                final totalHours = base.hoursRemaining;
                
                // Determine severity
                final isCritical = totalHours < 24;
                final color = isCritical 
                    ? DuneColors.criticalPrimary 
                    : DuneColors.warningPrimary;
                final severityLabel = isCritical ? 'CRITICAL' : 'WARNING';
                final timeText = '${daysRemaining}d ${hoursRemaining}h ${minutesRemaining}m';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  color: color.withOpacity(0.1),
                  child: InkWell(
                    onTap: () {
                      // Navigate to Characters tab
                      ref.read(navigationIndexProvider.notifier).state = 1;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  severityLabel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  base.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.person, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                character.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.public, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${character.region} - ${character.world}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.home, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                character.sietch,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          // Power Time Remaining
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time Remaining: Power',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    timeText,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Expires',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM d, HH:mm').format(base.powerExpirationTime),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Tax Time Remaining (if applicable)
                          if (base.isAdvancedFief && base.nextTaxDueDate != null) ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time Remaining: Taxes',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        final taxDifference = base.nextTaxDueDate!.difference(DateTime.now());
                                        final taxDays = taxDifference.inDays;
                                        final taxHours = taxDifference.inHours % 24;
                                        final taxMinutes = taxDifference.inMinutes % 60;
                                        final taxTotalHours = taxDifference.inMinutes / 60.0;
                                        
                                        final taxColor = taxTotalHours < 0 
                                            ? DuneColors.criticalPrimary
                                            : (taxTotalHours < 24 
                                                ? DuneColors.warningPrimary 
                                                : Colors.green);
                                        
                                        final taxText = taxTotalHours >= 0
                                            ? '${taxDays}d ${taxHours}h ${taxMinutes}m'
                                            : 'Overdue: ${taxDays.abs()}d ${taxHours.abs()}h ${taxMinutes.abs()}m';
                                        
                                        return Text(
                                          taxText,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: taxColor,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Due',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MMM d, HH:mm').format(base.nextTaxDueDate!),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            'Tap to manage this character\'s bases',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error loading characters: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error loading bases: $error')),
        ),
      ),
    );
  }
}
