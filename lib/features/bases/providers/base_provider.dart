import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../models/base.dart';
import '../services/base_repository.dart';
import 'package:uuid/uuid.dart';

final baseRepositoryProvider = Provider<BaseRepository>((ref) {
  return BaseRepository(AppDatabase.instance);
});

final basesProvider = StateNotifierProvider<BaseNotifier, AsyncValue<List<Base>>>((ref) {
  final repository = ref.watch(baseRepositoryProvider);
  return BaseNotifier(repository, ref);
});

final basesByCharacterProvider = FutureProvider.family<List<Base>, String>((ref, characterId) async {
  final repository = ref.watch(baseRepositoryProvider);
  return await repository.getByCharacterId(characterId);
});

final expiringBasesProvider = FutureProvider<List<Base>>((ref) async {
  final repository = ref.watch(baseRepositoryProvider);
  return await repository.getExpiringSoon();
});

class BaseNotifier extends StateNotifier<AsyncValue<List<Base>>> {
  final BaseRepository _repository;
  final Ref _ref;

  BaseNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadBases();
  }

  Future<void> _loadBases() async {
    try {
      state = const AsyncValue.loading();
      final bases = await _repository.getAll();
      state = AsyncValue.data(bases);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createBase(
    String characterId,
    String name,
    DateTime powerExpirationTime, {
    bool isAdvancedFief = false,
    int? taxPerCycle,
    DateTime? nextTaxDueDate,
    int? currentOwed,
    int? overdueOwed,
    int? defaultedOwed,
  }) async {
    try {
      final base = Base(
        id: const Uuid().v4(),
        characterId: characterId,
        name: name,
        powerExpirationTime: powerExpirationTime,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isAdvancedFief: isAdvancedFief,
        taxPerCycle: taxPerCycle,
        nextTaxDueDate: nextTaxDueDate,
        currentOwed: currentOwed,
        overdueOwed: overdueOwed,
        defaultedOwed: defaultedOwed,
      );
      await _repository.create(base);
      _ref.invalidate(basesByCharacterProvider(characterId));
      _ref.invalidate(basesProvider);
      _ref.invalidate(expiringBasesProvider);
      await _loadBases();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateBase(Base base) async {
    try {
      final updatedBase = base.copyWith(updatedAt: DateTime.now());
      await _repository.update(updatedBase);
      _ref.invalidate(basesByCharacterProvider(base.characterId));
      _ref.invalidate(basesProvider);
      _ref.invalidate(expiringBasesProvider);
      await _loadBases();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteBase(String id, String characterId) async {
    try {
      await _repository.delete(id);
      _ref.invalidate(basesByCharacterProvider(characterId));
      _ref.invalidate(basesProvider);
      _ref.invalidate(expiringBasesProvider);
      await _loadBases();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
