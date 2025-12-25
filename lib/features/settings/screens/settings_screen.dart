import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/notification_manager_provider.dart';
import '../../../core/providers/notification_settings_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/accessibility_provider.dart';
import '../providers/import_export_provider.dart';
import '../services/import_service.dart';
import '../../characters/providers/character_provider.dart';
import '../../bases/providers/base_provider.dart';
import '../../../core/providers/language_provider.dart';
import '../../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App Information Section
          _buildSectionHeader(context, l10n.sectionAbout),
          _buildInfoTile(
            icon: Icons.info_outline,
            title: l10n.version,
            subtitle: '1.0.5',
          ),
          _buildInfoTile(
            icon: Icons.storage,
            title: l10n.databaseVersion,
            subtitle: 'v5',
          ),
          _buildInfoTile(
            icon: Icons.code,
            title: l10n.build,
            subtitle: 'Flutter 3.38.x | Dart 3.8.x',
          ),
          _buildInfoTile(
            icon: Icons.build,
            title: l10n.features,
            subtitle: 'Characters, Bases, Tax, Alerts, i18n, Export/Import',
          ),
          
          const Divider(height: 32),
          
          // Appearance Section
          _buildSectionHeader(context, l10n.sectionAppearance),
          _buildThemeToggle(context, ref),
          _buildFactionSelector(context, ref),
          
          const Divider(height: 32),
          
          // Language Section
          _buildSectionHeader(context, l10n.sectionLanguage),
          _buildLanguageSelector(context, ref),
          
          const Divider(height: 32),

          // Data Management Section
          _buildSectionHeader(context, l10n.sectionDataManagement),
          ListTile(
            leading: const Icon(Icons.download, color: Colors.blue),
            title: Text(l10n.exportData),
            subtitle: Text(l10n.exportDataDesc),
            onTap: () => _handleExport(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.upload, color: Colors.green),
            title: Text(l10n.importData),
            subtitle: Text(l10n.importDataDesc),
            onTap: () => _handleImport(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: Text(l10n.clearAllData),
            subtitle: Text(l10n.clearAllDataDesc),
            onTap: () => _showClearDataDialog(context),
          ),
          
          const Divider(height: 32),
          
          // Accessibility Section
          _buildSectionHeader(context, l10n.sectionAccessibility),
          _buildAccessibilitySettings(context, ref),
          
          const Divider(height: 32),
          
          // Notifications Section
          _buildSectionHeader(context, l10n.sectionNotifications),
          _buildNotificationSettings(context, ref),
          
          const Divider(height: 32),
          
          // Legal & Acknowledgments Section
          _buildSectionHeader(context, l10n.sectionLegal),
          
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
                        l10n.importantDisclaimer,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.disclaimerText,
                    style: const TextStyle(fontSize: 13),
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
                    children: [
                      const Icon(Icons.copyright, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.copyrightNotices,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${l10n.copyrightApp}\n\n'
                    '${l10n.copyrightFuncom}\n\n'
                    '${l10n.copyrightHerbert}',
                    style: const TextStyle(fontSize: 13),
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
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.specialThanks,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '🙏 ${l10n.thanksHerbert}\n\n'
                    '🎮 ${l10n.thanksFuncom}\n\n'
                    '🌟 ${l10n.thanksCommunity}\n\n'
                    '🤖 ${l10n.thanksAI}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // License
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.openSourceLicense),
            subtitle: Text(l10n.mitLicense),
            onTap: () => _showLicenseDialog(context),
          ),
          
          const SizedBox(height: 32),
          
          // Footer
          Center(
            child: Text(
              l10n.madeWithLove,
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
              'v1.0.4 • ${l10n.databaseVersion} v5',
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
  Widget _buildThemeToggle(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    
    return SwitchListTile(
      secondary: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: isDarkMode ? Colors.indigo : Colors.orange,
      ),
      title: Text(l10n.darkMode),
      subtitle: Text(isDarkMode ? l10n.desertNightTheme : l10n.desertDayTheme),
      value: isDarkMode,
      onChanged: (value) {
        ref.read(themeModeProvider.notifier).setThemeMode(
          value ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }

  Widget _buildFactionSelector(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentFaction = ref.watch(factionThemeProvider);
    
    return ListTile(
      leading: Icon(
        _getFactionIcon(currentFaction),
        color: _getFactionColor(currentFaction),
      ),
      title: Text(l10n.factionTheme),
      subtitle: Text(_getLocalizedFactionName(context, currentFaction)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showFactionPicker(context, ref),
    );
  }

  String _getLocalizedFactionName(BuildContext context, DuneFaction faction) {
    final l10n = AppLocalizations.of(context)!;
    switch (faction) {
      case DuneFaction.desert:
        return l10n.factionDesert;
      case DuneFaction.atreides:
        return l10n.factionAtreides;
      case DuneFaction.harkonnen:
        return l10n.factionHarkonnen;
      case DuneFaction.fremen:
        return l10n.factionFremen;
      case DuneFaction.smuggler:
        return l10n.factionSmuggler;
    }
  }

  String _getLocalizedFactionDesc(BuildContext context, DuneFaction faction) {
    final l10n = AppLocalizations.of(context)!;
    switch (faction) {
      case DuneFaction.desert:
        return l10n.factionDesertDesc;
      case DuneFaction.atreides:
        return l10n.factionAtreidesDesc;
      case DuneFaction.harkonnen:
        return l10n.factionHarkonnenDesc;
      case DuneFaction.fremen:
        return l10n.factionFremenDesc;
      case DuneFaction.smuggler:
        return l10n.factionSmugglerDesc;
    }
  }

  IconData _getFactionIcon(DuneFaction faction) {
    switch (faction) {
      case DuneFaction.desert:
        return Icons.landscape;
      case DuneFaction.atreides:
        return Icons.shield; // Noble house
      case DuneFaction.harkonnen:
        return Icons.local_fire_department; // Brutal
      case DuneFaction.fremen:
        return Icons.remove_red_eye; // Blue eyes
      case DuneFaction.smuggler:
        return Icons.nights_stay; // Shadow
    }
  }

  Color _getFactionColor(DuneFaction faction) {
    switch (faction) {
      case DuneFaction.desert:
        return const Color(0xFFD4A574); // Spice gold
      case DuneFaction.atreides:
        return const Color(0xFF4A8C5A); // Green
      case DuneFaction.harkonnen:
        return const Color(0xFFC94A3A); // Red
      case DuneFaction.fremen:
        return const Color(0xFF4A7AC9); // Blue
      case DuneFaction.smuggler:
        return const Color(0xFF8A6AC9); // Purple
    }
  }

  void _showFactionPicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.chooseFaction,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            ...DuneFaction.values.map((faction) => ListTile(
              leading: Icon(
                _getFactionIcon(faction),
                color: _getFactionColor(faction),
              ),
              title: Text(_getLocalizedFactionName(context, faction)),
              subtitle: Text(_getLocalizedFactionDesc(context, faction)),
              trailing: ref.watch(factionThemeProvider) == faction
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                ref.read(factionThemeProvider.notifier).setFaction(faction);
                Navigator.of(context).pop();
              },
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilitySettings(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Font Size Slider
        ListTile(
          leading: const Icon(Icons.text_fields),
          title: Text(l10n.textSize),
          subtitle: Text(_getLocalizedFontSize(context, settings.fontSize)),
          trailing: SizedBox(
            width: 200,
            child: Slider(
              value: settings.fontSize.index.toDouble(),
              min: 0,
              max: (FontSizeOption.values.length - 1).toDouble(),
              divisions: FontSizeOption.values.length - 1,
              label: _getLocalizedFontSize(context, settings.fontSize),
              onChanged: (value) {
                ref.read(accessibilityProvider.notifier).setFontSize(
                  FontSizeOption.values[value.round()],
                );
              },
            ),
          ),
        ),
        
        // Font Weight Selector
        Column(
          children: [
            ListTile(
              leading: const Icon(Icons.format_bold),
              title: Text(l10n.textWeight),
              subtitle: Text(_getLocalizedFontWeight(context, settings.fontWeight)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<FontWeightOption>(
                  segments: [
                    ButtonSegment(
                      value: FontWeightOption.light,
                      label: Text(l10n.textWeightLight),
                    ),
                    ButtonSegment(
                      value: FontWeightOption.regular,
                      label: Text(l10n.textWeightRegular),
                    ),
                    ButtonSegment(
                      value: FontWeightOption.bold,
                      label: Text(l10n.textWeightBold),
                    ),
                  ],
                  selected: {settings.fontWeight},
                  onSelectionChanged: (Set<FontWeightOption> selection) {
                    ref.read(accessibilityProvider.notifier).setFontWeight(
                          selection.first,
                        );
                  },
                ),
              ),
            ),
          ],
        ),
        
        // High Contrast Toggle
        SwitchListTile(
          secondary: const Icon(Icons.contrast),
          title: Text(l10n.highContrast),
          subtitle: Text(settings.highContrast 
              ? l10n.highContrastEnabled 
              : l10n.highContrastDisabled),
          value: settings.highContrast,
          onChanged: (value) {
            ref.read(accessibilityProvider.notifier).setHighContrast(value);
          },
        ),
        
        // Reduced Motion Toggle
        SwitchListTile(
          secondary: const Icon(Icons.animation),
          title: Text(l10n.reduceMotion),
          subtitle: Text(settings.reducedMotion 
              ? l10n.reduceMotionEnabled 
              : l10n.reduceMotionDisabled),
          value: settings.reducedMotion,
          onChanged: (value) {
            ref.read(accessibilityProvider.notifier).setReducedMotion(value);
          },
        ),
      ],
    );
  }

  String _getLocalizedFontSize(BuildContext context, FontSizeOption option) {
    final l10n = AppLocalizations.of(context)!;
    switch (option) {
      case FontSizeOption.small:
        return l10n.textSizeSmall;
      case FontSizeOption.medium:
        return l10n.textSizeMedium;
      case FontSizeOption.large:
        return l10n.textSizeLarge;
      case FontSizeOption.xl:
        return l10n.textSizeXL;
    }
  }

  String _getLocalizedFontWeight(BuildContext context, FontWeightOption option) {
    final l10n = AppLocalizations.of(context)!;
    switch (option) {
      case FontWeightOption.light:
        return l10n.textWeightLight;
      case FontWeightOption.regular:
        return l10n.textWeightRegular;
      case FontWeightOption.bold:
        return l10n.textWeightBold;
    }
  }

  Widget _buildNotificationSettings(BuildContext context, WidgetRef ref) {
    return _NotificationSettingsWidget();
  }

  Future<void> _sendTestNotification(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.checkingAlerts),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final manager = ref.read(notificationManagerProvider);
      await manager.checkNow();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.checkComplete),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showClearDataDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAllData),
        content: Text(l10n.clearDataConfirmDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
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
                    SnackBar(
                      content: Text(l10n.dataCleared),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.errorClearingData(e.toString())),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.deleteEverything),
          ),
        ],
      ),
    );
  }

  void _showLicenseDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.mitLicense),
        content: SingleChildScrollView(
          child: Text(
            l10n.mitLicenseBody,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Show loading
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 16),
              Text(l10n.exportingData),
            ],
          ),
          duration: const Duration(seconds: 30),
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
            content: Text(l10n.dataExportedTo(filePath)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: l10n.ok,
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        // Failed
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportFailedTryAgain),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.error}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleImport(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Pick file - accept both ZIP (new) and JSON (legacy)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'json'],
        dialogTitle: l10n.importData,
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
          SnackBar(
            content: Text(l10n.importFailed),
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
          content: Text('${l10n.error}: $e'),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importBackup),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.backupContains,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('• ${l10n.charactersCount(preview['characterCount'] ?? 0)}'),
            Text('• ${l10n.basesCount(preview['baseCount'] ?? 0)}'),
            if ((preview['portraitCount'] ?? 0) > 0)
              Text('• ${l10n.portraitsCount(preview['portraitCount'] ?? 0)}'),
            const SizedBox(height: 8),
            Text(
              '${l10n.features}: ${preview['format'] == 'zip' ? l10n.formatZip : l10n.formatLegacyJson}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.chooseImportMode,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performImport(context, ref, filePath, ImportMode.merge);
            },
            child: Text(l10n.importMerge),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showReplaceConfirmation(context, ref, filePath);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: Text(l10n.importReplace),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.replaceAllDataTitle),
        content: Text(l10n.replaceAllDataContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performImport(context, ref, filePath, ImportMode.replace);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.replaceEverything),
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
    final l10n = AppLocalizations.of(context)!;
    try {
      // Show loading
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 16),
              Text(l10n.importingData),
            ],
          ),
          duration: const Duration(seconds: 30),
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
            ? l10n.portraitsCount(result.portraitsImported)
            : '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.importSuccessful}\n' +
              l10n.importSummary(
                result.charactersImported, 
                result.basesImported, 
                portraitMsg.isNotEmpty ? ', $portraitMsg' : ''
              ),
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
    final l10n = AppLocalizations.of(context)!;

    if (settings.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Enable Notifications Toggle
        SwitchListTile(
          secondary: const Icon(Icons.notifications_active),
          title: Text(l10n.enableNotifications),
          subtitle: Text(settings.enabled
              ? l10n.receiveAlertsForExpiring
              : l10n.notificationsDisabledDesc),
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
          title: Text(l10n.checkInterval),
          subtitle: Text(l10n.checkEveryMinutes(settings.intervalMinutes)),
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
          title: Text(l10n.warningNotifications),
          subtitle: Text(settings.includeWarnings
              ? l10n.alertFor48h
              : l10n.alertFor24hOnly),
          value: settings.includeWarnings,
          onChanged: settings.enabled
              ? (value) async {
                  await ref.read(notificationSettingsProvider.notifier).setIncludeWarnings(value);
                  final manager = ref.read(notificationManagerProvider);
                  await manager.updateSettings(includeWarnings: value);
                }
              : null,
        ),

        // Sound Toggle
        SwitchListTile(
          secondary: const Icon(Icons.volume_up),
          title: Text(l10n.notificationSound),
          subtitle: Text(settings.soundEnabled
              ? l10n.playSoundWithNotifications
              : l10n.silentNotifications),
          value: settings.soundEnabled,
          onChanged: settings.enabled
              ? (value) async {
                  await ref.read(notificationSettingsProvider.notifier).setSoundEnabled(value);
                }
              : null,
        ),

        // Vibration Toggle (Mobile only)
        if (Platform.isAndroid || Platform.isIOS)
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: Text(l10n.vibration),
            subtitle: Text(settings.vibrationEnabled
                ? l10n.vibrateWithNotifications
                : l10n.noVibration),
            value: settings.vibrationEnabled,
            onChanged: settings.enabled
                ? (value) async {
                    await ref.read(notificationSettingsProvider.notifier).setVibrationEnabled(value);
                  }
                : null,
          ),

        // Start Minimized (Desktop only)
        if (Platform.isLinux || Platform.isWindows || Platform.isMacOS)
          SwitchListTile(
            secondary: const Icon(Icons.minimize),
            title: Text(l10n.startMinimizedToTray),
            subtitle: Text(l10n.launchAppInTray),
            value: settings.startMinimized,
            onChanged: (value) async {
              await ref.read(notificationSettingsProvider.notifier).setStartMinimized(value);
            },
          ),

        const Divider(),

        // Quiet Hours Section
        SwitchListTile(
          secondary: const Icon(Icons.bedtime),
          title: Text(l10n.quietHours),
          subtitle: Text(settings.quietHoursEnabled
              ? l10n.noNotificationsFromTo(settings.quietHoursStartString, settings.quietHoursEndString)
              : l10n.notificationsAlwaysEnabled),
          value: settings.quietHoursEnabled,
          onChanged: settings.enabled
              ? (value) async {
                  await ref.read(notificationSettingsProvider.notifier).setQuietHoursEnabled(value);
                }
              : null,
        ),

        // Quiet Hours Time Pickers (only show when quiet hours enabled)
        if (settings.quietHoursEnabled && settings.enabled) ...[
          ListTile(
            leading: const SizedBox(width: 24), // Align with icons above
            title: Text(l10n.startTime),
            trailing: TextButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: settings.quietHoursStart ~/ 60,
                    minute: settings.quietHoursStart % 60,
                  ),
                );
                if (picked != null) {
                  final minutes = picked.hour * 60 + picked.minute;
                  await ref.read(notificationSettingsProvider.notifier).setQuietHoursStart(minutes);
                }
              },
              child: Text(
                settings.quietHoursStartString,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const SizedBox(width: 24),
            title: Text(l10n.endTime),
            trailing: TextButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: settings.quietHoursEnd ~/ 60,
                    minute: settings.quietHoursEnd % 60,
                  ),
                );
                if (picked != null) {
                  final minutes = picked.hour * 60 + picked.minute;
                  await ref.read(notificationSettingsProvider.notifier).setQuietHoursEnd(minutes);
                }
              },
              child: Text(
                settings.quietHoursEndString,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],

        const Divider(),

        // Test Notification Button
        ListTile(
          leading: const Icon(Icons.notifications, color: Colors.blue),
          title: Text(l10n.testNotification),
          subtitle: Text(l10n.sendTestNotification),
          trailing: ElevatedButton.icon(
            onPressed: settings.enabled
                ? () => _sendTestNotification(context, ref)
                : null,
            icon: const Icon(Icons.send, size: 18),
            label: Text(l10n.test),
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
