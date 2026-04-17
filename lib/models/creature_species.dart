class CreatureSpecies {
  final String id;
  final String name;
  final String iconAssetPath;
  final String portraitAssetPath;
  final String biography;
  final String heightText;
  final String weightText;
  final String eggType;

  const CreatureSpecies({
    required this.id,
    required this.name,
    required this.iconAssetPath,
    required this.portraitAssetPath,
    required this.biography,
    required this.heightText,
    required this.weightText,
    required this.eggType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconAssetPath': iconAssetPath,
      'portraitAssetPath': portraitAssetPath,
      'biography': biography,
      'heightText': heightText,
      'weightText': weightText,
      'eggType': eggType,
    };
  }

  factory CreatureSpecies.fromJson(Map<String, dynamic> json) {
    return CreatureSpecies(
      id: json['id'] as String,
      name: json['name'] as String,
      iconAssetPath: json['iconAssetPath'] as String,
      portraitAssetPath: json['portraitAssetPath'] as String,
      biography: json['biography'] as String,
      heightText: json['heightText'] as String,
      weightText: json['weightText'] as String,
      eggType: json['eggType'] as String,
    );
  }
}
