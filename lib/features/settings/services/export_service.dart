import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import '../../augmentations/services/augmentation_repository.dart';
import '../../blueprints/services/blueprint_repository.dart';
import '../../class_quests/services/class_quest_repository.dart';
import '../../characters/services/character_repository.dart';
import '../../factions/services/faction_progress_repository.dart';
import '../../bases/services/base_repository.dart';
import '../../quest_journal/services/quest_repository.dart';
import '../../skills/services/character_skill_repository.dart';
import '../../specializations/services/character_specialization_repository.dart';

class ExportService {
  final CharacterRepository _characterRepository;
  final BaseRepository _baseRepository;
  final CharacterSpecializationRepository? _specializationRepository;
  final FactionProgressRepository? _factionRepository;
  final AugmentationRepository? _augmentationRepository;
  final QuestRepository? _questRepository;
  final BlueprintRepository? _blueprintRepository;
  final ClassQuestRepository? _classQuestRepository;
  final CharacterSkillRepository? _characterSkillRepository;

  ExportService(
    this._characterRepository,
    this._baseRepository, {
    CharacterSpecializationRepository? specializationRepository,
    FactionProgressRepository? factionRepository,
    AugmentationRepository? augmentationRepository,
    QuestRepository? questRepository,
    BlueprintRepository? blueprintRepository,
    ClassQuestRepository? classQuestRepository,
    CharacterSkillRepository? characterSkillRepository,
  })  : _specializationRepository = specializationRepository,
        _factionRepository = factionRepository,
        _augmentationRepository = augmentationRepository,
        _questRepository = questRepository,
        _blueprintRepository = blueprintRepository,
        _classQuestRepository = classQuestRepository,
        _characterSkillRepository = characterSkillRepository;

  /// Export all data to ZIP file (includes portraits)
  /// Returns the file path if successful, null otherwise
  Future<String?> exportData() async {
    try {
      // Get all data
      final characters = await _characterRepository.getAll();
      final bases = await _baseRepository.getAll();
      final specializationRepository = _specializationRepository;
      final factionRepository = _factionRepository;
      final augmentationRepository = _augmentationRepository;
      final questRepository = _questRepository;
      final blueprintRepository = _blueprintRepository;
      final classQuestRepository = _classQuestRepository;
      final characterSkillRepository = _characterSkillRepository;
      final specializations = specializationRepository == null
          ? <dynamic>[]
          : await specializationRepository.getAll();
      final factionProgress = <dynamic>[];
      final augmentations = <dynamic>[];
      final quests = <dynamic>[];
      final questSteps = <dynamic>[];
      final blueprints = <dynamic>[];
      final classQuests = <dynamic>[];
      final classQuestSteps = <dynamic>[];
      final characterSkills = <dynamic>[];

      if (factionRepository != null ||
          augmentationRepository != null ||
          questRepository != null ||
          blueprintRepository != null ||
          classQuestRepository != null ||
          characterSkillRepository != null) {
        for (final character in characters) {
          if (factionRepository != null) {
            factionProgress
                .addAll(await factionRepository.getByCharacterId(character.id));
          }
          if (augmentationRepository != null) {
            augmentations.addAll(
                await augmentationRepository.getByCharacterId(character.id));
          }
          if (questRepository != null) {
            final characterQuests =
                await questRepository.getByCharacterId(character.id);
            quests.addAll(characterQuests);
            for (final quest in characterQuests) {
              questSteps.addAll(await questRepository.getSteps(quest.id));
            }
          }
          if (blueprintRepository != null) {
            blueprints.addAll(
                await blueprintRepository.getByCharacterId(character.id));
          }
          if (classQuestRepository != null) {
            final progressEntries =
                await classQuestRepository.getByCharacterId(character.id);
            classQuests.addAll(progressEntries);
            for (final progress in progressEntries) {
              classQuestSteps.addAll(
                await classQuestRepository.getSteps(progress.id),
              );
            }
          }
          if (characterSkillRepository != null) {
            characterSkills.addAll(
              await characterSkillRepository.getByCharacterId(character.id),
            );
          }
        }
      }

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
            final filename =
                'portraits/${character.id}${path.extension(character.portraitPath!)}';
            archive.addFile(ArchiveFile(filename, bytes.length, bytes));
            portraitMappings[character.portraitPath!] = filename;
          }
        }
      }

      // Create export data with relative portrait paths
      final exportCharacters = characters.map((c) {
        final json = c.toJson();
        if (c.portraitPath != null &&
            portraitMappings.containsKey(c.portraitPath)) {
          json['portraitPath'] = portraitMappings[c.portraitPath];
        }
        return json;
      }).toList();

      // Create JSON data
      final exportData = {
        'version': '1.3.0-beta',
        'exportDate': DateTime.now().toIso8601String(),
        'databaseVersion': 12,
        'format': 'zip',
        'characters': exportCharacters,
        'bases': bases.map((b) => b.toJson()).toList(),
        'characterSpecializations':
            specializations.map((s) => s.toJson()).toList(),
        'factionProgress': factionProgress.map((f) => f.toJson()).toList(),
        'augmentations': augmentations.map((a) => a.toJson()).toList(),
        'quests': quests.map((q) => q.toJson()).toList(),
        'questSteps': questSteps.map((s) => s.toJson()).toList(),
        'blueprints': blueprints.map((b) => b.toJson()).toList(),
        'classQuests': classQuests.map((q) => q.toJson()).toList(),
        'classQuestSteps': classQuestSteps.map((s) => s.toJson()).toList(),
        'characterSkills': characterSkills.map((s) => s.toJson()).toList(),
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
      debugPrint('Error exporting data: $e');
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
