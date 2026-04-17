import 'package:flutter_test/flutter_test.dart';
import 'package:critter_walker/models/companion.dart';

void main() {
  group('Companion', () {
    test('hasHatched is false when speciesId is null', () {
      const companion = Companion(
        id: 'c1',
        eggName: 'Mysterious Egg',
        currentSteps: 0,
        speciesId: null,
        isActive: true,
      );

      expect(companion.hasHatched, false);
    });

    test('hasHatched is true when speciesId is set', () {
      const companion = Companion(
        id: 'c1',
        eggName: 'Mysterious Egg',
        currentSteps: 12,
        speciesId: 'squidge',
        isActive: true,
      );

      expect(companion.hasHatched, true);
    });

    test('copyWith updates currentSteps', () {
      const companion = Companion(
        id: 'c1',
        eggName: 'Mysterious Egg',
        currentSteps: 5,
        speciesId: null,
        isActive: true,
      );

      final updated = companion.copyWith(currentSteps: 10);

      expect(updated.currentSteps, 10);
      expect(updated.eggName, 'Mysterious Egg');
      expect(updated.speciesId, isNull);
      expect(updated.isActive, true);
    });

    test('copyWith can set speciesId from null to value', () {
      const companion = Companion(
        id: 'c1',
        eggName: 'Mysterious Egg',
        currentSteps: 10,
        speciesId: null,
        isActive: true,
      );

      final updated = companion.copyWith(speciesId: 'squidge');

      expect(updated.speciesId, 'squidge');
    });

    test('copyWith can reset speciesId to null', () {
      const companion = Companion(
        id: 'c1',
        eggName: 'Mysterious Egg',
        currentSteps: 30,
        speciesId: 'squidge',
        isActive: true,
      );

      final updated = companion.copyWith(speciesId: null);

      expect(updated.speciesId, isNull);
    });

    test('toJson and fromJson round-trip', () {
      const companion = Companion(
        id: 'c1',
        eggName: 'Mysterious Egg',
        currentSteps: 22,
        speciesId: 'squidge',
        isActive: true,
      );

      final json = companion.toJson();
      final decoded = Companion.fromJson(json);

      expect(decoded.id, companion.id);
      expect(decoded.eggName, companion.eggName);
      expect(decoded.currentSteps, companion.currentSteps);
      expect(decoded.speciesId, companion.speciesId);
      expect(decoded.isActive, companion.isActive);
    });
  });
}
