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

  void _addSteps(int amount) {
    if (companion == null) return;

    final updatedCompanion = companion!.copyWith(
      currentSteps: companion!.currentSteps + amount,
    );

    onCompanionChanged(updatedCompanion);
  }

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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _addSteps(500),
                  child: const Text('+500 Steps'),
                ),
                ElevatedButton(
                  onPressed: () => _addSteps(1000),
                  child: const Text('+1000 Steps'),
                ),
                ElevatedButton(
                  onPressed: () => _addSteps(2500),
                  child: const Text('+2500 Steps'),
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
