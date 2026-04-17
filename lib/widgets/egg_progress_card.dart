import 'package:flutter/material.dart';
import '../models/evolution_stage.dart';

class EggProgressCard extends StatelessWidget {
  final int currentSteps;
  final List<EvolutionStage> stages;
  final String flavorText;

  const EggProgressCard({
    super.key,
    required this.currentSteps,
    required this.stages,
    required this.flavorText,
  });

  EvolutionStage getCurrentStage() {
    EvolutionStage current = stages.first;

    for (final stage in stages) {
      if (currentSteps >= stage.requiredSteps) {
        current = stage;
      } else {
        break;
      }
    }

    return current;
  }

  EvolutionStage? getNextStage() {
    for (final stage in stages) {
      if (currentSteps < stage.requiredSteps) {
        return stage;
      }
    }
    return null;
  }

  double getProgressToNextStage() {
    final currentStage = getCurrentStage();
    final nextStage = getNextStage();

    if (nextStage == null) {
      return 1.0;
    }

    final startSteps = currentStage.requiredSteps;
    final endSteps = nextStage.requiredSteps;
    final span = endSteps - startSteps;

    if (span <= 0) {
      return 1.0;
    }

    final progressed = currentSteps - startSteps;
    return (progressed / span).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final currentStage = getCurrentStage();
    final nextStage = getNextStage();
    final progress = getProgressToNextStage();

    final stepLabel = nextStage != null
        ? '$currentSteps / ${nextStage.requiredSteps} steps'
        : '$currentSteps steps';

    final statusLabel = nextStage != null
        ? currentStage.name
        : '${currentStage.name} (Final Form)';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF2CBCD),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Image.asset(currentStage.assetPath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            statusLabel,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 20,
              backgroundColor: const Color(0xFFD7D7D7),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF72F06A)),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              stepLabel,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            flavorText,
            style: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
              height: 1.4,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
