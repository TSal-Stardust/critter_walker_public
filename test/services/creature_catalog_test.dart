import 'package:flutter_test/flutter_test.dart';
import 'package:critter_walker/models/companion.dart';
import 'package:critter_walker/services/creature_catalog.dart';

void main() {
  group('CreatureCatalog', () {
    test('returns Squidge species by id', () {
      final species = CreatureCatalog.byId('squidge');

      expect(species, isNotNull);
      expect(species!.name, 'Squidge');
    });

    test('returns null for unknown species id', () {
      final species = CreatureCatalog.byId('unknown');

      expect(species, isNull);
    });

    test('returns Squidge forms by species', () {
      final forms = CreatureCatalog.formsBySpecies('squidge');

      expect(forms.length, 3);
      expect(forms[0].name, 'Squidge (Hatchling)');
      expect(forms[1].name, 'Squidge (Juvenile)');
      expect(forms[2].name, 'Squidge (Final Form)');
    });

    test('returns form by id', () {
      final form = CreatureCatalog.formById('squidge_2');

      expect(form, isNotNull);
      expect(form!.name, 'Squidge (Juvenile)');
      expect(form.requiredSteps, 20);
    });

    test('returns null for unknown form id', () {
      final form = CreatureCatalog.formById('bad_form');

      expect(form, isNull);
    });

    test('returns correct hatch threshold for Mysterious Egg', () {
      final threshold = CreatureCatalog.hatchThresholdForEgg(
        CreatureCatalog.mysteriousEggName,
      );

      expect(threshold, 10);
    });

    test('returns squidge species id for Mysterious Egg', () {
      final speciesId = CreatureCatalog.speciesIdForEgg(
        CreatureCatalog.mysteriousEggName,
      );

      expect(speciesId, 'squidge');
    });

    test('returns evolution stages for companion', () {
      const companion = Companion(
        id: 'starter',
        eggName: 'Mysterious Egg',
        currentSteps: 0,
        speciesId: null,
        isActive: true,
      );

      final stages = CreatureCatalog.stagesForCompanion(companion);

      expect(stages.length, 4);
      expect(stages[0].name, 'Mysterious Egg');
      expect(stages[1].name, 'Squidge');
      expect(stages[2].requiredSteps, 20);
      expect(stages[3].requiredSteps, 30);
    });
  });
}
