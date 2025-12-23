class AppConstants {
  // Server types
  static const String serverTypeOfficial = 'Official';
  static const String serverTypePrivate = 'Private';
  static const List<String> serverTypes = [serverTypeOfficial, serverTypePrivate];
  
  // Private server providers
  static const List<String> privateProviders = [
    'GPORTAL',
    'BisectHosting',
    'xREALM',
    '4NetPlayers',
    'Nitrado',
  ];
  
  // Dune Awakening Regions and their official Worlds (from dune.gaming.tools)
  static const Map<String, List<String>> regionWorlds = {
    'North America': [
      'Acheron', 'Alajory', 'Andioyu', 'Aramanli', 'Aren\'s Refuge', 'Arrakis',
      'Auriga', 'Beakkal', 'Boots', 'Breaker Station', 'Broken Stone', 'Caelum',
      'Canis Major', 'Carpathia', 'Cetus', 'Chains of Karak', 'Colomba', 'Crater',
      'Crompton', 'Dahkotah', 'Dayside', 'Dendros', 'Dewgap', 'Dis', 'Duskwraith',
      'Dustpan', 'Edgeway', 'Egeria', 'Equuleus', 'Eurasia', 'Fall Eight', 'Farhold',
      'Flatrock', 'Foranis Triad', 'Freya', 'Frostholm', 'Fury', 'Garrick', 'Gliese',
      'Greed', 'Griffin\'s Reach', 'Hand of Khidr', 'Harmony', 'Helius Gate', 'Hestia',
      'Hollow Arches', 'House of Fiqh', 'House of Knowledge', 'Hydra', 'Hyperbatas',
      'Indara', 'Ironwatch', 'Ishtar', 'Jasper', 'Junction', 'Kadrish', 'Kirana III',
      'Kytheria', 'Lara', 'Lernaeus', 'Limbo', 'Lorentz', 'Lust', 'Mask Prime',
      'Microscopium', 'Monoceros', 'Narbog', 'Nicodemus', 'Nova', 'Odin', 'Old Terra',
      'Orsippus', 'Pallas', 'Pellucidar', 'Phobos', 'Pinnacle Station', 'Ponciard',
      'Pyxis', 'Quarterhouse', 'Red Maw', 'Relicon', 'Riftrun', 'Rigel', 'Sagittarius',
      'Sandtide', 'Scorpius', 'Sculptor', 'Sentinel City', 'Serenity', 'Sextans',
      'Sirius', 'Solitary', 'Splinter', 'Stepstone', 'Stoneheart', 'Stygia',
      'Taqwa\'s Watch', 'Tartarus', 'The Anomaly', 'The Anvil', 'The Crossroads',
      'The Jumble', 'The Salusan Bull', 'The Spiral', 'Themis', 'Veiled Cleft',
      'Vela', 'Vowbreaker', 'Watchway', 'Windsong', 'World\'s End', 'Wormsight', 'Wrath',
    ],
    'Europe': [
      'Actaeon', 'Aiglon', 'Alpha Corvus', 'Andromeda', 'Aquarius', 'Archidadas III',
      'Arkon', 'Bahamonde', 'Batigh', 'Buzzell', 'Calypso', 'Canopus', 'Cassiopeia',
      'Centaurus', 'Chapterhouse', 'Circinus', 'Corona', 'Corona Borealis', 'Cyclades',
      'Daedros', 'Daxos', 'Deneb', 'Dione', 'Dur', 'Eluzai', 'Epsilon Eridani',
      'Eumenes', 'Faith', 'Galatia', 'Gansireed', 'Ghanima', 'Grumman', 'Hagal',
      'Helios', 'Hicetas', 'Horologium', 'Icarus', 'Indra', 'Ipyr', 'Ixalco',
      'Jansine', 'Juggler', 'Karna', 'Khala', 'Lacerta', 'Lamps', 'Laurent',
      'Limos', 'Lothar', 'Lynx', 'Martijoz', 'Menelaus', 'Mihna', 'Molitor',
      'Mycenae', 'Nereus', 'Niveus', 'Numenor', 'Octane', 'Orion', 'Ostara',
      'Oxylon', 'Pax', 'Persephone', 'Phaedra', 'Pisces', 'Porthos', 'Puppis',
      'Quirinus', 'Remus', 'Rhea', 'Richese', 'Rossak', 'Salusa Secundus',
      'Saturnia', 'Selene', 'Serpents', 'Shamal', 'Solaria', 'Suk Alusus',
      'Summer', 'Tantalus', 'Terminus', 'Thule', 'Tucana', 'Volans', 'Xenophon',
    ],
    'Asia': [
      'Al Dhanab', 'Bezel II', 'Bifrost', 'Corrin', 'Essen', 'Foum al-Hout',
      'Ishia', 'Kolhar', 'Lepus', 'Meridian', 'Nyx', 'Quadra', 'Revona', 'Sparta',
    ],
    'Oceania': [
      'Aerarium IV', 'Elara', 'Hunting Dogs', 'Hyperion', 'Libra', 'Megara',
      'Orpheus', 'Palma', 'Scutum',
    ],
    'South America': [
      'Balut', 'Mimosa', 'Othello', 'Sharrukin',
    ],
  };
  
  // Get regions list
  static List<String> get regions => regionWorlds.keys.toList();
  
  // Get worlds for a specific region
  static List<String> getWorldsForRegion(String region) {
    return regionWorlds[region] ?? [];
  }
  
  // Alert thresholds (hours before expiration)
  static const List<int> defaultAlertThresholds = [24, 12, 6, 1];
  
  // Check interval (minutes)
  static const int defaultCheckIntervalMinutes = 1;
}
