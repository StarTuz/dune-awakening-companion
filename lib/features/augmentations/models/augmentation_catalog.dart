class AugmentationCatalogEntry {
  final String name;
  final String slot;
  final int tier;
  final String rarity;
  final String sourceGroup;
  final String sourceLabel;

  const AugmentationCatalogEntry({
    required this.name,
    required this.slot,
    required this.tier,
    this.rarity = 'Unique',
    this.sourceGroup = 'Deep Desert',
    this.sourceLabel = 'Deep Desert Tier 6 unique pool',
  });
}

const augmentationCatalog = [
  AugmentationCatalogEntry(
      name: 'Aggressive Grip Adjuster', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(name: 'Barrel Extender', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Blade Blood Grooves', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(name: 'Blade Flexi-Coating', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(name: 'Blade Grip Adjuster', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(name: 'Blade Optimizer', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(name: 'Blade Sharpener', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(
      name: 'Blade-warding Weave', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(name: 'Capacity Expander', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Concussive Dampening', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Concussive Redirection', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Curative-infused Padding', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Dart-proof Latticing', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Defensive Grip Adjuster', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(
      name: 'Desert-tested Weave', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Detoxifying Fabrics', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(name: 'Disruptive Coating', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Disruptor M11 Amplifier', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Disruptor M11 Heavy Kit', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Disruptor M11 Personnel-Buster', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Disruptor M11 Precision Tuning', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Disruptor M11 Quickloader', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Disruptor M11 Shield Breaker', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Disruptor M11 Sprayer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Drillshot FK7 Amplifier', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Drillshot FK7 Optimizer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Drillshot FK7 Quickloader', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Drillshot FK7 Spray-and-Pray', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Drillshot FK7 Sprayer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Drillshot FK7 Tactical Adjuster', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Edge Optimizer', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(
      name: 'Energy Dispersing Padding', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Energy Resistant Weave', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Flame-resistant Fabrics', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Flamethrower Amplifier', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Flamethrower Decimator', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Flamethrower Nozzle Extension', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Flamethrower Quickloader', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Flamethrower Superheater', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Garment Reinforcement', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(name: 'GRDA 44 Amplifier', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'GRDA 44 Expander', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'GRDA 44 Micro-Rigidity Coating', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'GRDA 44 Optimizer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'GRDA 44 Sprayer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'GRDA 44 Tactical Amplifier', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Heavy Blade Adjuster', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(
      name: 'Heavy Caliber Upgrade', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Heavy Metal Blade Coating', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(
      name: 'JABAL Spitdart Amplifier', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'JABAL Spitdart Disruptive Coating', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'JABAL Spitdart Expander', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'JABAL Spitdart Range Adjuster', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'JABAL Spitdart Ranger', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'JABAL Spitdart Tactical Enhancer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'JABAL Spitdart Toxicity Amplifier', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Karpov 38 Dart Sprayer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Karpov 38 Focuser', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Karpov 38 Heavy Kit', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Karpov 38 Precision Kit', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Karpov 38 Pressurizer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Karpov 38 Sniper Barrel', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Lasgun Amplifier', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Lasgun Concentrator', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Lasgun Extender', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Lasgun Focuser', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Lasgun Harmonizer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Lightweight Adjuster', slot: 'Melee', tier: 6),
  AugmentationCatalogEntry(
      name: 'Maula Pistol Antipersonnel Rounds', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Maula Pistol Barrel Extender', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Maula Pistol Disruptive Coating', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Maula Pistol Expander', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Maula Pistol Sprayer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Maula Pistol Tactical Enhancer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Missile Launcher Disruptive Coating', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Missile Launcher Fragmenter', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Missile Launcher Heavy Payload', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Missile Launcher Obliterator', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Missile Launcher Quickloader', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Penetrative Reinforcement', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Precision Barrel Adjuster', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Protective Coating', slot: 'Generic', tier: 6),
  AugmentationCatalogEntry(name: 'Pyrocket Decimator', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Pyrocket Quickloader', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Pyrocket Supercharger', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Quick-release Trigger', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Quickloader', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Radiation Absorbing Fabrics', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Radiation Shielded Latticing', slot: 'Garment', tier: 6),
  AugmentationCatalogEntry(
      name: 'Rafiq Snubnose Disruptive Coating', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Rafiq Snubnose Expander', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Rafiq Snubnose Heavy Kit', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Rafiq Snubnose Marksman', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Rafiq Snubnose Quickdraw Assembly', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Rafiq Snubnose Sprayer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Recoil Adjuster', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Scattergun Rampage-Enhancement', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(name: 'Tactical Enhancer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'VULCAN GAU-92 Accelerator', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'VULCAN GAU-92 Disruptive Coating', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'VULCAN GAU-92 Expander', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'VULCAN GAU-92 Focuser', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'VULCAN GAU-92 Sprayer', slot: 'Ranged', tier: 6),
  AugmentationCatalogEntry(
      name: 'Woven Reinforcement', slot: 'Garment', tier: 6),
];

List<String> augmentationCatalogSlots() {
  final seen = <String>{};
  return [
    for (final entry in augmentationCatalog)
      if (seen.add(entry.slot)) entry.slot,
  ];
}
