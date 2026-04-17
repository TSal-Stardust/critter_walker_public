import '../models/companion.dart';
import '../models/creature_form.dart';
import '../models/creature_species.dart';
import '../models/evolution_stage.dart';

class CreatureCatalog {
  static const String mysteriousEggName = 'Mysterious Egg';
  static const String squidgeSpeciesId = 'squidge';

  static const List<CreatureSpecies> species = [
    CreatureSpecies(
      id: squidgeSpeciesId,
      name: 'Squidge',
      iconAssetPath: 'assets/squidge/stage1.png',
      portraitAssetPath: 'assets/squidge/stage1.png',
      biography:
          'Squidge is a mellow little critter with a squishy body and an easygoing smile. It loves warm places, slow strolls, and curling up after a long day of walking. Though it looks sleepy, Squidge is always paying attention and has a surprisingly playful side once it trusts you. It thrives on companionship and seems happiest when keeping pace with its favorite person.',
      heightText: '1\'11"',
      weightText: '24 lbs',
      eggType: mysteriousEggName,
    ),
  ];

  static const List<EvolutionStage> mysteriousEggStages = [
    EvolutionStage(
      name: mysteriousEggName,
      assetPath: 'assets/squidge/egg.png',
      requiredSteps: 0,
      flavorText:
          'A warm, softly glowing egg. It wiggles a little more with every step you take.',
    ),
    EvolutionStage(
      name: 'Squidge',
      assetPath: 'assets/squidge/stage1.png',
      requiredSteps: 10,
      flavorText:
          'Squidge has finally hatched. It blinks up at you with a soft smile and a very squishable body.',
    ),
    EvolutionStage(
      name: 'Squidge - Stage 2',
      assetPath: 'assets/squidge/stage2.png',
      requiredSteps: 20,
      flavorText:
          'Squidge has grown bolder and more energetic. It seems eager to keep waddling by your side.',
    ),
    EvolutionStage(
      name: 'Squidge - Final Stage',
      assetPath: 'assets/squidge/stage3.png',
      requiredSteps: 30,
      flavorText:
          'Squidge has reached its full potential. It radiates warmth, confidence, and calm companionship.',
    ),
  ];

  static const List<CreatureForm> forms = [
    CreatureForm(
      id: 'squidge_1',
      speciesId: squidgeSpeciesId,
      name: 'Squidge (Hatchling)',
      assetPath: 'assets/squidge/stage1.png',
      requiredSteps: 10,
      heightText: '0\'08"',
      weightText: '6 lbs',
      biography:
          'A freshly hatched Squidge that barely knows how to move. It watches everything with wide, curious eyes and seems fascinated by your every step.',
    ),
    CreatureForm(
      id: 'squidge_2',
      speciesId: squidgeSpeciesId,
      name: 'Squidge (Juvenile)',
      assetPath: 'assets/squidge/stage2.png',
      requiredSteps: 20,
      heightText: '1\'04"',
      weightText: '15 lbs',
      biography:
          'Growing stronger and more expressive, this Squidge has begun to stand upright. It mimics your movements and seems eager to explore the world alongside you.',
    ),
    CreatureForm(
      id: 'squidge_3',
      speciesId: squidgeSpeciesId,
      name: 'Squidge (Final Form)',
      assetPath: 'assets/squidge/stage3.png',
      requiredSteps: 30,
      heightText: '2\'01"',
      weightText: '28 lbs',
      biography:
          'A fully evolved Squidge. Its body has become glossy and vibrant, and it radiates warmth and affection. It is deeply bonded to you and moves with confidence.',
    ),
  ];

  static CreatureSpecies? byId(String id) {
    try {
      return species.firstWhere((entry) => entry.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<CreatureForm> formsBySpecies(String speciesId) {
    return forms.where((f) => f.speciesId == speciesId).toList();
  }

  static CreatureForm? formById(String id) {
    try {
      return forms.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<EvolutionStage> stagesForCompanion(Companion companion) {
    switch (companion.eggName) {
      case mysteriousEggName:
        return mysteriousEggStages;
      default:
        return mysteriousEggStages;
    }
  }

  static int hatchThresholdForEgg(String eggName) {
    switch (eggName) {
      case mysteriousEggName:
        return mysteriousEggStages[1].requiredSteps;
      default:
        return mysteriousEggStages[1].requiredSteps;
    }
  }

  static String? speciesIdForEgg(String eggName) {
    switch (eggName) {
      case mysteriousEggName:
        return squidgeSpeciesId;
      default:
        return null;
    }
  }
}
