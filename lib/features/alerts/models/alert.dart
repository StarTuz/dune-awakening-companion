import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/base_model.dart';

part 'alert.g.dart';

@JsonSerializable()
class Alert implements BaseModel {
  @override
  final String id;
  final String baseId;
  final int thresholdHours; // Which threshold triggered this alert
  @override
  final DateTime createdAt;
  final DateTime? acknowledgedAt;
  final DateTime? dismissedAt;

  Alert({
    required this.id,
    required this.baseId,
    required this.thresholdHours,
    required this.createdAt,
    this.acknowledgedAt,
    this.dismissedAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$AlertToJson(this);

  bool get isAcknowledged => acknowledgedAt != null;
  bool get isDismissed => dismissedAt != null;
  bool get isActive => !isAcknowledged && !isDismissed;

  Alert copyWith({
    String? id,
    String? baseId,
    int? thresholdHours,
    DateTime? createdAt,
    DateTime? acknowledgedAt,
    DateTime? dismissedAt,
  }) {
    return Alert(
      id: id ?? this.id,
      baseId: baseId ?? this.baseId,
      thresholdHours: thresholdHours ?? this.thresholdHours,
      createdAt: createdAt ?? this.createdAt,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      dismissedAt: dismissedAt ?? this.dismissedAt,
    );
  }
}

