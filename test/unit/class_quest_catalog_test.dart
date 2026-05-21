import 'package:flutter_test/flutter_test.dart';

import 'package:dune_awakening_companion/core/utils/constants.dart';
import 'package:dune_awakening_companion/features/class_quests/models/class_quest_catalog.dart';

void main() {
  test('class quest catalog has basic and advanced entries for every class',
      () {
    for (final className in AppConstants.allProgressionClasses) {
      expect(
        classQuestCatalog.any(
          (entry) =>
              entry.className == className &&
              entry.tier == ClassQuestTier.basic,
        ),
        isTrue,
        reason: '$className should have a basic quest entry',
      );
      expect(
        classQuestCatalog.any(
          (entry) =>
              entry.className == className &&
              entry.tier == ClassQuestTier.advanced,
        ),
        isTrue,
        reason: '$className should have an advanced quest entry',
      );
    }
  });

  test('Planetologist is tracked but not selectable as a primary class', () {
    expect(AppConstants.allProgressionClasses,
        contains(AppConstants.classPlanetologist));
    expect(AppConstants.primaryClasses,
        isNot(contains(AppConstants.classPlanetologist)));
    expect(
      classQuestCatalog
          .where(
            (entry) => entry.className == AppConstants.classPlanetologist,
          )
          .expand((entry) => entry.steps)
          .map((step) => step.title),
      contains("Read Derek's camp clues and map"),
    );
  });
}
