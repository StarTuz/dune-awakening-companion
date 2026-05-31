import 'storage_option.dart';

/// Storage/transport options for trip planning (Phase 2).
///
/// SOURCE & ACCURACY
/// -----------------
/// Volumes and slot counts transcribed from the DuneCalc base calculator
/// "Storage Configuration" panel in 2026-05 (see
/// `docs/RESEARCH_BASE_CALCULATOR.md`). Treat as "verify in-game".
///
/// Ordered roughly by capacity so the smallest, most universally available
/// option (player inventory) appears first.
const List<StorageOption> baseCalculatorStorageOptions = [
  StorageOption(
    code: 'player_inventory',
    name: 'Player (Inventory)',
    volumeCapacity: 175,
    slotCapacity: 35,
  ),
  StorageOption(
    code: 'sandbike_inventory_mk1',
    name: 'Sandbike Inventory Mk1',
    volumeCapacity: 250,
    slotCapacity: 15,
  ),
  StorageOption(
    code: 'sandbike_inventory_mk2',
    name: 'Sandbike Inventory Mk2',
    volumeCapacity: 250,
    slotCapacity: 15,
  ),
  StorageOption(
    code: 'scout_ornithopter_storage_mk4',
    name: 'Scout Ornithopter Storage Mk4',
    volumeCapacity: 500,
    slotCapacity: 10,
  ),
  StorageOption(
    code: 'buggy_storage_mk3',
    name: 'Buggy Storage Mk3',
    volumeCapacity: 1500,
    slotCapacity: 20,
  ),
  StorageOption(
    code: 'bigger_buggy_boot_mk3',
    name: 'Bigger Buggy Boot Mk3',
    volumeCapacity: 1750,
    slotCapacity: 20,
  ),
  StorageOption(
    code: 'assault_ornithopter_storage_mk5',
    name: 'Assault Ornithopter Storage Mk5',
    volumeCapacity: 2000,
    slotCapacity: 20,
  ),
  StorageOption(
    code: 'buggy_storage_mk4',
    name: 'Buggy Storage Mk4',
    volumeCapacity: 2000,
    slotCapacity: 20,
  ),
  StorageOption(
    code: 'bigger_buggy_boot_mk4',
    name: 'Bigger Buggy Boot Mk4',
    volumeCapacity: 2250,
    slotCapacity: 25,
  ),
  StorageOption(
    code: 'buggy_storage_mk5',
    name: 'Buggy Storage Mk5',
    volumeCapacity: 2500,
    slotCapacity: 20,
  ),
  StorageOption(
    code: 'bigger_buggy_boot_mk5',
    name: 'Bigger Buggy Boot Mk5',
    volumeCapacity: 2750,
    slotCapacity: 30,
  ),
  StorageOption(
    code: 'buggy_storage_mk6',
    name: 'Buggy Storage Mk6',
    volumeCapacity: 3000,
    slotCapacity: 20,
  ),
  StorageOption(
    code: 'bigger_buggy_boot_mk6',
    name: 'Bigger Buggy Boot Mk6',
    volumeCapacity: 3500,
    slotCapacity: 35,
  ),
  StorageOption(
    code: 'sandcrawler_centrifuge_mk6',
    name: 'Sandcrawler Centrifuge Mk6',
    volumeCapacity: 7500,
    slotCapacity: 20,
  ),
  StorageOption(
    code: 'regis_spice_container',
    name: 'Regis Spice Container',
    volumeCapacity: 11250,
    slotCapacity: 30,
  ),
];

/// Storage options indexed by code for O(1) lookups from selection state.
final Map<String, StorageOption> baseCalculatorStorageOptionsByCode = {
  for (final option in baseCalculatorStorageOptions) option.code: option,
};
