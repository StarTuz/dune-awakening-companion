import '../../../core/utils/constants.dart';

class ClassQuestCatalogEntry {
  final String id;
  final String className;
  final String tier;
  final String trainerName;
  final String trainerLocation;
  final String questName;
  final String summary;
  final List<ClassQuestCatalogStep> steps;
  final List<String> prerequisites;
  final String? rewards;
  final String sourceUrl;
  final String? notes;

  const ClassQuestCatalogEntry({
    required this.id,
    required this.className,
    required this.tier,
    required this.trainerName,
    required this.trainerLocation,
    required this.questName,
    required this.summary,
    required this.steps,
    this.prerequisites = const [],
    this.rewards,
    required this.sourceUrl,
    this.notes,
  });

  bool get isBasic => tier == ClassQuestTier.basic;
}

class ClassQuestCatalogStep {
  final String id;
  final String title;
  final String? details;

  const ClassQuestCatalogStep({
    required this.id,
    required this.title,
    this.details,
  });
}

class ClassQuestTier {
  static const basic = 'basic';
  static const advanced = 'advanced';
}

const classQuestCatalog = [
  ClassQuestCatalogEntry(
    id: 'bene-gesserit-basic-missing-pieces',
    className: AppConstants.classBeneGesserit,
    tier: ClassQuestTier.basic,
    trainerName: 'Sister Mesa',
    trainerLocation: 'Helius Gate, Eastern Shield Wall',
    questName: 'The Missing Pieces',
    summary:
        'Find the two requested texts and return them to Sister Mesa to unlock the Bene Gesserit tree.',
    steps: [
      ClassQuestCatalogStep(
        id: 'bene-basic-find-lisan',
        title: "Find the text 'Lisan Al-Gaib and...'",
      ),
      ClassQuestCatalogStep(
        id: 'bene-basic-find-mahid',
        title: "Find the text 'The Mahid's Blade'",
      ),
      ClassQuestCatalogStep(
        id: 'bene-basic-return',
        title: 'Deliver both texts to Sister Mesa',
      ),
    ],
    sourceUrl:
        'https://www.ign.com/wikis/dune-awakening/Bene_Gesserit_Trainer_Locations_and_Quests',
    notes:
        'Useful to track even for experienced players because Helius Gate sits in a tougher Hagga Basin route.',
  ),
  ClassQuestCatalogEntry(
    id: 'bene-gesserit-advanced-chain',
    className: AppConstants.classBeneGesserit,
    tier: ClassQuestTier.advanced,
    trainerName: 'Jocasta',
    trainerLocation: 'Harko Village',
    questName: 'Bene Gesserit Advanced Training',
    summary:
        "Complete Jocasta's advanced chain to unlock deeper Bene Gesserit upgrades and capstone progression.",
    steps: [
      ClassQuestCatalogStep(id: 'bene-adv-sacred', title: 'Sacred Records'),
      ClassQuestCatalogStep(
        id: 'bene-adv-missionaria',
        title: 'The Missionaria Protectiva',
      ),
      ClassQuestCatalogStep(
        id: 'bene-adv-ecology',
        title: 'The Impact of Ecology',
      ),
      ClassQuestCatalogStep(
        id: 'bene-adv-syndicate',
        title: 'Secrets of the Syndicate',
        details:
            'Reported as bug-prone in current guide notes; retry later if target NPCs fail to spawn.',
      ),
      ClassQuestCatalogStep(
        id: 'bene-adv-rogue',
        title: 'The Rogue Bene Gesserit',
      ),
    ],
    prerequisites: ['Bene Gesserit tree unlocked'],
    sourceUrl:
        'https://www.ign.com/wikis/dune-awakening/Bene_Gesserit_Trainer_Locations_and_Quests',
  ),
  ClassQuestCatalogEntry(
    id: 'mentat-basic-first-blood',
    className: AppConstants.classMentat,
    tier: ClassQuestTier.basic,
    trainerName: 'Samin Moro',
    trainerLocation: 'Riftwatch, Hagga Rift',
    questName: 'First Blood',
    summary:
        'Bring the requested materials to Samin Moro to unlock the Mentat tree.',
    steps: [
      ClassQuestCatalogStep(
        id: 'mentat-basic-travel',
        title: 'Find Samin Moro at Riftwatch',
      ),
      ClassQuestCatalogStep(
        id: 'mentat-basic-fiber',
        title: 'Bring 100 Plant Fibre',
      ),
      ClassQuestCatalogStep(
        id: 'mentat-basic-ore',
        title: 'Bring 40 Iron Ore',
      ),
      ClassQuestCatalogStep(
        id: 'mentat-basic-turn-in',
        title: 'Turn in materials to unlock Mentat',
      ),
    ],
    prerequisites: ['100 Plant Fibre', '40 Iron Ore'],
    sourceUrl:
        'https://www.method.gg/dune-awakening/mentat-advanced-trainer-quest-guide-for-dune-awakening',
  ),
  ClassQuestCatalogEntry(
    id: 'mentat-advanced-chain',
    className: AppConstants.classMentat,
    tier: ClassQuestTier.advanced,
    trainerName: 'Mentat Advanced Trainer',
    trainerLocation: 'Arrakeen, downstairs bar area',
    questName: 'Mentat Advanced Training',
    summary:
        'Progress through interrogations, sabotage, and investigation steps to deepen Mentat training.',
    steps: [
      ClassQuestCatalogStep(
        id: 'mentat-adv-calamity',
        title: 'Calculated Calamity',
      ),
      ClassQuestCatalogStep(
        id: 'mentat-adv-sabotage',
        title: 'Complete sabotage objectives',
      ),
      ClassQuestCatalogStep(
        id: 'mentat-adv-questions',
        title: 'Untwisted Questions',
      ),
    ],
    prerequisites: ['Mentat tree unlocked'],
    sourceUrl:
        'https://www.method.gg/dune-awakening/mentat-advanced-trainer-quest-guide-for-dune-awakening',
  ),
  ClassQuestCatalogEntry(
    id: 'trooper-basic-proving-grounds',
    className: AppConstants.classTrooper,
    tier: ClassQuestTier.basic,
    trainerName: 'Ghavouri',
    trainerLocation: "Griffin's Reach Tradepost",
    questName: 'Proving Grounds',
    summary:
        "Complete Ghavouri's assassination assignments to unlock the Trooper tree.",
    steps: [
      ClassQuestCatalogStep(
        id: 'trooper-basic-ghavouri',
        title: 'Speak with Ghavouri',
      ),
      ClassQuestCatalogStep(
        id: 'trooper-basic-targets',
        title: 'Assassinate the assigned targets',
      ),
      ClassQuestCatalogStep(
        id: 'trooper-basic-return',
        title: 'Return to Ghavouri',
      ),
    ],
    sourceUrl:
        'https://www.method.gg/dune-awakening/trooper-advanced-trainer-quest-guide-for-dune-awakening',
  ),
  ClassQuestCatalogEntry(
    id: 'trooper-advanced-chain',
    className: AppConstants.classTrooper,
    tier: ClassQuestTier.advanced,
    trainerName: 'Kara',
    trainerLocation: 'Arrakeen, second floor inner market',
    questName: 'Trooper Advanced Training',
    summary:
        "Follow Kara's chain through Harko, The Sweep, Khidr's Shadow, and the final Kara Valk confrontation.",
    steps: [
      ClassQuestCatalogStep(
          id: 'trooper-adv-seeking', title: 'Seeking Control'),
      ClassQuestCatalogStep(
        id: 'trooper-adv-regaining',
        title: 'Regaining Control',
      ),
      ClassQuestCatalogStep(
        id: 'trooper-adv-improving',
        title: 'A Shot at Improving',
      ),
      ClassQuestCatalogStep(
        id: 'trooper-adv-master',
        title: 'Master of Weapons',
        details:
            'Requires Assault Seeker, Attractor Field, Gravity Field, and roughly 12 invested Trooper points.',
      ),
      ClassQuestCatalogStep(
        id: 'trooper-adv-surgical',
        title: 'Surgical Strike',
      ),
      ClassQuestCatalogStep(
        id: 'trooper-adv-cleansing',
        title: 'The Cleansing of Kara Valk',
      ),
    ],
    prerequisites: ['Trooper tree unlocked', 'Approx. 12 Trooper skill points'],
    rewards: 'Unique burst rifle and Trooper Archetype armor variant',
    sourceUrl:
        'https://www.method.gg/dune-awakening/trooper-advanced-trainer-quest-guide-for-dune-awakening',
  ),
  ClassQuestCatalogEntry(
    id: 'swordmaster-basic-checking-post',
    className: AppConstants.classSwordmaster,
    tier: ClassQuestTier.basic,
    trainerName: 'Arno',
    trainerLocation: 'Pinnacle Station Tradepost',
    questName: 'Checking the Post',
    summary: "Complete Arno's basic assignment to unlock the Swordmaster tree.",
    steps: [
      ClassQuestCatalogStep(
        id: 'sword-basic-arno',
        title: 'Speak with Arno at Pinnacle Station',
      ),
      ClassQuestCatalogStep(
        id: 'sword-basic-post',
        title: 'Check the assigned post',
      ),
      ClassQuestCatalogStep(
        id: 'sword-basic-turn-in',
        title: 'Return to complete the basic unlock',
      ),
    ],
    sourceUrl:
        'https://www.method.gg/dune-awakening/swordmaster-advanced-trainer-quest-guide-for-dune-awakening',
  ),
  ClassQuestCatalogEntry(
    id: 'swordmaster-advanced-chain',
    className: AppConstants.classSwordmaster,
    tier: ClassQuestTier.advanced,
    trainerName: 'Seron',
    trainerLocation: 'Harko Village, back/top area',
    questName: 'Swordmaster Advanced Training',
    summary:
        "Complete Seron's advanced chain to unlock deeper Swordmaster techniques and rewards.",
    steps: [
      ClassQuestCatalogStep(
        id: 'sword-adv-tormented',
        title: 'A Tormented Soul',
      ),
      ClassQuestCatalogStep(id: 'sword-adv-piercing', title: 'Piercing Eyes'),
      ClassQuestCatalogStep(
        id: 'sword-adv-art',
        title: 'Art of the Sword',
        details:
            'Requires Knee Charge, Eye of the Storm, Crippling Strike, and roughly 9 invested Swordmaster points.',
      ),
      ClassQuestCatalogStep(
        id: 'sword-adv-forged',
        title: 'Forged in Dishonor',
      ),
      ClassQuestCatalogStep(
        id: 'sword-adv-last-stand',
        title: 'The Last Stand of Saron Varlin',
      ),
    ],
    prerequisites: [
      'Swordmaster tree unlocked',
      'Approx. 9 Swordmaster skill points',
    ],
    rewards: 'Unique Jolt-sword and Swordmaster Archetype armor variant',
    sourceUrl:
        'https://www.method.gg/dune-awakening/swordmaster-advanced-trainer-quest-guide-for-dune-awakening',
  ),
  ClassQuestCatalogEntry(
    id: 'planetologist-basic-minimic-film',
    className: AppConstants.classPlanetologist,
    tier: ClassQuestTier.basic,
    trainerName: 'Derek Chinara',
    trainerLocation: 'Hagga Basin South cliff camp',
    questName: 'Minimic Film Recovery',
    summary:
        'Find Derek, recover the Minimic Film from Imperial Testing Station No. 2, and return to unlock Planetologist.',
    steps: [
      ClassQuestCatalogStep(
        id: 'planet-basic-find-derek',
        title: 'Find Derek Chinara above Imperial Testing Station No. 2',
        details:
            'His Hagga Basin South camp is easy to miss, so mark the location before starting the chain.',
      ),
      ClassQuestCatalogStep(
        id: 'planet-basic-secret-room',
        title: 'Open the hidden room in Imperial Testing Station No. 2',
        details:
            'Look for the glowing vertical yellow line behind a bookshelf and interact with it.',
      ),
      ClassQuestCatalogStep(
        id: 'planet-basic-film',
        title: 'Loot the Minimic Film from the hidden chamber',
      ),
      ClassQuestCatalogStep(
        id: 'planet-basic-return',
        title: 'Return to Derek to unlock Planetologist level 1',
      ),
    ],
    sourceUrl:
        'https://www.ign.com/wikis/dune-awakening/Planetologist_Trainer_Locations_and_Quests',
    notes:
        'Planetologist cannot be selected as a starting class, so this basic unlock is always relevant.',
  ),
  ClassQuestCatalogEntry(
    id: 'planetologist-advanced-route',
    className: AppConstants.classPlanetologist,
    tier: ClassQuestTier.advanced,
    trainerName: 'Derek Chinara',
    trainerLocation: 'Hagga Basin South cliff camp',
    questName: 'Planetologist Advanced Route',
    summary:
        "Follow Derek's notes, maps, and follow-up objectives through the Imperial Testing Station chain.",
    steps: [
      ClassQuestCatalogStep(
        id: 'planet-adv-station-197',
        title: 'Imperial Testing Station No. 197 - Vermillius Gap',
        details:
            'Find Derek at the bottom of the circular pit, survive the locked-room combat gauntlet, recover the data, and return it to unlock level 2.',
      ),
      ClassQuestCatalogStep(
        id: 'planet-adv-arrakeen-ciprian',
        title: 'Adhering to Hierarchy - visit Ciprian in Arrakeen',
        details:
            'Head to the bar in Arrakeen, speak with Ciprian in the back corner, then return to Derek at camp.',
      ),
      ClassQuestCatalogStep(
        id: 'planet-adv-station-76',
        title: 'Imperial Testing Station No. 76 - Jabal Eifrit Al-Janub',
        details:
            'Recover the keys hidden in a book downstairs, find the Minimic Film behind the false bookshelf, and rescue Derek to unlock level 3.',
      ),
      ClassQuestCatalogStep(
        id: 'planet-adv-thufir-sietch-tabr',
        title: 'Mission to Thufir - Arrakeen to Sietch Tabr',
        details:
            "Speak with Thufir Hawat, travel to the edge of O'odham near Sietch Tabr, retrieve the item from the crumbling ruins, and return to Derek.",
      ),
      ClassQuestCatalogStep(
        id: 'planet-adv-station-29',
        title: 'Imperial Testing Station No. 29 - Hagga Rift',
        details:
            'Use the purple identification band route, find the false bookshelf, recover the Minimic Film, and unlock the Spice Surveyor capstone.',
      ),
      ClassQuestCatalogStep(
        id: 'planet-adv-station-71',
        title: "Imperial Testing Station No. 71 - O'odham Region",
        details:
            'Watch for the blue identification band, recover the hidden data, and collect the side-chamber notes to unlock the second capstone.',
      ),
      ClassQuestCatalogStep(
        id: 'planet-adv-betrayal-arrakeen',
        title: 'Betrayal at Arrakeen',
        details:
            "Deliver Derek's report to Ciprian, return to Hagga Basin South, defeat two sniper waves, and loot Derek's notes.",
      ),
      ClassQuestCatalogStep(
        id: 'planet-adv-station-163',
        title: 'Imperial Testing Station No. 163 - final dungeon',
        details:
            'Reach the final chamber, recover the holographic recording, and return it to Derek to complete the route.',
      ),
    ],
    prerequisites: ['Planetologist tree unlocked'],
    rewards: 'Unlocks full Planetologist progression and related rewards',
    sourceUrl:
        'https://www.mmopixel.com/news/dune-awakening-planetologist-skill-guide',
    notes:
        'This route is intentionally step-by-step because Derek can be difficult to find and several station objectives are hidden behind false bookshelves or easy-to-miss clues.',
  ),
];
