import 'package:json_annotation/json_annotation.dart';

part 'augmentation.g.dart';

@JsonSerializable()
class Augmentation {
  static const Object _unset = Object();

  final String id;
  final String characterId;
  final String name;
  final String slot;
  final String? sourceBoss;
  final String? notes;
  final bool isEquipped;
  final DateTime? acquiredAt;
  final DateTime updatedAt;

  Augmentation({
    required this.id,
    required this.characterId,
    required this.name,
    required this.slot,
    this.sourceBoss,
    this.notes,
    this.isEquipped = false,
    this.acquiredAt,
    required this.updatedAt,
  });

  factory Augmentation.fromJson(Map<String, dynamic> json) =>
      _$AugmentationFromJson(json);

  Map<String, dynamic> toJson() => _$AugmentationToJson(this);

  Augmentation copyWith({
    String? id,
    String? characterId,
    String? name,
    String? slot,
    Object? sourceBoss = _unset,
    Object? notes = _unset,
    bool? isEquipped,
    Object? acquiredAt = _unset,
    DateTime? updatedAt,
  }) {
    return Augmentation(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      slot: slot ?? this.slot,
      sourceBoss: identical(sourceBoss, _unset)
          ? this.sourceBoss
          : sourceBoss as String?,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      isEquipped: isEquipped ?? this.isEquipped,
      acquiredAt: identical(acquiredAt, _unset)
          ? this.acquiredAt
          : acquiredAt as DateTime?,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
