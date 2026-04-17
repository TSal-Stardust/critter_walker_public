class EvolutionStage {
  final String name;
  final String assetPath;
  final int requiredSteps;
  final String flavorText;

  const EvolutionStage({
    required this.name,
    required this.assetPath,
    required this.requiredSteps,
    required this.flavorText,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'assetPath': assetPath,
      'requiredSteps': requiredSteps,
      'flavorText': flavorText,
    };
  }

  factory EvolutionStage.fromJson(Map<String, dynamic> json) {
    return EvolutionStage(
      name: json['name'] as String,
      assetPath: json['assetPath'] as String,
      requiredSteps: json['requiredSteps'] as int,
      flavorText: json['flavorText'] as String,
    );
  }
}
