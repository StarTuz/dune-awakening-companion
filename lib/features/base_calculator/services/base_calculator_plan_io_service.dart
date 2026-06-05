import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/base_calculator_plan.dart';
import '../models/base_calculator_portable_plan.dart';
import '../models/base_calculator_state.dart';
import 'base_calculator_share_codec.dart';

/// File and clipboard helpers for sharing individual calculator plans.
class BaseCalculatorPlanIoService {
  /// Export a portable plan to a JSON file chosen by the user.
  /// Returns the saved path, or `null` if the user cancelled.
  Future<String?> exportPortableJson(BaseCalculatorPortablePlan plan) async {
    try {
      final slug = _slugify(plan.name);
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'dune_base_plan_${slug}_$timestamp.json';

      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Base Plan',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (outputPath == null) return null;

      final path = outputPath.endsWith('.json') ? outputPath : '$outputPath.json';
      final jsonString =
          const JsonEncoder.withIndent('  ').convert(plan.toJson());
      await File(path).writeAsString(jsonString);
      return path;
    } catch (e, stack) {
      debugPrint('Error exporting base plan JSON: $e\n$stack');
      return null;
    }
  }

  /// Import a portable plan from a JSON file.
  Future<BaseCalculatorPortablePlan?> importPortableJson() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Import Base Plan',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.isEmpty) return null;

      final picked = result.files.single;
      final bytes = picked.bytes;
      final path = picked.path;
      final jsonString = bytes != null
          ? utf8.decode(bytes)
          : path == null
              ? null
              : await File(path).readAsString();
      if (jsonString == null) return null;

      final decoded = json.decode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Plan JSON must be an object');
      }
      return BaseCalculatorPortablePlan.fromJson(decoded);
    } catch (e, stack) {
      debugPrint('Error importing base plan JSON: $e\n$stack');
      rethrow;
    }
  }

  String encodeShareCode(BaseCalculatorPortablePlan plan) {
    return BaseCalculatorShareCodec.encode(plan);
  }

  BaseCalculatorPortablePlan decodeShareCode(String raw) {
    return BaseCalculatorShareCodec.decode(raw);
  }

  BaseCalculatorPortablePlan portableFromState(
    BaseCalculatorState state, {
    String? name,
  }) {
    return BaseCalculatorPortablePlan.fromState(state, name: name);
  }

  BaseCalculatorPortablePlan portableFromPlan(BaseCalculatorPlan plan) {
    return BaseCalculatorPortablePlan.fromPlan(plan);
  }

  String _slugify(String name) {
    final trimmed = name.trim().toLowerCase();
    if (trimmed.isEmpty) return 'plan';
    final slug = trimmed.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final collapsed =
        slug.replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_|_$'), '');
    if (collapsed.isEmpty) return 'plan';
    return collapsed.length <= 32 ? collapsed : collapsed.substring(0, 32);
  }
}
