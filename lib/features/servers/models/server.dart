import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/base_model.dart';

part 'server.g.dart';

@JsonSerializable()
class Server implements BaseModel {
  @override
  final String id;
  final String name;
  @override
  final DateTime createdAt;

  Server({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Server.fromJson(Map<String, dynamic> json) => _$ServerFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$ServerToJson(this);

  Server copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
  }) {
    return Server(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

