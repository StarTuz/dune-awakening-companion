import 'dart:convert';

import '../../../core/models/base_model.dart';
import 'base_calculator_state.dart';

/// A persisted Base Calculator build plan (Phase 3).
///
/// Item and storage selections are stored as `code -> quantity` maps, encoded
/// as JSON in SQLite via [BaseCalculatorPlanRepository].
class BaseCalculatorPlan implements BaseModel {
  @override
  final String id;
  final String? characterId;
  final String? baseId;
  final String name;
  final bool deepDesertDiscountEnabled;
  final Map<String, int> itemQuantities;
  final Map<String, int> storageQuantities;
  @override
  final DateTime createdAt;
  final DateTime updatedAt;

  static const Object _unset = Object();

  const BaseCalculatorPlan({
    required this.id,
    this.characterId,
    this.baseId,
    required this.name,
    this.deepDesertDiscountEnabled = false,
    this.itemQuantities = const {},
    this.storageQuantities = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  int get totalItems =>
      itemQuantities.values.fold(0, (sum, qty) => sum + (qty > 0 ? qty : 0));

  int get totalStorage =>
      storageQuantities.values.fold(0, (sum, qty) => sum + (qty > 0 ? qty : 0));

  bool get isEmpty =>
      totalItems == 0 && totalStorage == 0 && !deepDesertDiscountEnabled;

  /// Build a plan snapshot from the in-memory calculator state.
  factory BaseCalculatorPlan.fromState({
    required String id,
    required String name,
    required BaseCalculatorState state,
    String? characterId,
    String? baseId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now();
    return BaseCalculatorPlan(
      id: id,
      characterId: characterId,
      baseId: baseId,
      name: name,
      deepDesertDiscountEnabled: state.deepDesertDiscount,
      itemQuantities: Map<String, int>.from(state.quantities),
      storageQuantities: Map<String, int>.from(state.storageQuantities),
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }

  /// Apply this plan to a [BaseCalculatorState]-compatible selection.
  BaseCalculatorState toCalculatorState({String? activePlanId}) {
    return BaseCalculatorState(
      quantities: Map<String, int>.from(itemQuantities),
      storageQuantities: Map<String, int>.from(storageQuantities),
      deepDesertDiscount: deepDesertDiscountEnabled,
      activePlanId: activePlanId ?? id,
      activePlanName: name,
    );
  }

  factory BaseCalculatorPlan.fromJson(Map<String, dynamic> json) {
    return BaseCalculatorPlan(
      id: json['id'] as String,
      characterId: json['characterId'] as String?,
      baseId: json['baseId'] as String?,
      name: json['name'] as String,
      deepDesertDiscountEnabled:
          json['deepDesertDiscountEnabled'] as bool? ?? false,
      itemQuantities: _decodeQuantities(json['itemQuantities']),
      storageQuantities: _decodeQuantities(json['storageQuantities']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'baseId': baseId,
      'name': name,
      'deepDesertDiscountEnabled': deepDesertDiscountEnabled,
      'itemQuantities': itemQuantities,
      'storageQuantities': storageQuantities,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  BaseCalculatorPlan copyWith({
    String? id,
    Object? characterId = _unset,
    Object? baseId = _unset,
    String? name,
    bool? deepDesertDiscountEnabled,
    Map<String, int>? itemQuantities,
    Map<String, int>? storageQuantities,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BaseCalculatorPlan(
      id: id ?? this.id,
      characterId: identical(characterId, _unset)
          ? this.characterId
          : characterId as String?,
      baseId: identical(baseId, _unset) ? this.baseId : baseId as String?,
      name: name ?? this.name,
      deepDesertDiscountEnabled:
          deepDesertDiscountEnabled ?? this.deepDesertDiscountEnabled,
      itemQuantities: itemQuantities ?? this.itemQuantities,
      storageQuantities: storageQuantities ?? this.storageQuantities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Decode a quantity map from JSON export/import or dynamic JSON values.
  static Map<String, int> decodeQuantitiesMap(dynamic raw) =>
      _decodeQuantities(raw);

  static Map<String, int> _decodeQuantities(dynamic raw) {
    if (raw == null) return const {};
    if (raw is Map<String, dynamic>) {
      return raw.map((key, value) => MapEntry(key, (value as num).toInt()));
    }
    if (raw is Map) {
      return raw.map(
        (key, value) => MapEntry(key.toString(), (value as num).toInt()),
      );
    }
    return const {};
  }

  /// Encode a quantity map for SQLite storage.
  static String encodeQuantities(Map<String, int> quantities) {
    final filtered = <String, int>{};
    quantities.forEach((code, qty) {
      if (qty > 0) filtered[code] = qty;
    });
    return jsonEncode(filtered);
  }

  /// Decode a quantity map from SQLite storage.
  static Map<String, int> decodeQuantities(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const {};
    try {
      final decoded = jsonDecode(raw);
      return _decodeQuantities(decoded);
    } catch (_) {
      return const {};
    }
  }
}
