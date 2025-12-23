/// Base model interface for all data models
abstract class BaseModel {
  String get id;
  DateTime get createdAt;
  
  Map<String, dynamic> toJson();
}

