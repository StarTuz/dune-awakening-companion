import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/core/utils/constants.dart';

void main() {
  test('serverTypes has Official and Private', () {
    expect(AppConstants.serverTypes, contains('Official'));
    expect(AppConstants.serverTypes, contains('Private'));
    expect(AppConstants.serverTypes.length, 2);
  });

  test('privateProviders is non-empty', () {
    expect(AppConstants.privateProviders, isNotEmpty);
    expect(AppConstants.privateProviders, contains('GPORTAL'));
    expect(AppConstants.privateProviders, contains('BisectHosting'));
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
}
