import '../models/base_calculator_catalog.dart';
import '../models/base_calculator_portable_plan.dart';
import '../models/storage_catalog.dart';

/// Encodes and decodes compact share strings for Base Calculator plans.
///
/// Format (version 1):
/// `dac-v1[;dd][;i:code=qty,code=qty][;s:code=qty][;n:encodedName]`
///
/// This is a **Dune Awakening Companion** format. It is not compatible with
/// third-party tools such as TCNO unless they adopt the same schema.
class BaseCalculatorShareCodec {
  static const String prefix = 'dac-v1';

  static String encode(BaseCalculatorPortablePlan plan) {
    final segments = <String>[prefix];
    if (plan.deepDesertDiscountEnabled) {
      segments.add('dd');
    }

    final items = _encodeSegment(plan.itemQuantities);
    if (items.isNotEmpty) {
      segments.add('i:$items');
    }

    final storage = _encodeSegment(plan.storageQuantities);
    if (storage.isNotEmpty) {
      segments.add('s:$storage');
    }

    final trimmedName = plan.name.trim();
    if (trimmedName.isNotEmpty) {
      segments.add('n:${Uri.encodeComponent(trimmedName)}');
    }

    return segments.join(';');
  }

  static BaseCalculatorPortablePlan decode(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Share code is empty');
    }

    final segments = trimmed.split(';');
    if (segments.isEmpty || segments.first != prefix) {
      throw const FormatException('Unsupported share code');
    }

    var deepDesert = false;
    final items = <String, int>{};
    final storage = <String, int>{};
    var name = '';

    for (final segment in segments.skip(1)) {
      if (segment == 'dd') {
        deepDesert = true;
        continue;
      }
      if (segment.startsWith('i:')) {
        items.addAll(_decodeSegment(segment.substring(2), _isKnownItemCode));
        continue;
      }
      if (segment.startsWith('s:')) {
        storage
            .addAll(_decodeSegment(segment.substring(2), _isKnownStorageCode));
        continue;
      }
      if (segment.startsWith('n:')) {
        name = Uri.decodeComponent(segment.substring(2));
        continue;
      }
      throw FormatException('Unknown share segment: $segment');
    }

    final portable = BaseCalculatorPortablePlan(
      name: name,
      deepDesertDiscountEnabled: deepDesert,
      itemQuantities: items,
      storageQuantities: storage,
    );

    if (portable.isEmpty) {
      throw const FormatException('Share code contains no build data');
    }

    return portable;
  }

  static String _encodeSegment(Map<String, int> quantities) {
    final entries = quantities.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries.map((e) => '${e.key}=${e.value}').join(',');
  }

  static Map<String, int> _decodeSegment(
    String raw,
    bool Function(String code) isKnownCode,
  ) {
    if (raw.trim().isEmpty) return const {};
    final out = <String, int>{};
    for (final part in raw.split(',')) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      final separator = trimmed.indexOf('=');
      if (separator <= 0 || separator == trimmed.length - 1) {
        throw FormatException('Invalid quantity entry: $trimmed');
      }
      final code = trimmed.substring(0, separator);
      final qty = int.tryParse(trimmed.substring(separator + 1));
      if (qty == null || qty <= 0) {
        throw FormatException('Invalid quantity for $code');
      }
      if (!isKnownCode(code)) continue;
      out[code] = qty;
    }
    return out;
  }

  static bool _isKnownItemCode(String code) =>
      baseCalculatorCatalogByCode.containsKey(code);

  static bool _isKnownStorageCode(String code) =>
      baseCalculatorStorageOptionsByCode.containsKey(code);
}
