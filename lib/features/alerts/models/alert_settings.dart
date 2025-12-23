import 'package:json_annotation/json_annotation.dart';

part 'alert_settings.g.dart';

@JsonSerializable()
class AlertSettings {
  /// Warning thresholds in hours (e.g., [24, 12, 6, 1])
  final List<int> warningThresholds;
  
  /// How often to check for alerts (in minutes)
  final int checkIntervalMinutes;
  
  /// How often to repeat alerts (in minutes). 0 = alert once only
  final int repeatIntervalMinutes;
  
  /// Enable sound alerts
  final bool enableSound;
  
  /// Enable desktop/mobile notifications
  final bool enableNotifications;
  
  /// Minimize to system tray
  final bool minimizeToTray;

  AlertSettings({
    this.warningThresholds = const [24], // Default: 24 hours
    this.checkIntervalMinutes = 1,
    this.repeatIntervalMinutes = 0, // Default: alert once
    this.enableSound = false,
    this.enableNotifications = true,
    this.minimizeToTray = true,
  });

  factory AlertSettings.fromJson(Map<String, dynamic> json) => 
      _$AlertSettingsFromJson(json);
  
  Map<String, dynamic> toJson() => _$AlertSettingsToJson(this);

  AlertSettings copyWith({
    List<int>? warningThresholds,
    int? checkIntervalMinutes,
    int? repeatIntervalMinutes,
    bool? enableSound,
    bool? enableNotifications,
    bool? minimizeToTray,
  }) {
    return AlertSettings(
      warningThresholds: warningThresholds ?? this.warningThresholds,
      checkIntervalMinutes: checkIntervalMinutes ?? this.checkIntervalMinutes,
      repeatIntervalMinutes: repeatIntervalMinutes ?? this.repeatIntervalMinutes,
      enableSound: enableSound ?? this.enableSound,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      minimizeToTray: minimizeToTray ?? this.minimizeToTray,
    );
  }
}

