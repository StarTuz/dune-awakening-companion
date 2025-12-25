import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/notification_manager_provider.dart';
import '../../../core/providers/notification_settings_provider.dart';
import '../providers/import_export_provider.dart';
import '../services/import_service.dart';
import '../../characters/providers/character_provider.dart';
import '../../bases/providers/base_provider.dart';
import '../../../core/providers/language_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App Information Section
          _buildSectionHeader(context, 'About'),
          _buildInfoTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: '1.0.0-beta',
          ),
          _buildInfoTile(
            icon: Icons.storage,
            title: 'Database Version',
            subtitle: 'v4 (Portraits & Notifications)',
          ),
          _buildInfoTile(
            icon: Icons.code,
            title: 'Build',
            subtitle: 'Full Stack: Characters, Bases, Tax, Alerts, Notifications',
          ),
          
          const Divider(height: 32),
          
          // Language Section
          _buildSectionHeader(context, 'Language'),
          _buildLanguageSelector(context, ref),
          
          const Divider(height: 32),

          // Data Management Section
          _buildSectionHeader(context, 'Data Management'),
          ListTile(
            leading: const Icon(Icons.download, color: Colors.blue),
            title: const Text('Export Data'),
            subtitle: const Text('Backup all characters and bases'),
            onTap: () => _handleExport(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.upload, color: Colors.green),
            title: const Text('Import Data'),
            subtitle: const Text('Restore from backup'),
            onTap: () => _handleImport(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all characters and bases'),
            onTap: () => _showClearDataDialog(context),
          ),
          
          const Divider(height: 32),
          
          // Notifications Section
          _buildSectionHeader(context, 'Notifications'),
          _buildNotificationSettings(context, ref),
          
          const Divider(height: 32),
          
          // Legal & Acknowledgments Section
          _buildSectionHeader(context, 'Legal & Acknowledgments'),
          
          // Disclaimer
          Card(
            color: Colors.orange.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Important Disclaimer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This is an unofficial, fan-made companion application for Dune Awakening. '
                    'It is NOT affiliated with, endorsed by, or supported by Funcom or any other official entity. '
                    'Funcom has had no input in the development of this application. '
                    'Use at your own risk.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Copyright Notices
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.copyright, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Copyright Notices',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '© 2024 Dune Awakening Companion App\n\n'
                    'Dune Awakening is a trademark of Funcom. All rights reserved.\n\n'
                    'Dune and related elements are trademarks or registered trademarks '
                    'of Herbert Properties LLC. All rights reserved.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Acknowledgments
          Card(
            color: Colors.blue.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.favorite, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Special Thanks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '🙏 To the Herbert Estate for creating the incredible Dune universe '
                    'that has inspired generations of fans.\n\n'
                    '🎮 To Funcom for developing Dune Awakening and bringing Arrakis to life '
                    'in an immersive gaming experience.\n\n'
                    '🌟 To the Dune Awakening community for their passion and support.\n\n'
                    '🤖 Created within Google Antigravity "Thinking Machine" IDE with human and '
                    'Claude Sonnet 4.5 (who is keeping a watchful eye over you lot—no "Butlerian Jihad" thank you very much).',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // License
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Open Source License'),
            subtitle: const Text('MIT License'),
            onTap: () => _showLicenseDialog(context),
          ),
          
          const SizedBox(height: 32),
          
          // Footer
          Center(
            child: Text(
              'Made with ❤️ for Dune Awakening players',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'v1.0.0-beta • Database v3',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);
    
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      subtitle: Text(_getLanguageName(currentLocale.languageCode)),
      trailing: DropdownButton<String>(
        value: currentLocale.languageCode,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 'en', child: Text('English')),
          DropdownMenuItem(value: 'es', child: Text('Español')),
          DropdownMenuItem(value: 'fr', child: Text('Français')),
          DropdownMenuItem(value: 'de', child: Text('Deutsch')),
          DropdownMenuItem(value: 'uk', child: Text('Українська')),
          DropdownMenuItem(value: 'it', child: Text('Italiano')),
          DropdownMenuItem(value: 'cy', child: Text('Cymraeg')),
        ],
        onChanged: (String? newValue) {
          if (newValue != null) {
            ref.read(languageProvider.notifier).setLanguage(Locale(newValue));
          }
        },
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'es': return 'Español';
      case 'fr': return 'Français';
      case 'de': return 'Deutsch';
      case 'uk': return 'Українська';
      case 'it': return 'Italiano';
      case 'cy': return 'Cymraeg';
      default: return 'English';
    }
  }

  Widget _buildNotificationSettings(BuildContext context, WidgetRef ref) {
    return _NotificationSettingsWidget();
  }

  Future<void> _sendTestNotification(BuildContext context, WidgetRef ref) async {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking for alerts...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final manager = ref.read(notificationManagerProvider);
      await manager.checkNow();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Check complete! Notifications sent if bases need attention.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all characters, bases, and settings. '
          'This action cannot be undone.\n\n'
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Close confirmation dialog
              Navigator.of(context).pop();
              
              // Clear database
              try {
                await AppDatabase.instance.clearAllData();
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All data cleared successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error clearing data: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  void _showLicenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('MIT License'),
        content: const SingleChildScrollView(
          child: Text(
            'Permission is hereby granted, free of charge, to any person obtaining a copy '
            'of this software and associated documentation files (the "Software"), to deal '
            'in the Software without restriction, including without limitation the rights '
            'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell '
            'copies of the Software, and to permit persons to whom the Software is '
            'furnished to do so, subject to the following conditions:\n\n'
            'The above copyright notice and this permission notice shall be included in all '
            'copies or substantial portions of the Software.\n\n'
            'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR '
            'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, '
            'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Exporting data...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );

      // Export data
      final exportService = ref.read(exportServiceProvider);
      final filePath = await exportService.exportData();

      // Hide loading
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (filePath != null) {
        // Success
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported to:\n$filePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        // Failed
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleImport(BuildContext context, WidgetRef ref) async {
    try {
      // Pick file - accept both ZIP (new) and JSON (legacy)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'json'],
        dialogTitle: 'Select Backup File',
      );

      if (result == null || result.files.single.path == null) {
        // User canceled
        return;
      }

      final filePath = result.files.single.path!;

      // Preview import
      final importService = ref.read(importServiceProvider);
      final preview = await importService.previewImport(filePath);

      if (preview == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid backup file'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show import options dialog
      if (!context.mounted) return;
      _showImportOptionsDialog(context, ref, filePath, preview);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImportOptionsDialog(
    BuildContext context,
    WidgetRef ref,
    String filePath,
    Map<String, dynamic> preview,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backup contains:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('• ${preview['characterCount']} characters'),
            Text('• ${preview['baseCount']} bases'),
            if ((preview['portraitCount'] ?? 0) > 0)
              Text('• ${preview['portraitCount']} portraits'),
            const SizedBox(height: 8),
            Text(
              'Format: ${preview['format'] == 'zip' ? 'ZIP (with portraits)' : 'Legacy JSON'}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose import mode:',
              style: TextStyle(fontWeight: FontWeight.bold),
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
              Navigator.of(context).pop();
              _performImport(context, ref, filePath, ImportMode.merge);
            },
            child: const Text('Merge'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showReplaceConfirmation(context, ref, filePath);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Replace'),
          ),
        ],
      ),
    );
  }

  void _showReplaceConfirmation(
    BuildContext context,
    WidgetRef ref,
    String filePath,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace All Data?'),
        content: const Text(
          'This will DELETE all existing characters and bases, '
          'then import the backup data.\n\n'
          'This action cannot be undone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performImport(context, ref, filePath, ImportMode.replace);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Replace Everything'),
          ),
        ],
      ),
    );
  }

  Future<void> _performImport(
    BuildContext context,
    WidgetRef ref,
    String filePath,
    ImportMode mode,
  ) async {
    try {
      // Show loading
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Importing data...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );

      // Import data
      final importService = ref.read(importServiceProvider);
      final result = await importService.importData(filePath, mode);

      // Hide loading
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (result.success) {
        // Success - invalidate providers to refresh UI
        ref.invalidate(charactersProvider);
        ref.invalidate(basesProvider);

        if (!context.mounted) return;
        final portraitMsg = result.portraitsImported > 0 
            ? ', ${result.portraitsImported} portraits' 
            : '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Import successful!\n'
              '${result.charactersImported} characters, '
              '${result.basesImported} bases$portraitMsg imported',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        // Failed
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'Import failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// ConsumerWidget for notification settings using Riverpod for state sync
class _NotificationSettingsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    if (settings.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Enable Notifications Toggle
        SwitchListTile(
          secondary: const Icon(Icons.notifications_active),
          title: const Text('Enable Notifications'),
          subtitle: Text(settings.enabled
              ? 'Receive alerts for expiring bases'
              : 'Notifications disabled'),
          value: settings.enabled,
          onChanged: (value) async {
            // Update provider state (which also updates SharedPreferences)
            await ref.read(notificationSettingsProvider.notifier).setEnabled(value);
            // Update the notification manager
            final manager = ref.read(notificationManagerProvider);
            await manager.updateSettings(enabled: value);
          },
        ),

        // Check Interval Dropdown
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text('Check Interval'),
          subtitle: Text('Check every ${settings.intervalMinutes} minutes'),
          trailing: DropdownButton<int>(
            value: settings.intervalMinutes,
            items: const [
              DropdownMenuItem(value: 15, child: Text('15 min')),
              DropdownMenuItem(value: 30, child: Text('30 min')),
              DropdownMenuItem(value: 60, child: Text('60 min')),
            ],
            onChanged: settings.enabled
                ? (value) async {
                    if (value != null) {
                      await ref.read(notificationSettingsProvider.notifier).setInterval(value);
                      final manager = ref.read(notificationManagerProvider);
                      await manager.updateSettings(intervalMinutes: value);
                    }
                  }
                : null,
          ),
        ),

        // Include Warning Notifications Toggle
        SwitchListTile(
          secondary: const Icon(Icons.warning_amber),
          title: const Text('Warning Notifications'),
          subtitle: Text(settings.includeWarnings
              ? 'Alert for < 48h (warnings + critical)'
              : 'Alert for < 24h only (critical)'),
          value: settings.includeWarnings,
          onChanged: settings.enabled
              ? (value) async {
                  await ref.read(notificationSettingsProvider.notifier).setIncludeWarnings(value);
                  final manager = ref.read(notificationManagerProvider);
                  await manager.updateSettings(includeWarnings: value);
                }
              : null,
        ),

        // Start Minimized (Desktop only)
        if (Platform.isLinux || Platform.isWindows || Platform.isMacOS)
          SwitchListTile(
            secondary: const Icon(Icons.minimize),
            title: const Text('Start Minimized to Tray'),
            subtitle: const Text('Launch app in system tray'),
            value: settings.startMinimized,
            onChanged: (value) async {
              await ref.read(notificationSettingsProvider.notifier).setStartMinimized(value);
            },
          ),

        // Test Notification Button
        ListTile(
          leading: const Icon(Icons.notifications, color: Colors.blue),
          title: const Text('Test Notification'),
          subtitle: const Text('Send a test notification'),
          trailing: ElevatedButton.icon(
            onPressed: settings.enabled
                ? () => _sendTestNotification(context, ref)
                : null,
            icon: const Icon(Icons.send, size: 18),
            label: const Text('Test'),
          ),
        ),
      ],
    );
  }

  Future<void> _sendTestNotification(BuildContext context, WidgetRef ref) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking for alerts...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final manager = ref.read(notificationManagerProvider);
      await manager.checkNow();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Check complete! Notifications sent if bases need attention.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Test notification error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
