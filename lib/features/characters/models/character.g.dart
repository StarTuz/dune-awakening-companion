// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: json['id'] as String,
      name: json['name'] as String,
      region: json['region'] as String,
      serverType: json['serverType'] as String,
      provider: json['provider'] as String?,
      world: json['world'] as String,
      sietch: json['sietch'] as String,
      primaryClass: json['primaryClass'] as String?,
      portraitPath: json['portraitPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'region': instance.region,
      'serverType': instance.serverType,
      'provider': instance.provider,
      'world': instance.world,
      'sietch': instance.sietch,
      'primaryClass': instance.primaryClass,
      'portraitPath': instance.portraitPath,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
