import 'storage_catalog.dart';

/// Aggregated capacity for a set of selected storage options.
///
/// Pure math, mirroring [BaseCalculatorSummary] so it can be unit-tested
/// without Flutter/Riverpod.
class StorageSummary {
  /// Total volume capacity (in "V") across all selected containers.
  final int totalVolumeCapacity;

  /// Total slot capacity across all selected containers (reference only).
  final int totalSlots;

  const StorageSummary({
    required this.totalVolumeCapacity,
    required this.totalSlots,
  });

  /// True when no storage has been configured.
  bool get isEmpty => totalVolumeCapacity == 0;

  /// Compute capacity from a `code -> quantity` selection map. Unknown codes
  /// and non-positive quantities are ignored.
  factory StorageSummary.fromQuantities(Map<String, int> quantities) {
    var volume = 0;
    var slots = 0;
    quantities.forEach((code, qty) {
      if (qty <= 0) return;
      final option = baseCalculatorStorageOptionsByCode[code];
      if (option == null) return;
      volume += option.volumeCapacity * qty;
      slots += option.slotCapacity * qty;
    });
    return StorageSummary(totalVolumeCapacity: volume, totalSlots: slots);
  }
}

/// Number of trips required to haul [materialVolume] given a total
/// [storageCapacity]. Returns `null` when no capacity is configured (the UI
/// shows a "configure storage" hint instead of a number). Returns 0 when there
/// is nothing to haul.
int? tripsNeeded({
  required double materialVolume,
  required int storageCapacity,
}) {
  if (storageCapacity <= 0) return null;
  if (materialVolume <= 0) return 0;
  return (materialVolume / storageCapacity).ceil();
}
