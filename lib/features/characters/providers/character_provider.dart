import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../models/character.dart';
import '../services/character_repository.dart';
import 'package:uuid/uuid.dart';

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return CharacterRepository(AppDatabase.instance);
});

final charactersProvider = StateNotifierProvider<CharacterNotifier, AsyncValue<List<Character>>>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return CharacterNotifier(repository);
});

class CharacterNotifier extends StateNotifier<AsyncValue<List<Character>>> {
  final CharacterRepository _repository;

  CharacterNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    try {
      state = const AsyncValue.loading();
      final characters = await _repository.getAll();
      state = AsyncValue.data(characters);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createCharacter(
    String name,
    String region,
    String serverType,
    String? provider,
    String world,
    String sietch,
  ) async {
    try {
      final character = Character(
        id: const Uuid().v4(),
        name: name,
        region: region,
        serverType: serverType,
        provider: provider,
        world: world,
        sietch: sietch,
        portraitPath: null, // Will be set separately if portrait was selected
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.create(character);
      await _loadCharacters();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createCharacterWithPortrait(
    String name,
    String region,
    String serverType,
    String? provider,
    String world,
    String sietch,
    String? sourcePortraitPath,
    dynamic imageService, // Pass ImageService from dialog
  ) async {
    try {
      final characterId = const Uuid().v4();
      String? savedPortraitPath;

      // Process portrait if provided
      if (sourcePortraitPath != null && imageService != null) {
        savedPortraitPath = await imageService.savePortrait(sourcePortraitPath, characterId);
      }

      final character = Character(
        id: characterId,
        name: name,
        region: region,
        serverType: serverType,
        provider: provider,
        world: world,
        sietch: sietch,
        portraitPath: savedPortraitPath,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.create(character);
      await _loadCharacters();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateCharacter(Character character) async {
    try {
      await _repository.update(character);
      await _loadCharacters();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateCharacterWithPortrait(
    Character character,
    String? newPortraitPath,
    bool portraitChanged,
    dynamic imageService,
  ) async {
    try {
      String? finalPortraitPath = character.portraitPath;

      if (portraitChanged) {
        // Delete old portrait if it exists
        if (character.portraitPath != null && imageService != null) {
          await imageService.deletePortrait(character.portraitPath);
        }

        // Save new portrait if provided
        if (newPortraitPath != null && imageService != null) {
          finalPortraitPath = await imageService.savePortrait(newPortraitPath, character.id);
        } else {
          finalPortraitPath = null;
        }
      }

      final updatedCharacter = character.copyWith(
        portraitPath: finalPortraitPath,
      );

      await _repository.update(updatedCharacter);
      await _loadCharacters();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteCharacter(String id, dynamic imageService) async {
    try {
      // Get character to check for portrait
      final character = await _repository.getById(id);
      
      // Delete portrait if exists
      if (character?.portraitPath != null && imageService != null) {
        await imageService.deletePortrait(character!.portraitPath);
      }
      
      await _repository.delete(id);
      await _loadCharacters();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
