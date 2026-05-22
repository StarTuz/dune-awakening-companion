import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/core/utils/constants.dart';
import 'package:dune_awakening_companion/features/skills/models/skill_catalog.dart';

/// Canonical class/skill list, sourced from the Fextralife Dune Awakening wiki:
/// https://duneawakening.wiki.fextralife.com/Skill+Trees
///
/// Wiki types:
///   Ability   — equipped & activated from the ability bar  → catalog 'active'
///   Passive   — always-on                                   → catalog 'passive'
///   Technique — only takes effect when equipped             → catalog 'technique'
///
/// If the wiki adds/renames skills, update this table — it is the source of
/// truth that the in-app catalog must match.
enum _CanonType { ability, passive, technique }

String _expectedCatalogType(_CanonType t) {
  switch (t) {
    case _CanonType.ability:
      return 'active';
    case _CanonType.passive:
      return 'passive';
    case _CanonType.technique:
      return 'technique';
  }
}

class _CanonSkill {
  final String name;
  final _CanonType type;
  final String tree;
  const _CanonSkill(this.name, this.type, this.tree);
}

/// Sub-tree groupings from
/// https://www.pcgamesn.com/dune-awakening/skills. Every class has exactly
/// three sub-trees; every skill belongs to exactly one.
const Map<String, List<_CanonSkill>> _canon = {
  'Bene Gesserit': [
    // Weirding Way
    _CanonSkill('Bindu Dodge', _CanonType.passive, 'Weirding Way'),
    _CanonSkill('Bindu Sprint', _CanonType.ability, 'Weirding Way'),
    _CanonSkill('Blade Damage', _CanonType.passive, 'Weirding Way'),
    _CanonSkill('Manipulate Instability', _CanonType.technique, 'Weirding Way'),
    _CanonSkill('Prana-Bindu Strikes', _CanonType.ability, 'Weirding Way'),
    _CanonSkill('Short Blade Damage', _CanonType.passive, 'Weirding Way'),
    _CanonSkill('Weirding Step', _CanonType.ability, 'Weirding Way'),
    // The Voice
    _CanonSkill('Compel', _CanonType.ability, 'The Voice'),
    _CanonSkill('Ignore', _CanonType.ability, 'The Voice'),
    _CanonSkill('Rapid Register', _CanonType.technique, 'The Voice'),
    _CanonSkill('Screech', _CanonType.passive, 'The Voice'),
    _CanonSkill('Stop', _CanonType.ability, 'The Voice'),
    _CanonSkill('Voice Training', _CanonType.passive, 'The Voice'),
    // Body Control
    _CanonSkill('Litany Against Fear', _CanonType.ability, 'Body Control'),
    _CanonSkill('Metabolize Poison', _CanonType.technique, 'Body Control'),
    _CanonSkill('Poison Tolerance', _CanonType.passive, 'Body Control'),
    _CanonSkill('Prana-Bindu Stability', _CanonType.technique, 'Body Control'),
    _CanonSkill('Recovery', _CanonType.passive, 'Body Control'),
    _CanonSkill('Self-Healing', _CanonType.passive, 'Body Control'),
    _CanonSkill('Sun Tolerance', _CanonType.passive, 'Body Control'),
    _CanonSkill('Trauma Recovery', _CanonType.technique, 'Body Control'),
    _CanonSkill('Vitality', _CanonType.passive, 'Body Control'),
  ],
  'Mentat': [
    // Mental Calculus
    _CanonSkill('Exploit Weakness', _CanonType.technique, 'Mental Calculus'),
    _CanonSkill('Garment Keeper', _CanonType.passive, 'Mental Calculus'),
    _CanonSkill('Marksman', _CanonType.technique, 'Mental Calculus'),
    _CanonSkill('Pistol Damage', _CanonType.passive, 'Mental Calculus'),
    _CanonSkill('Ranged Damage', _CanonType.passive, 'Mental Calculus'),
    _CanonSkill('Rifle Damage', _CanonType.passive, 'Mental Calculus'),
    _CanonSkill('Shield Overcharge', _CanonType.passive, 'Mental Calculus'),
    _CanonSkill('Tailoring', _CanonType.passive, 'Mental Calculus'),
    _CanonSkill('The Sentinel', _CanonType.ability, 'Mental Calculus'),
    // Assassination
    _CanonSkill("Assassin's Shot", _CanonType.passive, 'Assassination'),
    _CanonSkill('Headshot Damage', _CanonType.passive, 'Assassination'),
    _CanonSkill('Hunter-Seeker', _CanonType.ability, 'Assassination'),
    _CanonSkill('Poison Capsule', _CanonType.ability, 'Assassination'),
    _CanonSkill('Poison Mine', _CanonType.ability, 'Assassination'),
    _CanonSkill('Poison Tooth', _CanonType.technique, 'Assassination'),
    _CanonSkill('Stunner', _CanonType.ability, 'Assassination'),
    // Tactician
    _CanonSkill('Anti-gravity Mine', _CanonType.ability, 'Tactician'),
    _CanonSkill('Gravity Mine', _CanonType.ability, 'Tactician'),
    _CanonSkill('Iron Will', _CanonType.technique, 'Tactician'),
    _CanonSkill('Shield Wall', _CanonType.ability, 'Tactician'),
    _CanonSkill('Solido Decoy', _CanonType.ability, 'Tactician'),
    _CanonSkill('Source of Power', _CanonType.ability, 'Tactician'),
  ],
  'Planetologist': [
    // Scientist
    _CanonSkill('Compaction', _CanonType.passive, 'Scientist'),
    _CanonSkill('Conservation of Energy', _CanonType.technique, 'Scientist'),
    _CanonSkill('Cutteray Mining', _CanonType.passive, 'Scientist'),
    _CanonSkill('Deep Analysis', _CanonType.passive, 'Scientist'),
    _CanonSkill('Dew Gathering', _CanonType.passive, 'Scientist'),
    _CanonSkill('Overcharge', _CanonType.passive, 'Scientist'),
    _CanonSkill('Rerouting', _CanonType.passive, 'Scientist'),
    // Explorer
    _CanonSkill('Cartographer', _CanonType.passive, 'Explorer'),
    _CanonSkill('Mountaineer', _CanonType.passive, 'Explorer'),
    _CanonSkill('Scanner Mastery', _CanonType.passive, 'Explorer'),
    _CanonSkill('Spice Surveyor', _CanonType.passive, 'Explorer'),
    _CanonSkill('Stillsuit Seals', _CanonType.passive, 'Explorer'),
    _CanonSkill('Suspensor Pad', _CanonType.ability, 'Explorer'),
    // Mechanic
    _CanonSkill('Fuel Efficient Driver', _CanonType.passive, 'Mechanic'),
    _CanonSkill('Fuel Efficient Pilot', _CanonType.passive, 'Mechanic'),
    _CanonSkill('Heat Management', _CanonType.passive, 'Mechanic'),
    _CanonSkill('Sandcrawler Yield', _CanonType.passive, 'Mechanic'),
    _CanonSkill('Vehicle Mining', _CanonType.passive, 'Mechanic'),
    _CanonSkill('Vehicle Repair', _CanonType.passive, 'Mechanic'),
    _CanonSkill('Vehicle Scanning', _CanonType.passive, 'Mechanic'),
  ],
  'Trooper': [
    // Gunnery
    _CanonSkill('Center of Mass', _CanonType.technique, 'Gunnery'),
    _CanonSkill('Disruptor Damage', _CanonType.passive, 'Gunnery'),
    _CanonSkill('Energy Capsule', _CanonType.ability, 'Gunnery'),
    _CanonSkill('Field Maintenance', _CanonType.passive, 'Gunnery'),
    _CanonSkill('Gunsmith', _CanonType.passive, 'Gunnery'),
    _CanonSkill('Heavy Weapon Damage', _CanonType.passive, 'Gunnery'),
    _CanonSkill('Ranged Damage', _CanonType.passive, 'Gunnery'),
    _CanonSkill('Scattergun Damage', _CanonType.passive, 'Gunnery'),
    _CanonSkill('Underslung Agility', _CanonType.technique, 'Gunnery'),
    // Suspensor Training
    _CanonSkill('Anti-gravity Field', _CanonType.ability, 'Suspensor Training'),
    _CanonSkill('Collapse Grenade', _CanonType.ability, 'Suspensor Training'),
    _CanonSkill('Death from Above', _CanonType.technique, 'Suspensor Training'),
    _CanonSkill('Gravity Field', _CanonType.ability, 'Suspensor Training'),
    _CanonSkill('Suspensor Blast', _CanonType.ability, 'Suspensor Training'),
    _CanonSkill('Suspensor Dash', _CanonType.technique, 'Suspensor Training'),
    _CanonSkill(
        'Suspensor Efficiency', _CanonType.passive, 'Suspensor Training'),
    // Tactical Tech
    _CanonSkill('Assault Seeker', _CanonType.ability, 'Tactical Tech'),
    _CanonSkill('Attractor Field', _CanonType.ability, 'Tactical Tech'),
    _CanonSkill('Battle Hardened', _CanonType.technique, 'Tactical Tech'),
    _CanonSkill('Explosive Grenade', _CanonType.ability, 'Tactical Tech'),
    _CanonSkill('Reflexive Reload', _CanonType.passive, 'Tactical Tech'),
    _CanonSkill('Shigawire Claw', _CanonType.ability, 'Tactical Tech'),
  ],
  'Swordmaster': [
    // The Blade
    _CanonSkill('Blade Damage', _CanonType.passive, 'The Blade'),
    _CanonSkill('Dance of Blades', _CanonType.technique, 'The Blade'),
    _CanonSkill('Eye of the Storm', _CanonType.ability, 'The Blade'),
    _CanonSkill('Foil', _CanonType.ability, 'The Blade'),
    _CanonSkill('Long Blade Damage', _CanonType.passive, 'The Blade'),
    _CanonSkill('Precise Parry', _CanonType.passive, 'The Blade'),
    _CanonSkill('Retaliate', _CanonType.ability, 'The Blade'),
    // The Will
    _CanonSkill('Bleed Tolerance', _CanonType.passive, 'The Will'),
    _CanonSkill('Confidence', _CanonType.passive, 'The Will'),
    _CanonSkill('Deflection', _CanonType.ability, 'The Will'),
    _CanonSkill('Reckless Lunge', _CanonType.technique, 'The Will'),
    _CanonSkill('Solid Stance', _CanonType.passive, 'The Will'),
    _CanonSkill('Thrive on Danger', _CanonType.technique, 'The Will'),
    // The Way
    _CanonSkill('Crippling Strike', _CanonType.ability, 'The Way'),
    _CanonSkill('Desert Conditioning', _CanonType.passive, 'The Way'),
    _CanonSkill('Disciplined Breathing', _CanonType.technique, 'The Way'),
    _CanonSkill('Field Medicine', _CanonType.passive, 'The Way'),
    _CanonSkill('General Conditioning', _CanonType.passive, 'The Way'),
    _CanonSkill('Inspiration', _CanonType.ability, 'The Way'),
    _CanonSkill('Knee Charge', _CanonType.ability, 'The Way'),
    _CanonSkill('Optimized Hydration', _CanonType.passive, 'The Way'),
    _CanonSkill('Prescient Strike', _CanonType.passive, 'The Way'),
  ],
};

/// Many catalog entries disambiguate cross-class skills with a parenthetical
/// suffix, e.g. "Blade Damage (Bene Gesserit)". Strip it for canon matching.
String _baseName(String name) {
  final idx = name.indexOf(' (');
  return idx < 0 ? name : name.substring(0, idx);
}

void main() {
  group('skill catalog structure', () {
    test('all ids are unique', () {
      final ids = skillCatalog.map((s) => s.id).toList();
      final dupes = <String>{};
      final seen = <String>{};
      for (final id in ids) {
        if (!seen.add(id)) dupes.add(id);
      }
      expect(dupes, isEmpty, reason: 'duplicate skill ids: $dupes');
    });

    test('(className, baseName) is unique within the catalog', () {
      final seen = <String>{};
      final dupes = <String>{};
      for (final s in skillCatalog) {
        final key = '${s.className}::${_baseName(s.name)}';
        if (!seen.add(key)) dupes.add(key);
      }
      expect(dupes, isEmpty, reason: 'duplicate (class,name) pairs: $dupes');
    });

    test('every type is "active", "passive", or "technique"', () {
      for (final s in skillCatalog) {
        expect(
          ['active', 'passive', 'technique'],
          contains(s.type),
          reason: '${s.id} has unknown type "${s.type}"',
        );
      }
    });

    test('every entry has a non-empty name and tree', () {
      for (final s in skillCatalog) {
        expect(s.name.trim(), isNotEmpty, reason: '${s.id} has empty name');
        expect(s.treeName.trim(), isNotEmpty,
            reason: '${s.id} has empty treeName');
      }
    });

    test('every entry belongs to a known progression class', () {
      for (final s in skillCatalog) {
        expect(
          AppConstants.allProgressionClasses,
          contains(s.className),
          reason: '${s.id} className "${s.className}" is not in '
              'AppConstants.allProgressionClasses',
        );
      }
    });
  });

  group('skill catalog matches Fextralife canon', () {
    test('canon table itself covers every progression class', () {
      // Sanity check: if a new class is added to AppConstants but the canon
      // table here isn't updated, fail loudly so the canon stays in sync.
      for (final c in AppConstants.allProgressionClasses) {
        expect(_canon.containsKey(c), isTrue,
            reason: 'canon table missing class "$c"');
      }
    });

    for (final entry in _canon.entries) {
      final className = entry.key;
      final canonSkills = entry.value;

      test('$className: no missing canon skills', () {
        final catalogBaseNames = skillCatalog
            .where((s) => s.className == className)
            .map((s) => _baseName(s.name))
            .toSet();
        final missing = canonSkills
            .map((c) => c.name)
            .where((n) => !catalogBaseNames.contains(n))
            .toList();
        expect(missing, isEmpty,
            reason: 'catalog missing canon $className skills: $missing');
      });

      test('$className: no hallucinated (non-canon) skills', () {
        final canonNames = canonSkills.map((c) => c.name).toSet();
        final extras = skillCatalog
            .where((s) => s.className == className)
            .map((s) => _baseName(s.name))
            .where((n) => !canonNames.contains(n))
            .toList();
        expect(extras, isEmpty,
            reason: 'catalog has non-canon $className skills: $extras');
      });

      test('$className: skill types match canon', () {
        final catalogByName = {
          for (final s
              in skillCatalog.where((s) => s.className == className))
            _baseName(s.name): s,
        };
        final mismatches = <String>[];
        for (final c in canonSkills) {
          final entry = catalogByName[c.name];
          if (entry == null) continue; // missing-skill test handles this
          final expectedType = _expectedCatalogType(c.type);
          if (entry.type != expectedType) {
            mismatches.add(
              '${c.name}: expected $expectedType (wiki=${c.type.name}), '
              'got ${entry.type}',
            );
          }
        }
        expect(mismatches, isEmpty,
            reason: '$className type mismatches:\n  ${mismatches.join('\n  ')}');
      });

      test('$className: skill tree assignments match canon', () {
        final catalogByName = {
          for (final s
              in skillCatalog.where((s) => s.className == className))
            _baseName(s.name): s,
        };
        final mismatches = <String>[];
        for (final c in canonSkills) {
          final entry = catalogByName[c.name];
          if (entry == null) continue; // missing-skill test handles this
          if (entry.treeName != c.tree) {
            mismatches.add(
              '${c.name}: expected tree "${c.tree}", got "${entry.treeName}"',
            );
          }
        }
        expect(mismatches, isEmpty,
            reason: '$className tree mismatches:\n  ${mismatches.join('\n  ')}');
      });

      test('$className: catalog uses only canonical tree names', () {
        final canonTrees = canonSkills.map((c) => c.tree).toSet();
        final catalogTrees = skillCatalog
            .where((s) => s.className == className)
            .map((s) => s.treeName)
            .toSet();
        final extras = catalogTrees.difference(canonTrees).toList();
        expect(extras, isEmpty,
            reason: '$className has non-canon tree names: $extras '
                '(canon trees: $canonTrees)');
      });
    }

    test('total catalog size matches canon (108 skills across 5 classes)', () {
      final expected =
          _canon.values.fold<int>(0, (sum, list) => sum + list.length);
      expect(skillCatalog.length, expected,
          reason: 'catalog has ${skillCatalog.length} entries, '
              'canon has $expected');
    });
  });
}
