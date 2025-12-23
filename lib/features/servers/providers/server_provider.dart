import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../models/server.dart';
import '../services/server_repository.dart';
import 'package:uuid/uuid.dart';

final serverRepositoryProvider = Provider<ServerRepository>((ref) {
  return ServerRepository(AppDatabase.instance);
});

final serversProvider = StateNotifierProvider<ServerNotifier, AsyncValue<List<Server>>>((ref) {
  final repository = ref.watch(serverRepositoryProvider);
  return ServerNotifier(repository);
});

class ServerNotifier extends StateNotifier<AsyncValue<List<Server>>> {
  final ServerRepository _repository;

  ServerNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadServers();
  }

  Future<void> _loadServers() async {
    try {
      state = const AsyncValue.loading();
      final servers = await _repository.getAll();
      state = AsyncValue.data(servers);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createServer(String name) async {
    try {
      final server = Server(
        id: const Uuid().v4(),
        name: name,
        createdAt: DateTime.now(),
      );
      await _repository.create(server);
      await _loadServers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateServer(Server server) async {
    try {
      await _repository.update(server);
      await _loadServers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteServer(String id) async {
    try {
      await _repository.delete(id);
      await _loadServers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
