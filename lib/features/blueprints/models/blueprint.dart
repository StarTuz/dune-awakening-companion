class Blueprint {
  static const Object _unset = Object();
  static const String defaultRegion = 'Hagga Basin South';

  final String id;
  final String characterId;
  final String name;
  final String category;
  final String region;
  final String? sourceType;
  final String? sourceLocation;
  final List<String> requiredMaterials;
  final String? notes;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String? questId;
  final String? mapPinId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Blueprint({
    required this.id,
    required this.characterId,
    required this.name,
    required this.category,
    this.region = defaultRegion,
    this.sourceType,
    this.sourceLocation,
    this.requiredMaterials = const [],
    this.notes,
    this.isUnlocked = false,
    this.unlockedAt,
    this.questId,
    this.mapPinId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Blueprint.fromJson(Map<String, dynamic> json) {
    return Blueprint(
      id: json['id'] as String,
      characterId: json['characterId'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'Other',
      region: json['region'] as String? ?? defaultRegion,
      sourceType: json['sourceType'] as String?,
      sourceLocation: json['sourceLocation'] as String?,
      requiredMaterials: (json['requiredMaterials'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
      notes: json['notes'] as String?,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
      questId: json['questId'] as String?,
      mapPinId: json['mapPinId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'name': name,
      'category': category,
      'region': region,
      'sourceType': sourceType,
      'sourceLocation': sourceLocation,
      'requiredMaterials': requiredMaterials,
      'notes': notes,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'questId': questId,
      'mapPinId': mapPinId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Blueprint copyWith({
    String? id,
    String? characterId,
    String? name,
    String? category,
    String? region,
    Object? sourceType = _unset,
    Object? sourceLocation = _unset,
    List<String>? requiredMaterials,
    Object? notes = _unset,
    bool? isUnlocked,
    Object? unlockedAt = _unset,
    Object? questId = _unset,
    Object? mapPinId = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Blueprint(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      category: category ?? this.category,
      region: region ?? this.region,
      sourceType: identical(sourceType, _unset)
          ? this.sourceType
          : sourceType as String?,
      sourceLocation: identical(sourceLocation, _unset)
          ? this.sourceLocation
          : sourceLocation as String?,
      requiredMaterials: requiredMaterials ?? this.requiredMaterials,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: identical(unlockedAt, _unset)
          ? this.unlockedAt
          : unlockedAt as DateTime?,
      questId: identical(questId, _unset) ? this.questId : questId as String?,
      mapPinId:
          identical(mapPinId, _unset) ? this.mapPinId : mapPinId as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
