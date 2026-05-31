/// A container/vehicle the player can use to haul materials.
///
/// `volumeCapacity` is the inventory volume (in "V") the option holds;
/// `slotCapacity` is the number of distinct stacks it can hold (currently shown
/// for reference — trip math is volume-based in Phase 2).
class StorageOption {
  final String code;
  final String name;
  final int volumeCapacity;
  final int slotCapacity;

  const StorageOption({
    required this.code,
    required this.name,
    required this.volumeCapacity,
    required this.slotCapacity,
  });
}
