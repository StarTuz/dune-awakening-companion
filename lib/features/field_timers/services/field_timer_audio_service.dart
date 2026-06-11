import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'field_timer_settings.dart';

/// Handles in-app audio playback for field timer cue stages and the T=0 page.
///
/// Resolution order per stage: user override → bundled asset → silent fallback.
/// Uses [audioplayers] which supports Linux/Windows/macOS/Android/iOS with the
/// same API — no platform-specific code paths for cue playback.
class FieldTimerAudioService {
  FieldTimerAudioService();

  final AudioPlayer _player = AudioPlayer();

  /// Folder name within app documents where user overrides live.
  static const _overrideFolderName = 'field_timer_sounds';

  static const _bundledFiles = {
    1: 'assets/field_timers/cue_stage_1.wav',
    2: 'assets/field_timers/cue_stage_2.wav',
    3: 'assets/field_timers/cue_stage_3.wav',
    4: 'assets/field_timers/cue_stage_4.wav',
  };
  static const _bundledPageFile = 'assets/field_timers/cue_page.wav';

  static const _overrideFileNames = {
    1: 'cue_stage_1.wav',
    2: 'cue_stage_2.wav',
    3: 'cue_stage_3.wav',
    4: 'cue_stage_4.wav',
  };
  static const _overridePageFileName = 'cue_page.wav';

  double _volume = FieldTimerSettings.defaultCueVolume;

  Future<void> initialize() async {
    _volume = await FieldTimerSettings.getCueVolume();
    await _player.setVolume(_volume);
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await FieldTimerSettings.setCueVolume(_volume);
    await _player.setVolume(_volume);
  }

  double get volume => _volume;

  /// Play the cue for [stage] (1-based). Stages > 4 reuse stage 4's sound.
  Future<void> playCueStage(int stage) async {
    final effectiveStage = stage.clamp(1, 4);
    final overrideName = _overrideFileNames[effectiveStage]!;
    final source = await _resolveSource(
      overrideName,
      _bundledFiles[effectiveStage]!,
    );
    if (source == null) return;
    await _play(source);
  }

  /// Play the T=0 page / escalation sound.
  Future<void> playPage() async {
    final source =
        await _resolveSource(_overridePageFileName, _bundledPageFile);
    if (source == null) return;
    await _play(source);
  }

  /// Stop any currently-playing cue immediately.
  Future<void> stopAll() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('[FieldTimerAudio] stopAll error: $e');
    }
  }

  /// Play each cue stage in ascending order (1 → cueCount → page) for testing.
  Future<void> testAllCues(int cueCount) async {
    for (var i = 1; i <= cueCount; i++) {
      await playCueStage(i);
      await Future.delayed(const Duration(milliseconds: 600));
    }
    await Future.delayed(const Duration(milliseconds: 400));
    await playPage();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  // ── Internals ──────────────────────────────────────────────────────────

  Future<Source?> _resolveSource(
      String overrideName, String bundledAsset) async {
    try {
      final override = await _userOverridePath(overrideName);
      if (override != null && File(override).existsSync()) {
        debugPrint('[FieldTimerAudio] Using custom: $override');
        return DeviceFileSource(override);
      }
    } catch (e) {
      debugPrint('[FieldTimerAudio] Override lookup failed: $e');
    }
    return AssetSource(bundledAsset.replaceFirst('assets/', ''));
  }

  Future<String?> _userOverridePath(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return '${dir.path}${Platform.pathSeparator}$_overrideFolderName'
          '${Platform.pathSeparator}$fileName';
    } catch (_) {
      return null;
    }
  }

  Future<void> _play(Source source) async {
    try {
      await _player.setVolume(_volume);
      await _player.play(source);
    } catch (e) {
      debugPrint('[FieldTimerAudio] Play error: $e');
    }
  }

  /// Returns the resolved override folder path for display in settings UI.
  Future<String?> overrideFolderPath() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return '${dir.path}${Platform.pathSeparator}$_overrideFolderName';
    } catch (_) {
      return null;
    }
  }
}
