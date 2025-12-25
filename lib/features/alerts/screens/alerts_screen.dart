import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../bases/models/base.dart';
import '../../bases/providers/base_provider.dart';
import '../../characters/models/character.dart';
import '../../characters/providers/character_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/navigation/main_navigation.dart';
import '../widgets/notification_history_widget.dart';
import '../providers/notification_history_provider.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basesAsync = ref.watch(basesProvider);
    final charactersAsync = ref.watch(charactersProvider);
    final historyState = ref.watch(notificationHistoryProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.alertsTitle),
        actions: [
          // History button with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () => _showHistorySheet(context),
                tooltip: l10n.notificationHistoryTooltip,
              ),
              if (historyState.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.criticalStatus,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      historyState.unreadCount > 9 ? '9+' : '${historyState.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(basesProvider);
              ref.invalidate(charactersProvider);
            },
            tooltip: l10n.refreshTooltip,
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      l10n.allBasesSafeTitle,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.allBasesSafeMessage),
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
                final severityLabel = isCritical ? l10n.severityCritical : l10n.severityWarning;
                final timeText = '${daysRemaining}${l10n.daysAbbr} ${hoursRemaining}${l10n.hoursAbbr} ${minutesRemaining}${l10n.minutesAbbr}';

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
                                    l10n.timeRemainingPower,
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
                                    l10n.expiresLabel,
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
                                      l10n.timeRemainingTaxes,
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
                                            ? '${taxDays}${l10n.daysAbbr} ${taxHours}${l10n.hoursAbbr} ${taxMinutes}${l10n.minutesAbbr}'
                                            : l10n.taxOverdue('${taxDays.abs()}${l10n.daysAbbr} ${taxHours.abs()}${l10n.hoursAbbr} ${taxMinutes.abs()}${l10n.minutesAbbr}');
                                        
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
                                      l10n.dueLabel,
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
                            l10n.tapToManage,
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
          loading: () => Center(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.loading),
            ],
          )),
          error: (error, stack) => Center(child: Text('${l10n.error}: $error')),
        ),
        loading: () => Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.loading),
          ],
        )),
        error: (error, stack) => Center(child: Text('${l10n.error}: $error')),
        ),
      ),
    );
  }

  /// Show notification history in a bottom sheet
  void _showHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.background,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.history),
                  const SizedBox(width: 8),
                  Text(
                    l10n.notificationHistory,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(),
            // History content
            const Expanded(
              child: NotificationHistoryWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
