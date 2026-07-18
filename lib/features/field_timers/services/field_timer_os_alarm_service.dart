import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';

import '../models/field_timer_preset.dart';

/// Drives the field-timer timeline through the `alarm` package on Android.
///
/// This is the real alarm-clock architecture: AlarmManager wakes a native
/// foreground service that holds a wake lock and plays the audio itself on
/// the alarm stream. It works with the screen off, in Doze, and after the
/// app process is killed — unlike notification-channel sounds, which OEM
/// battery management is free to degrade.
///
/// Cue stages play once each at their offsets; the T=0 page loops audio and
/// vibration until the user stops it (which replaces the old scheduled
/// escalation repeats — a real alarm doesn't repeat, it rings continuously).
class FieldTimerOsAlarmService {
  FieldTimerOsAlarmService();

  /// ID range distinct from the notification IDs used elsewhere in the app.
  static const _pageAlarmId = 910000;
  static const _cueAlarmIdBase = 910100;
  static const _maxCues = 10;

  bool _initialized = false;

  /// The alarm package backs Android only in this app; iOS keeps the in-app
  /// path for now (the plugin supports it, but it needs separate testing).
  bool get supported => !kIsWeb && Platform.isAndroid;

  Future<void> initialize() async {
    if (!supported || _initialized) return;
    try {
      await Alarm.init();
      _initialized = true;
    } catch (e) {
      debugPrint('[FieldTimerOsAlarm] init failed: $e');
    }
  }

  /// Schedule the full timeline as native alarms. Returns true only when
  /// every alarm was accepted — callers keep in-app audio alive otherwise.
  Future<bool> scheduleTimeline({
    required Duration totalDuration,
    required List<FieldTimerCue> cues,
    required String cueTitle,
    required String cueBody,
    required String pageTitle,
    required String pageBody,
    required String stopButtonLabel,
    required double volume,
  }) async {
    if (!supported) return false;
    await initialize();
    if (!_initialized) return false;

    final now = DateTime.now();
    final firesAt = now.add(totalDuration);
    var ok = true;

    var cueIndex = 0;
    for (final cue in cues) {
      cueIndex++;
      final when = firesAt.subtract(cue.offsetFromEnd);
      if (!when.isAfter(now)) continue;
      final stage = cue.stage.clamp(1, 4);
      ok &= await _set(AlarmSettings(
        id: _cueAlarmIdBase + cueIndex,
        dateTime: when,
        assetAudioPath: 'assets/field_timers/cue_stage_$stage.wav',
        loopAudio: false,
        vibrate: false,
        allowAlarmOverlap: true,
        androidFullScreenIntent: false,
        warningNotificationOnKill: false,
        volumeSettings: VolumeSettings.fixed(volume: volume),
        notificationSettings: NotificationSettings(
          title: cueTitle,
          body: cueBody,
        ),
      ));
    }

    // T=0 page: loops audio + vibration until stopped — continuous ringing
    // replaces the old escalation repeats.
    ok &= await _set(AlarmSettings(
      id: _pageAlarmId,
      dateTime: firesAt,
      assetAudioPath: 'assets/field_timers/cue_page.wav',
      loopAudio: true,
      vibrate: true,
      allowAlarmOverlap: true,
      androidFullScreenIntent: true,
      warningNotificationOnKill: true,
      volumeSettings: VolumeSettings.fixed(
        volume: volume,
        volumeEnforced: true,
      ),
      notificationSettings: NotificationSettings(
        title: pageTitle,
        body: pageBody,
        stopButton: stopButtonLabel,
      ),
    ));

    debugPrint(
        '[FieldTimerOsAlarm] Timeline scheduled: ${cues.length} cues, page at '
        '$firesAt, ok=$ok');
    return ok;
  }

  /// Stop the ringing page and remove every pending alarm.
  Future<void> cancelAll() async {
    if (!supported || !_initialized) return;
    try {
      await Alarm.stop(_pageAlarmId);
      for (var i = 1; i <= _maxCues; i++) {
        await Alarm.stop(_cueAlarmIdBase + i);
      }
    } catch (e) {
      debugPrint('[FieldTimerOsAlarm] cancelAll failed: $e');
    }
  }

  Future<bool> _set(AlarmSettings settings) async {
    try {
      return await Alarm.set(alarmSettings: settings);
    } catch (e) {
      debugPrint('[FieldTimerOsAlarm] set id=${settings.id} failed: $e');
      return false;
    }
  }
}
