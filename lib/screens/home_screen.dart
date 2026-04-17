import 'package:flutter/material.dart';
import '../models/evolution_stage.dart';
import '../widgets/egg_progress_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSteps = 0;

  final List<EvolutionStage> stages = const [
    EvolutionStage(
      name: 'Mysterious Egg',
      assetPath: 'assets/squidge/egg.png',
      requiredSteps: 0,
    ),
    EvolutionStage(
      name: 'Stage 1',
      assetPath: 'assets/squidge/stage1.png',
      requiredSteps: 2000,
    ),
    EvolutionStage(
      name: 'Stage 2',
      assetPath: 'assets/squidge/stage2.png',
      requiredSteps: 5000,
    ),
    EvolutionStage(
      name: 'Stage 3',
      assetPath: 'assets/squidge/stage3.png',
      requiredSteps: 8000,
    ),
  ];

  void addSteps(int amount) {
    setState(() {
      currentSteps += amount;
    });
  }

  void resetSteps() {
    setState(() {
      currentSteps = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Critter Walker'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF7F7F7),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: EggProgressCard(
                  currentSteps: currentSteps,
                  stages: stages,
                  flavorText:
                      'A warm, softly glowing egg. It seems to wiggle a little more with every step you take.',
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
                    onPressed: () => addSteps(500),
                    child: const Text('+500 Steps'),
                  ),
                  ElevatedButton(
                    onPressed: () => addSteps(1000),
                    child: const Text('+1000 Steps'),
                  ),
                  ElevatedButton(
                    onPressed: () => addSteps(2500),
                    child: const Text('+2500 Steps'),
                  ),
                  OutlinedButton(
                    onPressed: resetSteps,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
