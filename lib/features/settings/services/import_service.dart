import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../characters/models/character.dart';
import '../../bases/models/base.dart';
import '../../characters/services/character_repository.dart';
import '../../bases/services/base_repository.dart';

enum ImportMode {
  merge,  // Add to existing data
  replace // Clear existing data first
}

class ImportResult {
  final bool success;
  final String? error;
  final int charactersImported;
  final int basesImported;
  final int portraitsImported;

  ImportResult({
    required this.success,
    this.error,
    required this.charactersImported,
    required this.basesImported,
    this.portraitsImported = 0,
  });
}

class ImportService {
  final CharacterRepository _characterRepository;
  final BaseRepository _baseRepository;

  ImportService(this._characterRepository, this._baseRepository);

  /// Import data from ZIP or JSON file
  Future<ImportResult> importData(
    String filePath,
    ImportMode mode,
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ImportResult(
          success: false,
          error: 'File not found',
          charactersImported: 0,
          basesImported: 0,
        );
      }

      // Detect file type by extension
      if (filePath.toLowerCase().endsWith('.zip')) {
        return await _importFromZip(file, mode);
      } else {
        return await _importFromJson(file, mode);
      }
    } catch (e) {
      return ImportResult(
        success: false,
        error: 'Import failed: $e',
        charactersImported: 0,
        basesImported: 0,
      );
    }
  }

  /// Import from ZIP archive (new format with portraits)
  Future<ImportResult> _importFromZip(File zipFile, ImportMode mode) async {
    try {
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      
      // Find data.json in archive
      final dataFile = archive.findFile('data.json');
      if (dataFile == null) {
        return ImportResult(
          success: false,
          error: 'Invalid backup: missing data.json',
          charactersImported: 0,
          basesImported: 0,
        );
      }
      
      // Parse JSON data
      final jsonString = utf8.decode(dataFile.content as List<int>);
      final Map<String, dynamic> data = json.decode(jsonString);
      
      // Validate structure
      final validation = _validateImportData(data);
      if (!validation.success) {
        return validation;
      }
      
      // Get portraits directory
      final appDir = await getApplicationDocumentsDirectory();
      final portraitsDir = Directory(path.join(appDir.path, 'portraits'));
      if (!await portraitsDir.exists()) {
        await portraitsDir.create(recursive: true);
      }
      
      // Extract portrait files and build mapping
      final portraitMappings = <String, String>{};
      int portraitsImported = 0;
      
      for (final file in archive) {
        if (file.name.startsWith('portraits/') && file.isFile) {
          // Extract portrait
          final filename = path.basename(file.name);
          final newPath = path.join(portraitsDir.path, filename);
          
          final outFile = File(newPath);
          await outFile.writeAsBytes(file.content as List<int>);
          
          // Map archive path to new absolute path
          portraitMappings[file.name] = newPath;
          portraitsImported++;
        }
      }
      
      // Handle import mode
      if (mode == ImportMode.replace) {
        await _clearAllData();
      }
      
      // Parse and import characters with updated portrait paths
      final charactersJson = data['characters'] as List<dynamic>;
      int charactersImported = 0;
      
      for (final charJson in charactersJson) {
        try {
          final charMap = charJson as Map<String, dynamic>;
          
          // Update portrait path if it was in the archive
          if (charMap['portraitPath'] != null) {
            final archivePath = charMap['portraitPath'] as String;
            if (portraitMappings.containsKey(archivePath)) {
              charMap['portraitPath'] = portraitMappings[archivePath];
            } else {
              // Portrait not found in archive, clear the path
              charMap['portraitPath'] = null;
            }
          }
          
          final character = Character.fromJson(charMap);
          await _characterRepository.create(character);
          charactersImported++;
        } catch (e) {
          print('Error importing character: $e');
        }
      }
      
      // Import bases
      final basesJson = data['bases'] as List<dynamic>;
      int basesImported = 0;
      
      for (final baseJson in basesJson) {
        try {
          final base = Base.fromJson(baseJson as Map<String, dynamic>);
          await _baseRepository.create(base);
          basesImported++;
        } catch (e) {
          print('Error importing base: $e');
        }
      }
      
      return ImportResult(
        success: true,
        charactersImported: charactersImported,
        basesImported: basesImported,
        portraitsImported: portraitsImported,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        error: 'Failed to extract ZIP: $e',
        charactersImported: 0,
        basesImported: 0,
      );
    }
  }

  /// Import from legacy JSON file (no portraits)
  Future<ImportResult> _importFromJson(File jsonFile, ImportMode mode) async {
    try {
      final jsonString = await jsonFile.readAsString();
      final Map<String, dynamic> data = json.decode(jsonString);

      // Validate structure
      final validation = _validateImportData(data);
      if (!validation.success) {
        return validation;
      }

      // Extract data
      final charactersJson = data['characters'] as List<dynamic>;
      final basesJson = data['bases'] as List<dynamic>;

      // Parse characters (clear portrait paths since they won't be valid)
      final characters = charactersJson.map((json) {
        final charMap = json as Map<String, dynamic>;
        charMap['portraitPath'] = null; // Clear invalid paths
        return Character.fromJson(charMap);
      }).toList();
      
      final bases = basesJson
          .map((json) => Base.fromJson(json as Map<String, dynamic>))
          .toList();

      // Handle import mode
      if (mode == ImportMode.replace) {
        await _clearAllData();
      }

      // Import characters
      int charactersImported = 0;
      for (final character in characters) {
        try {
          await _characterRepository.create(character);
          charactersImported++;
        } catch (e) {
          print('Error importing character ${character.name}: $e');
        }
      }

      // Import bases
      int basesImported = 0;
      for (final base in bases) {
        try {
          await _baseRepository.create(base);
          basesImported++;
        } catch (e) {
          print('Error importing base ${base.name}: $e');
        }
      }

      return ImportResult(
        success: true,
        charactersImported: charactersImported,
        basesImported: basesImported,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        error: 'Import failed: $e',
        charactersImported: 0,
        basesImported: 0,
      );
    }
  }

  /// Validate import data structure
  ImportResult _validateImportData(Map<String, dynamic> data) {
    // Check required fields
    if (!data.containsKey('version')) {
      return ImportResult(
        success: false,
        error: 'Invalid file: missing version',
        charactersImported: 0,
        basesImported: 0,
      );
    }

    if (!data.containsKey('characters') || !data.containsKey('bases')) {
      return ImportResult(
        success: false,
        error: 'Invalid file: missing data',
        charactersImported: 0,
        basesImported: 0,
      );
    }

    // Check data types
    if (data['characters'] is! List || data['bases'] is! List) {
      return ImportResult(
        success: false,
        error: 'Invalid file: corrupted data',
        charactersImported: 0,
        basesImported: 0,
      );
    }

    return ImportResult(
      success: true,
      charactersImported: 0,
      basesImported: 0,
    );
  }

  /// Clear all existing data
  Future<void> _clearAllData() async {
    final existingCharacters = await _characterRepository.getAll();
    for (final character in existingCharacters) {
      await _characterRepository.delete(character.id);
    }

    final existingBases = await _baseRepository.getAll();
    for (final base in existingBases) {
      await _baseRepository.delete(base.id);
    }
  }

  /// Preview import file without importing
  Future<Map<String, dynamic>?> previewImport(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      Map<String, dynamic> data;
      int? portraitCount;

      if (filePath.toLowerCase().endsWith('.zip')) {
        // Handle ZIP preview
        final bytes = await file.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);
        
        final dataFile = archive.findFile('data.json');
        if (dataFile == null) return null;
        
        final jsonString = utf8.decode(dataFile.content as List<int>);
        data = json.decode(jsonString);
        
        // Count portraits in archive
        portraitCount = archive.files
            .where((f) => f.name.startsWith('portraits/') && f.isFile)
            .length;
      } else {
        // Handle JSON preview
        final jsonString = await file.readAsString();
        data = json.decode(jsonString);
      }

      final charactersJson = data['characters'] as List<dynamic>? ?? [];
      final basesJson = data['bases'] as List<dynamic>? ?? [];

      return {
        'version': data['version'],
        'exportDate': data['exportDate'],
        'format': data['format'] ?? 'json',
        'characterCount': charactersJson.length,
        'baseCount': basesJson.length,
        'portraitCount': portraitCount ?? 0,
      };
    } catch (e) {
      print('Error previewing import: $e');
      return null;
    }
  }
}
