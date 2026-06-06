import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/core/utils/constants.dart';

void main() {
  test('serverTypes has Official, Private, and Self Hosted', () {
    expect(AppConstants.serverTypes, contains('Official'));
    expect(AppConstants.serverTypes, contains('Private'));
    expect(AppConstants.serverTypes, contains('Self Hosted'));
    expect(AppConstants.serverTypes.length, 3);
  });

  test('privateProviders is non-empty', () {
    expect(AppConstants.privateProviders, isNotEmpty);
    expect(AppConstants.privateProviders, contains('GPORTAL'));
    expect(AppConstants.privateProviders, contains('BisectHosting'));
  });

  test('self hosted uses freeform world name and provider', () {
    expect(
      AppConstants.usesFreeformWorldName(AppConstants.serverTypeSelfHosted),
      isTrue,
    );
    expect(
      AppConstants.getProvidersForServerType(AppConstants.serverTypeSelfHosted),
      contains(AppConstants.serverTypeSelfHosted),
    );
  });

  test('primary classes exclude Planetologist', () {
    expect(
        AppConstants.primaryClasses, contains(AppConstants.classBeneGesserit));
    expect(AppConstants.primaryClasses, contains(AppConstants.classMentat));
    expect(
        AppConstants.primaryClasses, contains(AppConstants.classSwordmaster));
    expect(AppConstants.primaryClasses, contains(AppConstants.classTrooper));
    expect(
      AppConstants.primaryClasses,
      isNot(contains(AppConstants.classPlanetologist)),
    );
  });

  test('regions returns all keys from regionWorlds', () {
    final regions = AppConstants.regions;
    expect(
        regions,
        containsAll(
            ['North America', 'Europe', 'Asia', 'Oceania', 'South America']));
  });

  test('getWorldsForRegion returns worlds for valid region', () {
    final naWorlds = AppConstants.getWorldsForRegion('North America');
    expect(naWorlds, isNotEmpty);
    expect(naWorlds, contains('Arrakis'));
  });

  test('getWorldsForRegion returns empty for unknown region', () {
    expect(AppConstants.getWorldsForRegion('Antarctica'), isEmpty);
  });

  test('defaultAlertThresholds contains expected values', () {
    expect(AppConstants.defaultAlertThresholds, isNotEmpty);
    expect(AppConstants.defaultAlertThresholds, contains(24));
    expect(AppConstants.defaultAlertThresholds, contains(6));
  });

  group('isClosedWorld (server migration)', () {
    test('flags worlds from the official closing list', () {
      expect(AppConstants.isClosedWorld('Bifrost'), isTrue); // Asia
      expect(AppConstants.isClosedWorld('Salusa Secundus'), isTrue); // Europe
      expect(AppConstants.isClosedWorld('Farhold'), isTrue); // North America
      expect(AppConstants.isClosedWorld('Aerarium IV'), isTrue); // Oceania
      expect(AppConstants.isClosedWorld('Mimosa'), isTrue); // South America
    });

    test('flags legacy in-app spellings of closing worlds', () {
      // Characters created before the name corrections stored these spellings.
      expect(AppConstants.isClosedWorld('Octane'), isTrue); // = Octans
      expect(AppConstants.isClosedWorld('Boots'), isTrue); // = Bootes
      expect(AppConstants.isClosedWorld('Sagittarius'), isTrue); // = Sagitta
      expect(
          AppConstants.isClosedWorld('Fall Eight'), isTrue); // = Fallow Eight
      expect(AppConstants.isClosedWorld('House of Knowledge'),
          isTrue); // = House of Ilm
    });

    test('does not flag surviving / destination worlds', () {
      expect(AppConstants.isClosedWorld('Arrakis'), isFalse);
      expect(AppConstants.isClosedWorld('Pax'), isFalse); // destination
      expect(AppConstants.isClosedWorld('Harmony'), isFalse); // destination
      expect(AppConstants.isClosedWorld('Corrin'), isFalse);
    });

    test('matching is trim + case-insensitive and null-safe', () {
      expect(AppConstants.isClosedWorld('  bifrost  '), isTrue);
      expect(AppConstants.isClosedWorld('FARHOLD'), isTrue);
      expect(AppConstants.isClosedWorld(null), isFalse);
      expect(AppConstants.isClosedWorld(''), isFalse);
      expect(AppConstants.isClosedWorld('Custom Private World'), isFalse);
    });
  });

  group('regionWorlds spelling corrections', () {
    test('dropdown uses corrected names, not the legacy garbled ones', () {
      final eu = AppConstants.getWorldsForRegion('Europe');
      final na = AppConstants.getWorldsForRegion('North America');
      // Corrected names are present...
      expect(eu, containsAll(['Octans', 'Serpens', 'Lampadas', 'Leto']));
      expect(na, containsAll(['Bootes', 'Fallow Eight', 'Sagitta']));
      // ...and the garbled originals are gone.
      expect(eu, isNot(contains('Octane')));
      expect(eu, isNot(contains('Serpents')));
      expect(na, isNot(contains('Boots')));
      expect(na, isNot(contains('Sagittarius')));
    });

    test('corrected closing worlds are still flagged as closed', () {
      expect(AppConstants.isClosedWorld('Octans'), isTrue);
      expect(AppConstants.isClosedWorld('Bootes'), isTrue);
      expect(AppConstants.isClosedWorld('Leto'), isTrue);
    });
  });
}
