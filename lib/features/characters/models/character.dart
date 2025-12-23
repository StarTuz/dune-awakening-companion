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
  final String? provider; // Only for private servers (GPORTAL, BisectHosting, etc.)
  final String world;
  final String sietch;
  final String? portraitPath; // Path to character portrait image
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
    this.portraitPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
  
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
    String? portraitPath,
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
      portraitPath: portraitPath ?? this.portraitPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


