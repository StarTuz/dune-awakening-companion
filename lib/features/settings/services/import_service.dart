import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../augmentations/models/augmentation.dart';
import '../../augmentations/services/augmentation_repository.dart';
import '../../blueprints/models/blueprint.dart';
import '../../blueprints/services/blueprint_repository.dart';
import '../../class_quests/models/class_quest_progress.dart';
import '../../class_quests/services/class_quest_repository.dart';
import '../../characters/models/character.dart';
import '../../bases/models/base.dart';
import '../../characters/services/character_repository.dart';
import '../../bases/services/base_repository.dart';
import '../../factions/models/faction_progress.dart';
import '../../factions/services/faction_progress_repository.dart';
import '../../journal/models/journal_entry.dart';
import '../../base_calculator/models/base_calculator_plan.dart';
import '../../base_calculator/services/base_calculator_plan_repository.dart';
import '../../journal/services/journal_repository.dart';
import '../../quest_journal/models/quest.dart';
import '../../quest_journal/models/quest_step.dart';
import '../../quest_journal/services/quest_repository.dart';
import '../../skills/models/character_skill.dart';
import '../../skills/services/character_skill_repository.dart';
import '../../specializations/models/character_specialization.dart';
import '../../specializations/services/character_specialization_repository.dart';

enum ImportMode {
  merge, // Add to existing data
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
  final CharacterSpecializationRepository? _specializationRepository;
  final FactionProgressRepository? _factionRepository;
  final AugmentationRepository? _augmentationRepository;
  final QuestRepository? _questRepository;
  final BlueprintRepository? _blueprintRepository;
  final ClassQuestRepository? _classQuestRepository;
  final CharacterSkillRepository? _characterSkillRepository;
  final JournalRepository? _journalRepository;
  final BaseCalculatorPlanRepository? _baseCalculatorPlanRepository;

  ImportService(
    this._characterRepository,
    this._baseRepository, {
    CharacterSpecializationRepository? specializationRepository,
    FactionProgressRepository? factionRepository,
    AugmentationRepository? augmentationRepository,
    QuestRepository? questRepository,
    BlueprintRepository? blueprintRepository,
    ClassQuestRepository? classQuestRepository,
    CharacterSkillRepository? characterSkillRepository,
    JournalRepository? journalRepository,
    BaseCalculatorPlanRepository? baseCalculatorPlanRepository,
  })  : _specializationRepository = specializationRepository,
        _factionRepository = factionRepository,
        _augmentationRepository = augmentationRepository,
        _questRepository = questRepository,
        _blueprintRepository = blueprintRepository,
        _classQuestRepository = classQuestRepository,
        _characterSkillRepository = characterSkillRepository,
        _journalRepository = journalRepository,
        _baseCalculatorPlanRepository = baseCalculatorPlanRepository;

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

      // Get journal images directory
      final journalImagesDir =
          Directory(path.join(appDir.path, 'journal_images'));
      if (!await journalImagesDir.exists()) {
        await journalImagesDir.create(recursive: true);
      }

      // Extract portrait + journal image files and build mappings
      final portraitMappings = <String, String>{};
      final journalImageMappings = <String, String>{};
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
        } else if (file.name.startsWith('journal_images/') && file.isFile) {
          final filename = path.basename(file.name);
          final newPath = path.join(journalImagesDir.path, filename);

          final outFile = File(newPath);
          await outFile.writeAsBytes(file.content as List<int>);

          journalImageMappings[file.name] = newPath;
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
          debugPrint('Error importing character: $e');
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
          debugPrint('Error importing base: $e');
        }
      }

      await _importExtendedData(data,
          journalImageMappings: journalImageMappings);

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
          debugPrint('Error importing character ${character.name}: $e');
        }
      }

      // Import bases
      int basesImported = 0;
      for (final base in bases) {
        try {
          await _baseRepository.create(base);
          basesImported++;
        } catch (e) {
          debugPrint('Error importing base ${base.name}: $e');
        }
      }

      await _importExtendedData(data);

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

  /// Clear all existing data (public entry point for UI flows).
  Future<void> clearAllData() async {
    await _clearAllData();
  }

  Future<void> _importExtendedData(
    Map<String, dynamic> data, {
    Map<String, String> journalImageMappings = const {},
  }) async {
    final specializationRepository = _specializationRepository;
    final factionRepository = _factionRepository;
    final augmentationRepository = _augmentationRepository;
    final questRepository = _questRepository;
    final blueprintRepository = _blueprintRepository;
    final classQuestRepository = _classQuestRepository;
    final characterSkillRepository = _characterSkillRepository;

    if (specializationRepository != null) {
      final items =
          (data['characterSpecializations'] as List<dynamic>? ?? const []);
      for (final item in items) {
        final specialization = CharacterSpecialization.fromJson(
          item as Map<String, dynamic>,
        );
        await specializationRepository.upsert(specialization);
      }
    }

    if (factionRepository != null) {
      final items = (data['factionProgress'] as List<dynamic>? ?? const []);
      for (final item in items) {
        final progress = FactionProgress.fromJson(item as Map<String, dynamic>);
        await factionRepository.upsert(progress);
      }
    }

    if (augmentationRepository != null) {
      final items = (data['augmentations'] as List<dynamic>? ?? const []);
      for (final item in items) {
        final augmentation =
            Augmentation.fromJson(item as Map<String, dynamic>);
        await augmentationRepository.upsert(augmentation);
      }
    }

    if (questRepository != null) {
      final quests = (data['quests'] as List<dynamic>? ?? const []);
      for (final item in quests) {
        final quest = Quest.fromJson(item as Map<String, dynamic>);
        await questRepository.upsertQuest(quest);
      }

      final steps = (data['questSteps'] as List<dynamic>? ?? const []);
      for (final item in steps) {
        final step = QuestStep.fromJson(item as Map<String, dynamic>);
        await questRepository.upsertStep(step);
      }
    }

    if (blueprintRepository != null) {
      final blueprints = (data['blueprints'] as List<dynamic>? ?? const []);
      for (final item in blueprints) {
        final blueprint = Blueprint.fromJson(item as Map<String, dynamic>);
        await blueprintRepository.upsert(blueprint);
      }
    }

    if (classQuestRepository != null) {
      final classQuests = (data['classQuests'] as List<dynamic>? ?? const []);
      for (final item in classQuests) {
        final progress =
            ClassQuestProgress.fromJson(item as Map<String, dynamic>);
        await classQuestRepository.upsertProgress(progress);
      }

      final classQuestSteps =
          (data['classQuestSteps'] as List<dynamic>? ?? const []);
      for (final item in classQuestSteps) {
        final step =
            ClassQuestStepProgress.fromJson(item as Map<String, dynamic>);
        await classQuestRepository.upsertStep(step);
      }
    }

    if (characterSkillRepository != null) {
      final items = (data['characterSkills'] as List<dynamic>? ?? const []);
      for (final item in items) {
        final skill = CharacterSkill.fromJson(item as Map<String, dynamic>);
        await characterSkillRepository.upsert(skill);
      }
    }

    final journalRepository = _journalRepository;
    if (journalRepository != null) {
      final items = (data['journalEntries'] as List<dynamic>? ?? const []);
      for (final item in items) {
        final entryMap = item as Map<String, dynamic>;
        // Remap bundled screenshot paths to their extracted location; drop
        // references that weren't bundled so we don't point at stale paths.
        final imagePath = entryMap['imagePath'] as String?;
        if (imagePath != null && imagePath.startsWith('journal_images/')) {
          entryMap['imagePath'] = journalImageMappings[imagePath];
        }
        final entry = JournalEntry.fromJson(entryMap);
        await journalRepository.upsert(entry);
      }
    }

    final planRepository = _baseCalculatorPlanRepository;
    if (planRepository != null) {
      final items = (data['baseCalculatorPlans'] as List<dynamic>? ?? const []);
      for (final item in items) {
        final plan = BaseCalculatorPlan.fromJson(item as Map<String, dynamic>);
        await planRepository.upsert(plan);
      }
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
      debugPrint('Error previewing import: $e');
      return null;
    }
  }
}
