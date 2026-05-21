# Character Skills and Class Quests Research

Last updated: 2026-05-20

## Summary

Dune: Awakening character progression is built around five class paths: Bene Gesserit, Mentat, Planetologist, Swordmaster, and Trooper. Each class has three skill trees, for 15 skill trees total, and published guide data reports 108 skills with a 200 skill point cap [Game8](https://game8.co/games/Dune-Awakening/archives/524020).

Players can learn outside their starting class by finding class trainers across Arrakis. Basic trainer quests unlock a class tree, while advanced trainers and quest chains unlock deeper progression [Method](https://www.method.gg/dune-awakening/dune-awakening-all-trainer-locations-how-to-unlock-each-secondary-class-fast). Skills include abilities, passives, and techniques; active abilities must be equipped on the ability bar [Fextralife](https://duneawakening.wiki.fextralife.com/Skill+Trees).

## Starting Class Rule

The character generator supports Bene Gesserit, Mentat, Swordmaster, and Trooper as starting classes. Planetologist is reported as secondary-only [Game8](https://game8.co/games/Dune-Awakening/archives/524020).

If a character starts as a class, that class should not require its basic unlock quest. Trooper and Swordmaster guides explicitly state that starting as that class skips the basic quest and proceeds to quest 2 [Trooper Method Guide](https://www.method.gg/dune-awakening/trooper-advanced-trainer-quest-guide-for-dune-awakening), [Swordmaster Method Guide](https://www.method.gg/dune-awakening/swordmaster-advanced-trainer-quest-guide-for-dune-awakening). Mentat guidance uses the same conditional framing: if the player did not start with Mentat, they should complete the basic unlock path [Mentat Method Guide](https://www.method.gg/dune-awakening/mentat-advanced-trainer-quest-guide-for-dune-awakening).

## Implemented First Slice

- Characters now store an optional starting class.
- Planetologist is excluded from starting class choices.
- Character Progress now includes a Skills tab.
- The Skills tab currently focuses on Class Quests, not full skill-rank planning.
- Basic unlock quests for the starting class are shown as not required.
- Planetologist remains a normal tracked unlock path for every character.

## Seeded Quest Coverage

- Bene Gesserit basic unlock uses Sister Mesa at Helius Gate / Eastern Shield Wall and the quest "The Missing Pieces" [IGN](https://www.ign.com/wikis/dune-awakening/Bene_Gesserit_Trainer_Locations_and_Quests).
- Mentat basic unlock uses Samin Moro at Riftwatch and the quest "First Blood", including material preparation [Method](https://www.method.gg/dune-awakening/mentat-advanced-trainer-quest-guide-for-dune-awakening).
- Trooper basic unlock uses Ghavouri at Griffin's Reach Tradepost and the quest "Proving Grounds" [Method](https://www.method.gg/dune-awakening/trooper-advanced-trainer-quest-guide-for-dune-awakening).
- Swordmaster basic unlock uses Arno at Pinnacle Station and the quest "Checking the Post" [Method](https://www.method.gg/dune-awakening/swordmaster-advanced-trainer-quest-guide-for-dune-awakening).
- Planetologist basic unlock uses Derek Chinara and "Minimic Film Recovery"; Derek moves across Arrakis during the broader chain, with camp clues and maps guiding the next destination [IGN](https://www.ign.com/wikis/dune-awakening/Planetologist_Trainer_Locations_and_Quests).

## Product Direction

Class quests should stay coupled to skills because trainer quests explain why trees are locked, why advanced progression is gated, and which skills must be learned before certain quest steps. Full build planning should follow this foundation with seeded skill nodes, current rank, desired rank, equipped abilities, and point budget validation.

## Sources

- [All Skill Trees | Dune: Awakening - Game8](https://game8.co/games/Dune-Awakening/archives/524020)
- [Skill Trees | Dune Awakening Wiki](https://duneawakening.wiki.fextralife.com/Skill+Trees)
- [Dune Awakening Trainer Locations - Method](https://www.method.gg/dune-awakening/dune-awakening-all-trainer-locations-how-to-unlock-each-secondary-class-fast)
- [Bene Gesserit Trainer Locations and Quests - IGN](https://www.ign.com/wikis/dune-awakening/Bene_Gesserit_Trainer_Locations_and_Quests)
- [Planetologist Trainer Locations and Quests - IGN](https://www.ign.com/wikis/dune-awakening/Planetologist_Trainer_Locations_and_Quests)
- [Trooper Advanced Trainer Quest Guide - Method](https://www.method.gg/dune-awakening/trooper-advanced-trainer-quest-guide-for-dune-awakening)
- [Swordmaster Advanced Trainer Quest Guide - Method](https://www.method.gg/dune-awakening/swordmaster-advanced-trainer-quest-guide-for-dune-awakening)
- [Mentat Advanced Trainer Quest Guide - Method](https://www.method.gg/dune-awakening/mentat-advanced-trainer-quest-guide-for-dune-awakening)
