class CreatureForm {
  final String id;
  final String speciesId;
  final String name;
  final String assetPath;
  final String biography;
  final String heightText;
  final String weightText;
  final int requiredSteps;

  const CreatureForm({
    required this.id,
    required this.speciesId,
    required this.name,
    required this.assetPath,
    required this.biography,
    required this.heightText,
    required this.weightText,
    required this.requiredSteps,
  });
}
