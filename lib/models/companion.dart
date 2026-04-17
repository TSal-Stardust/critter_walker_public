class Companion {
  final String id;
  final String eggName;
  final int currentSteps;
  final String? speciesId;
  final bool isActive;

  const Companion({
    required this.id,
    required this.eggName,
    required this.currentSteps,
    required this.speciesId,
    this.isActive = false,
  });

  Companion copyWith({
    String? id,
    String? eggName,
    int? currentSteps,
    Object? speciesId = _noSpeciesIdChange,
    bool? isActive,
  }) {
    return Companion(
      id: id ?? this.id,
      eggName: eggName ?? this.eggName,
      currentSteps: currentSteps ?? this.currentSteps,
      speciesId: identical(speciesId, _noSpeciesIdChange)
          ? this.speciesId
          : speciesId as String?,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get hasHatched => speciesId != null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eggName': eggName,
      'currentSteps': currentSteps,
      'speciesId': speciesId,
      'isActive': isActive,
    };
  }

  factory Companion.fromJson(Map<String, dynamic> json) {
    return Companion(
      id: json['id'] as String,
      eggName: json['eggName'] as String,
      currentSteps: json['currentSteps'] as int,
      speciesId: json['speciesId'] as String?,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

const Object _noSpeciesIdChange = Object();
