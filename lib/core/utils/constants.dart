class AppConstants {
  // Server types
  static const String serverTypeOfficial = 'Official';
  static const String serverTypePrivate = 'Private';
  static const String serverTypeSelfHosted = 'Self Hosted';
  static const List<String> serverTypes = [
    serverTypeOfficial,
    serverTypePrivate,
    serverTypeSelfHosted,
  ];

  // Private server providers
  static const List<String> privateProviders = [
    'GPORTAL',
    'BisectHosting',
    'xREALM',
    '4NetPlayers',
    'Nitrado',
  ];

  // Self-hosted servers are user-run battlegroups/worlds.
  static const List<String> selfHostedProviders = [
    serverTypeSelfHosted,
  ];

  static bool usesFreeformWorldName(String? serverType) {
    return serverType == serverTypePrivate ||
        serverType == serverTypeSelfHosted;
  }

  static List<String> getProvidersForServerType(String? serverType) {
    if (serverType == serverTypePrivate) return privateProviders;
    if (serverType == serverTypeSelfHosted) return selfHostedProviders;
    return const [];
  }

  // Character classes available from the character generator.
  static const String classBeneGesserit = 'Bene Gesserit';
  static const String classMentat = 'Mentat';
  static const String classSwordmaster = 'Swordmaster';
  static const String classTrooper = 'Trooper';
  static const String classPlanetologist = 'Planetologist';

  static const List<String> primaryClasses = [
    classBeneGesserit,
    classMentat,
    classSwordmaster,
    classTrooper,
  ];

  static const List<String> allProgressionClasses = [
    classBeneGesserit,
    classMentat,
    classPlanetologist,
    classSwordmaster,
    classTrooper,
  ];

  // Dune Awakening Regions and their official Worlds (from dune.gaming.tools)
  static const Map<String, List<String>> regionWorlds = {
    'North America': [
      'Acheron',
      'Alajory',
      'Andioyu',
      'Aramanli',
      'Aren\'s Refuge',
      'Arrakis',
      'Auriga',
      'Beakkal',
      'Bootes',
      'Breaker Station',
      'Broken Stone',
      'Caelum',
      'Canis Major',
      'Carpathia',
      'Cetus',
      'Chains of Karak',
      'Colomba',
      'Crater',
      'Crompton',
      'Dahkotah',
      'Dayside',
      'Dendros',
      'Dewgap',
      'Dis',
      'Duskwraith',
      'Dustpan',
      'Edgeway',
      'Egeria',
      'Equuleus',
      'Eurasia',
      'Fallow Eight',
      'Farhold',
      'Flatrock',
      'Foranis Triad',
      'Freya',
      'Frostholm',
      'Fury',
      'Garrick',
      'Gliese',
      'Greed',
      'Griffin\'s Reach',
      'Hand of Khidr',
      'Harmony',
      'Helius Gate',
      'Hestia',
      'Hollow Arches',
      'House of Fiqh',
      'House of Ilm',
      'Hydra',
      'Hyperbatas',
      'Indara',
      'Ironwatch',
      'Ishtar',
      'Jasper',
      'Junction',
      'Kadrish',
      'Kirana III',
      'Kytheria',
      'Laran',
      'Lernaeus',
      'Limbo',
      'Lorentz',
      'Lust',
      'Mask Prime',
      'Microscopium',
      'Monoceros',
      'Narbog',
      'Nicodemus',
      'Nova',
      'Odin',
      'Old Terra',
      'Orsippus',
      'Pallas',
      'Pellucidar',
      'Phobos',
      'Pinnacle Station',
      'Ponciard',
      'Pyxis',
      'Quarterhouse',
      'Red Maw',
      'Relicon',
      'Riftrun',
      'Rigel',
      'Sagitta',
      'Sandtide',
      'Scorpius',
      'Sculptor',
      'Sentinel City',
      'Serenity',
      'Sextans',
      'Sirius',
      'Solitary',
      'Splinter',
      'Stepstone',
      'Stoneheart',
      'Stygia',
      'Taqwa\'s Watch',
      'Tartarus',
      'The Anomaly',
      'The Anvil',
      'The Crossroads',
      'The Jumble',
      'The Salusan Bull',
      'The Spiral',
      'Themis',
      'Veiled Cleft',
      'Vela',
      'Vowbreaker',
      'Watchway',
      'Windsong',
      'World\'s End',
      'Wormsight',
      'Wrath',
    ],
    'Europe': [
      'Actaeon',
      'Aiglon',
      'Alpha Corvus',
      'Andromeda',
      'Aquarius',
      'Archidamas III',
      'Arkon',
      'Bahamonde',
      'Batigh',
      'Buzzell',
      'Calypso',
      'Canopus',
      'Cassiopeia',
      'Centaurus',
      'Chapterhouse',
      'Circinus',
      'Corona',
      'Corona Borealis',
      'Cycliadas',
      'Daedros',
      'Daxos',
      'Deneb',
      'Dione',
      'Dur',
      'Eluzai',
      'Epsilon Eridani',
      'Eumenes',
      'Faith',
      'Galatia',
      'Gansireed',
      'Ghanima',
      'Grumman',
      'Hagal',
      'Helios',
      'Hicetas',
      'Horologium',
      'Icarus',
      'Indra',
      'Ipyr',
      'Ixalco',
      'Jansine',
      'Juggler',
      'Karna',
      'Khala',
      'Lacerta',
      'Lampadas',
      'Laurrant',
      'Leto',
      'Limos',
      'Lothar',
      'Lynx',
      'Martijoz',
      'Menelaus',
      'Mihna',
      'Molitor',
      'Mycenae',
      'Nereus',
      'Niveus',
      'Numenor',
      'Octans',
      'Orion',
      'Ostara',
      'Oxylon',
      'Pax',
      'Persephone',
      'Phaedra',
      'Pisces',
      'Porthos',
      'Puppis',
      'Quirinus',
      'Remus',
      'Rhea',
      'Richese',
      'Rossak',
      'Salusa Secundus',
      'Saturnia',
      'Selene',
      'Serpens',
      'Shamal',
      'Solaria',
      'Suk Alusus',
      'Summer',
      'Tantalus',
      'Terminus',
      'Thule',
      'Tucana',
      'Volans',
      'Xenophon',
    ],
    'Asia': [
      'Al Dhanab',
      'Bezel II',
      'Bifrost',
      'Corrin',
      'Essen',
      'Foum al-Hout',
      'Ishia',
      'Kolhar',
      'Lepus',
      'Meridian',
      'Nyx',
      'Quadra',
      'Revona',
      'Sparta',
    ],
    'Oceania': [
      'Aerarium IV',
      'Elara',
      'Hunting Dogs',
      'Hyperion',
      'Libra',
      'Megara',
      'Orpheus',
      'Palma',
      'Scutum',
    ],
    'South America': [
      'Balut',
      'Mimosa',
      'Othello',
      'Sharrukin',
    ],
  };

  // Get regions list
  static List<String> get regions => regionWorlds.keys.toList();

  // Get worlds for a specific region
  static List<String> getWorldsForRegion(String region) {
    return regionWorlds[region] ?? [];
  }

  /// Official guide for the server migration, opened from the closed-world
  /// badge so players can read how to transfer their character/base.
  static const String serverMigrationGuideUrl =
      'https://duneawakening.com/news/server-migrations/';

  /// Worlds that closed in the Funcom server migration (live 2026-05-26).
  /// Source of truth: https://duneawakening.com/news/server-migrations/
  /// A character whose [Character.world] matches any of these (see
  /// [isClosedWorld]) is flagged in the UI. Closures are non-destructive:
  /// we never edit or delete the character, only surface a notice.
  static const List<String> migrationClosedWorlds = [
    // Asia
    'Al Dhanab',
    'Bezel II',
    'Bifrost',
    'Essen',
    'Foum al-Hout',
    'Ishia',
    'Kolhar',
    'Lepus',
    'Meridian',
    'Quadra',
    'Revona',
    // Europe
    'Actaeon',
    'Aiglon',
    'Archidamas III',
    'Arkon',
    'Bahamonde',
    'Batigh',
    'Buzzell',
    'Calypso',
    'Centaurus',
    'Chapterhouse',
    'Circinus',
    'Cycliadas',
    'Daedros',
    'Deneb',
    'Dione',
    'Dur',
    'Eumenes',
    'Gansireed',
    'Ghanima',
    'Grumman',
    'Helios',
    'Hicetas',
    'Horologium',
    'Indra',
    'Ipyr',
    'Ixalco',
    'Jansine',
    'Karna',
    'Lacerta',
    'Lampadas',
    'Laurrant',
    'Leto',
    'Lothar',
    'Lynx',
    'Martijoz',
    'Menelaus',
    'Mihna',
    'Molitor',
    'Nereus',
    'Niveus',
    'Numenor',
    'Octans',
    'Orion',
    'Ostara',
    'Persephone',
    'Phaedra',
    'Pisces',
    'Porthos',
    'Remus',
    'Richese',
    'Rossak',
    'Salusa Secundus',
    'Saturnia',
    'Serpens',
    'Shamal',
    'Suk Alusus',
    'Tantalus',
    'Thule',
    'Volans',
    // North America
    'Alajory',
    'Andioyu',
    'Aramanli',
    'Aren\'s Refuge',
    'Auriga',
    'Beakkal',
    'Bootes',
    'Breaker Station',
    'Broken Stone',
    'Caelum',
    'Carpathia',
    'Chains of Karak',
    'Colomba',
    'Crater',
    'Crompton',
    'Dahkotah',
    'Dayside',
    'Dendros',
    'Dewgap',
    'Dis',
    'Duskwraith',
    'Dustpan',
    'Edgeway',
    'Egeria',
    'Equuleus',
    'Eurasia',
    'Fallow Eight',
    'Farhold',
    'Foranis Triad',
    'Freya',
    'Fury',
    'Gliese',
    'Greed',
    'Hand of Khidr',
    'Helius Gate',
    'Hestia',
    'Hollow Arches',
    'House of Fiqh',
    'House of Ilm',
    'Hydra',
    'Hyperbatas',
    'Ironwatch',
    'Jasper',
    'Junction',
    'Kadrish',
    'Kytheria',
    'Laran',
    'Limbo',
    'Lust',
    'Microscopium',
    'Monoceros',
    'Nicodemus',
    'Old Terra',
    'Orsippus',
    'Pallas',
    'Pellucidar',
    'Pinnacle Station',
    'Ponciard',
    'Quarterhouse',
    'Red Maw',
    'Relicon',
    'Riftrun',
    'Rigel',
    'Sagitta',
    'Sandtide',
    'Sculptor',
    'Sentinel City',
    'Serenity',
    'Sextans',
    'Sirius',
    'Stepstone',
    'Stygia',
    'Taqwa\'s Watch',
    'Tartarus',
    'The Anomaly',
    'The Crossroads',
    'The Jumble',
    'Themis',
    'Veiled Cleft',
    'Vela',
    'Vowbreaker',
    'Windsong',
    'World\'s End',
    'Wormsight',
    // Oceania
    'Aerarium IV',
    'Elara',
    'Libra',
    'Megara',
    'Orpheus',
    'Scutum',
    // South America
    'Mimosa',
    'Othello',
    // Legacy in-app spellings of closing worlds (pre-correction) so that
    // characters created before the name fixes are still flagged.
    'Archidadas III', // = Archidamas III
    'Cyclades', // = Cycliadas
    'Lamps', // = Lampadas
    'Laurent', // = Laurrant
    'Octane', // = Octans
    'Serpents', // = Serpens
    'Boots', // = Bootes
    'Fall Eight', // = Fallow Eight
    'Lara', // = Laran
    'Sagittarius', // = Sagitta
    'House of Knowledge', // = House of Ilm
  ];

  // Lower-cased lookup for trim/case-insensitive matching against stored data.
  static final Set<String> _closedWorldsLower = {
    for (final w in migrationClosedWorlds) w.toLowerCase(),
  };

  /// Whether [world] is one of the worlds closed in the server migration.
  /// Matching is trim + case-insensitive so it survives stored-data variance.
  static bool isClosedWorld(String? world) {
    if (world == null) return false;
    return _closedWorldsLower.contains(world.trim().toLowerCase());
  }

  // Alert thresholds (hours before expiration)
  static const List<int> defaultAlertThresholds = [24, 12, 6, 1];

  // Check interval (minutes)
  static const int defaultCheckIntervalMinutes = 1;
}
