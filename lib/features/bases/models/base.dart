import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/base_model.dart';

part 'base.g.dart';

@JsonSerializable()
class Base implements BaseModel {
  @override
  final String id;
  final String characterId;
  final String name;
  final DateTime powerExpirationTime; // Manual entry
  @override
  final DateTime createdAt;
  final DateTime updatedAt;

  Base({
    required this.id,
    required this.characterId,
    required this.name,
    required this.powerExpirationTime,
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

  Base copyWith({
    String? id,
    String? characterId,
    String? name,
    DateTime? powerExpirationTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Base(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      powerExpirationTime: powerExpirationTime ?? this.powerExpirationTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
