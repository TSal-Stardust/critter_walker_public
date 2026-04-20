import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/companion.dart';
import '../services/creature_catalog.dart';
import '../widgets/egg_progress_card.dart';

class HomeScreen extends StatelessWidget {
  final Companion? companion;
  final ValueChanged<Companion> onCompanionChanged;

  const HomeScreen({
    super.key,
    required this.companion,
    required this.onCompanionChanged,
  });

  // Debug method to simulate step progress - can be removed later
  void _addSteps(int amount) {
    if (companion == null) return;

    final updatedCompanion = companion!.copyWith(
      currentSteps: companion!.currentSteps + amount,
    );

    onCompanionChanged(updatedCompanion);
  }

  // Debug method to reset steps and hatch state - can be removed later
  void _resetSteps() {
    if (companion == null) return;

    final updatedCompanion = companion!.copyWith(
      currentSteps: 0,
      speciesId: null,
    );

    onCompanionChanged(updatedCompanion);
  }

  @override
  Widget build(BuildContext context) {
    if (companion == null) {
      return const SafeArea(
        child: Center(
          child: Text(
            'No active companion found.',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    final species = companion!.speciesId != null
        ? CreatureCatalog.byId(companion!.speciesId!)
        : null;

    final displayName = species?.name ?? companion!.eggName;
    final stages = CreatureCatalog.stagesForCompanion(companion!);

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            displayName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: EggProgressCard(
                currentSteps: companion!.currentSteps,
                stages: stages,
                eggName: companion!.eggName,
              ),
            ),
          ),
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _addSteps(1),
                    child: const Text('+1 Step'),
                  ),
                  ElevatedButton(
                    onPressed: () => _addSteps(5),
                    child: const Text('+5 Steps'),
                  ),
                  ElevatedButton(
                    onPressed: () => _addSteps(10),
                    child: const Text('+10 Steps'),
                  ),
                  OutlinedButton(
                    onPressed: _resetSteps,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
