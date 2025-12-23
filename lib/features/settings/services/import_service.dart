import 'dart:convert';
import 'dart:io';
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

  ImportResult({
    required this.success,
    this.error,
    required this.charactersImported,
    required this.basesImported,
  });
}

class ImportService {
  final CharacterRepository _characterRepository;
  final BaseRepository _baseRepository;

  ImportService(this._characterRepository, this._baseRepository);

  /// Import data from JSON file
  Future<ImportResult> importData(
    String filePath,
    ImportMode mode,
  ) async {
    try {
      // Read file
      final file = File(filePath);
      if (!await file.exists()) {
        return ImportResult(
          success: false,
          error: 'File not found',
          charactersImported: 0,
          basesImported: 0,
        );
      }

      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = json.decode(jsonString);

      // Validate structure
      final validation = _validateImportData(data);
      if (!validation.success) {
        return validation;
      }

      // Extract data
      final charactersJson = data['characters'] as List<dynamic>;
      final basesJson = data['bases'] as List<dynamic>;

      // Parse characters and bases
      final characters = charactersJson
          .map((json) => Character.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final bases = basesJson
          .map((json) => Base.fromJson(json as Map<String, dynamic>))
          .toList();

      // Handle import mode
      if (mode == ImportMode.replace) {
        // Clear existing data
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
          // Continue with next character
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
          // Continue with next base
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

      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = json.decode(jsonString);

      final charactersJson = data['characters'] as List<dynamic>? ?? [];
      final basesJson = data['bases'] as List<dynamic>? ?? [];

      return {
        'version': data['version'],
        'exportDate': data['exportDate'],
        'characterCount': charactersJson.length,
        'baseCount': basesJson.length,
      };
    } catch (e) {
      print('Error previewing import: $e');
      return null;
    }
  }
}
