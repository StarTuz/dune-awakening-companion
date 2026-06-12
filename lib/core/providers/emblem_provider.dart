import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/image_service.dart';
import 'image_service_provider.dart';

/// The app emblem shown in the navigation rail.
///
/// [customPath] is null when the bundled default (the Jerboa) should be used.
/// [revision] increments on every change so widgets rebuild and the image
/// cache is bypassed even though the custom emblem keeps the same file path.
@immutable
class EmblemState {
  const EmblemState({this.customPath, this.revision = 0});

  final String? customPath;
  final int revision;

  bool get isCustom => customPath != null;
}

final emblemProvider =
    StateNotifierProvider<EmblemNotifier, EmblemState>((ref) {
  return EmblemNotifier(ref.watch(imageServiceProvider));
});

class EmblemNotifier extends StateNotifier<EmblemState> {
  EmblemNotifier(this._imageService) : super(const EmblemState()) {
    refresh();
  }

  /// Test-only constructor that skips the initial filesystem probe.
  @visibleForTesting
  EmblemNotifier.forTest(this._imageService, EmblemState initial)
      : super(initial);

  final ImageService _imageService;

  /// Re-read the custom emblem from disk (startup and after import).
  Future<void> refresh() async {
    try {
      final path = await _imageService.getEmblemPath();
      if (!mounted) return;
      await _evict(path);
      state = EmblemState(customPath: path, revision: state.revision + 1);
    } catch (_) {
      // Keep the default emblem if the filesystem is unavailable.
    }
  }

  /// Save [sourcePath] as the custom emblem. Returns false if the image
  /// could not be processed.
  Future<bool> setCustom(String sourcePath) async {
    final saved = await _imageService.saveEmblem(sourcePath);
    if (saved == null) return false;
    if (mounted) {
      await _evict(saved);
      state = EmblemState(customPath: saved, revision: state.revision + 1);
    }
    return true;
  }

  /// Remove the custom emblem and fall back to the bundled default.
  Future<void> reset() async {
    final previous = state.customPath;
    await _imageService.deleteEmblem();
    if (mounted) {
      await _evict(previous);
      state = EmblemState(revision: state.revision + 1);
    }
  }

  Future<void> _evict(String? path) async {
    if (path == null) return;
    try {
      await FileImage(File(path)).evict();
    } catch (_) {
      // Cache eviction is best-effort.
    }
  }
}
