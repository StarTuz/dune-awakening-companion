import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../characters/services/character_repository.dart';
import '../../bases/services/base_repository.dart';

class ExportService {
  final CharacterRepository _characterRepository;
  final BaseRepository _baseRepository;

  ExportService(this._characterRepository, this._baseRepository);

  /// Export all data to JSON file
  /// Returns the file path if successful, null otherwise
  Future<String?> exportData() async {
    try {
      // Get all data
      final characters = await _characterRepository.getAll();
      final bases = await _baseRepository.getAll();

      // Create export data structure
      final exportData = {
        'version': '1.0.0',
        'exportDate': DateTime.now().toIso8601String(),
        'databaseVersion': 3,
        'characters': characters.map((c) => c.toJson()).toList(),
        'bases': bases.map((b) => b.toJson()).toList(),
      };

      // Convert to JSON string
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      // Create filename with timestamp
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filename = 'dune_companion_backup_$timestamp.json';

      // Let user pick save location
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputPath == null) {
        // User canceled
        return null;
      }

      // Ensure .json extension
      if (!outputPath.endsWith('.json')) {
        outputPath = '$outputPath.json';
      }

      // Write file
      final file = File(outputPath);
      await file.writeAsString(jsonString);

      return outputPath;
    } catch (e) {
      print('Error exporting data: $e');
      return null;
    }
  }

  /// Get export statistics
  Future<Map<String, int>> getExportStats() async {
    final characters = await _characterRepository.getAll();
    final bases = await _baseRepository.getAll();

    return {
      'characters': characters.length,
      'bases': bases.length,
    };
  }
}
