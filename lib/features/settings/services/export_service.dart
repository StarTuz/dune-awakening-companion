import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import '../../characters/services/character_repository.dart';
import '../../bases/services/base_repository.dart';

class ExportService {
  final CharacterRepository _characterRepository;
  final BaseRepository _baseRepository;

  ExportService(this._characterRepository, this._baseRepository);

  /// Export all data to ZIP file (includes portraits)
  /// Returns the file path if successful, null otherwise
  Future<String?> exportData() async {
    try {
      // Get all data
      final characters = await _characterRepository.getAll();
      final bases = await _baseRepository.getAll();

      // Create archive
      final archive = Archive();
      
      // Track portrait mappings (old path -> archive filename)
      final portraitMappings = <String, String>{};
      
      // Add portrait files to archive
      for (final character in characters) {
        if (character.portraitPath != null) {
          final portraitFile = File(character.portraitPath!);
          if (await portraitFile.exists()) {
            final bytes = await portraitFile.readAsBytes();
            final filename = 'portraits/${character.id}${path.extension(character.portraitPath!)}';
            archive.addFile(ArchiveFile(filename, bytes.length, bytes));
            portraitMappings[character.portraitPath!] = filename;
          }
        }
      }
      
      // Create export data with relative portrait paths
      final exportCharacters = characters.map((c) {
        final json = c.toJson();
        if (c.portraitPath != null && portraitMappings.containsKey(c.portraitPath)) {
          json['portraitPath'] = portraitMappings[c.portraitPath];
        }
        return json;
      }).toList();

      // Create JSON data
      final exportData = {
        'version': '1.1.0',  // Bumped version for ZIP format
        'exportDate': DateTime.now().toIso8601String(),
        'databaseVersion': 4,
        'format': 'zip',  // New field to indicate format
        'characters': exportCharacters,
        'bases': bases.map((b) => b.toJson()).toList(),
      };

      // Add JSON to archive
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      final jsonBytes = utf8.encode(jsonString);
      archive.addFile(ArchiveFile('data.json', jsonBytes.length, jsonBytes));

      // Encode archive
      final zipData = ZipEncoder().encode(archive);
      if (zipData == null) {
        throw Exception('Failed to encode ZIP archive');
      }

      // Create filename with timestamp
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filename = 'dune_companion_backup_$timestamp.zip';

      // Let user pick save location
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (outputPath == null) {
        // User canceled
        return null;
      }

      // Ensure .zip extension
      if (!outputPath.endsWith('.zip')) {
        outputPath = '$outputPath.zip';
      }

      // Write file
      final file = File(outputPath);
      await file.writeAsBytes(zipData);

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
    
    // Count portraits
    int portraitCount = 0;
    for (final character in characters) {
      if (character.portraitPath != null) {
        final file = File(character.portraitPath!);
        if (await file.exists()) {
          portraitCount++;
        }
      }
    }

    return {
      'characters': characters.length,
      'bases': bases.length,
      'portraits': portraitCount,
    };
  }
}
