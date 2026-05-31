import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/base_model.dart';

part 'character.g.dart';

@JsonSerializable()
class Character implements BaseModel {
  @override
  final String id;
  final String name;
  final String region;
  final String serverType; // 'Official' or 'Private'
  final String?
      provider; // Only for private servers (GPORTAL, BisectHosting, etc.)
  final String world;
  final String sietch;
  final String? primaryClass;
  final String? portraitPath; // Path to character portrait image
  final String? biography; // Short "about this ghola" blurb (RPG journal)
  @override
  final DateTime createdAt;
  final DateTime updatedAt;

  Character({
    required this.id,
    required this.name,
    required this.region,
    required this.serverType,
    this.provider,
    required this.world,
    required this.sietch,
    this.primaryClass,
    this.portraitPath,
    this.biography,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  Character copyWith({
    String? id,
    String? name,
    String? region,
    String? serverType,
    String? provider,
    String? world,
    String? sietch,
    String? primaryClass,
    String? portraitPath,
    Object? biography = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      serverType: serverType ?? this.serverType,
      provider: provider ?? this.provider,
      world: world ?? this.world,
      sietch: sietch ?? this.sietch,
      primaryClass: primaryClass ?? this.primaryClass,
      portraitPath: portraitPath ?? this.portraitPath,
      // Sentinel lets callers clear the biography by passing `null` (a plain
      // `?? this.biography` would silently keep the old value).
      biography:
          identical(biography, _unset) ? this.biography : biography as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static const Object _unset = Object();
}
