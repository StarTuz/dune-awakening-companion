import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_history_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../core/models/notification_history_entry.dart';

/// Widget displaying notification history
class NotificationHistoryWidget extends ConsumerWidget {
  const NotificationHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(notificationHistoryProvider);

    if (historyState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (historyState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading history: ${historyState.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(notificationHistoryProvider.notifier).loadHistory(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (historyState.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No notification history',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Notifications will appear here when sent',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header with actions
        if (historyState.unreadCount > 0 || historyState.entries.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (historyState.unreadCount > 0)
                  Text(
                    '${historyState.unreadCount} unread',
                    style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  const Text('All read'),
                Row(
                  children: [
                    if (historyState.unreadCount > 0)
                      TextButton.icon(
                        onPressed: () => ref.read(notificationHistoryProvider.notifier).markAllAsRead(),
                        icon: const Icon(Icons.done_all, size: 18),
                        label: const Text('Mark all read'),
                      ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) async {
                        if (value == 'clear') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Clear History'),
                              content: const Text('Delete all notification history?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Clear', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            ref.read(notificationHistoryProvider.notifier).clearHistory();
                          }
                        } else if (value == 'delete_old') {
                          ref.read(notificationHistoryProvider.notifier).deleteOlderThan(7);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Deleted notifications older than 7 days')),
                            );
                          }
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: 'delete_old',
                          child: Text('Delete older than 7 days'),
                        ),
                        const PopupMenuItem(
                          value: 'clear',
                          child: Text('Clear all history', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        
        // History list
        Expanded(
          child: ListView.builder(
            itemCount: historyState.entries.length,
            itemBuilder: (context, index) {
              final entry = historyState.entries[index];
              return _NotificationHistoryTile(
                entry: entry,
                onTap: () {
                  if (!entry.read && entry.id != null) {
                    ref.read(notificationHistoryProvider.notifier).markAsRead(entry.id!);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NotificationHistoryTile extends StatelessWidget {
  final NotificationHistoryEntry entry;
  final VoidCallback? onTap;

  const _NotificationHistoryTile({
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = entry.severity == 'critical';
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: entry.read 
          ? AppColors.cardBackground 
          : AppColors.cardBackground.withOpacity(0.9),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCritical 
                      ? AppColors.criticalStatus.withOpacity(0.2)
                      : AppColors.warningYellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    entry.iconEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.title,
                            style: TextStyle(
                              fontWeight: entry.read ? FontWeight.normal : FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!entry.read)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.body,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
