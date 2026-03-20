import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/base_model.dart';

part 'base.g.dart';

@JsonSerializable()
class Base implements BaseModel {
  static const Object _unset = Object();

  @override
  final String id;
  final String characterId;
  final String name;
  final DateTime powerExpirationTime; // Manual entry
  final bool notificationsEnabled;
  final int? warningThresholdHours;
  final int? criticalThresholdHours;
  @override
  final DateTime createdAt;
  final DateTime updatedAt;

  Base({
    required this.id,
    required this.characterId,
    required this.name,
    required this.powerExpirationTime,
    this.notificationsEnabled = true,
    this.warningThresholdHours,
    this.criticalThresholdHours,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Base.fromJson(Map<String, dynamic> json) => _$BaseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseToJson(this);

  /// Calculate hours remaining until power expiration
  double get hoursRemaining {
    final now = DateTime.now();
    final difference = powerExpirationTime.difference(now);
    return difference.inMinutes / 60.0;
  }

  /// Check if power has expired
  bool get isExpired => hoursRemaining <= 0;

  /// Check if power is expiring soon (within 24 hours)
  bool get isExpiringSoon => hoursRemaining <= 24 && !isExpired;

  int get effectiveWarningThresholdHours => warningThresholdHours ?? 48;

  int get effectiveCriticalThresholdHours => criticalThresholdHours ?? 24;

  Base copyWith({
    String? id,
    String? characterId,
    String? name,
    DateTime? powerExpirationTime,
    bool? notificationsEnabled,
    Object? warningThresholdHours = _unset,
    Object? criticalThresholdHours = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Base(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      powerExpirationTime: powerExpirationTime ?? this.powerExpirationTime,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      warningThresholdHours: identical(warningThresholdHours, _unset)
          ? this.warningThresholdHours
          : warningThresholdHours as int?,
      criticalThresholdHours: identical(criticalThresholdHours, _unset)
          ? this.criticalThresholdHours
          : criticalThresholdHours as int?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
