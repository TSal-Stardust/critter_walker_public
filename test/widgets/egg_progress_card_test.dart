import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:critter_walker/models/evolution_stage.dart';
import 'package:critter_walker/widgets/egg_progress_card.dart';

void main() {
  final stages = [
    const EvolutionStage(
      name: 'Mysterious Egg',
      assetPath: 'assets/squidge/egg.png',
      requiredSteps: 0,
      flavorText: 'Egg flavor text',
    ),
    const EvolutionStage(
      name: 'Squidge',
      assetPath: 'assets/squidge/stage1.png',
      requiredSteps: 10,
      flavorText: 'Squidge flavor text',
    ),
    const EvolutionStage(
      name: 'Squidge - Stage 2',
      assetPath: 'assets/squidge/stage2.png',
      requiredSteps: 20,
      flavorText: 'Stage 2 flavor text',
    ),
    const EvolutionStage(
      name: 'Squidge - Final Stage',
      assetPath: 'assets/squidge/stage3.png',
      requiredSteps: 30,
      flavorText: 'Final stage flavor text',
    ),
  ];

  Widget buildTestWidget(int currentSteps) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: EggProgressCard(
              currentSteps: currentSteps,
              stages: stages,
              eggName: 'Mysterious Egg',
            ),
          ),
        ),
      ),
    );
  }

  void setLargeScreenSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('shows egg stage initially', (tester) async {
    setLargeScreenSize(tester);

    await tester.pumpWidget(buildTestWidget(0));
    await tester.pumpAndSettle();

    expect(find.text('Mysterious Egg'), findsOneWidget);
    expect(find.text('Egg flavor text'), findsOneWidget);
    expect(find.text('0 / 10 steps'), findsOneWidget);
  });

  testWidgets('shows Squidge after hatch threshold', (tester) async {
    setLargeScreenSize(tester);

    await tester.pumpWidget(buildTestWidget(10));
    await tester.pumpAndSettle();

    expect(find.text('Squidge'), findsWidgets);
    expect(find.text('Squidge flavor text'), findsOneWidget);
    expect(find.text('10 / 20 steps'), findsOneWidget);
  });

  testWidgets('shows second form after second threshold', (tester) async {
    setLargeScreenSize(tester);

    await tester.pumpWidget(buildTestWidget(20));
    await tester.pumpAndSettle();

    expect(find.text('Squidge - Stage 2'), findsWidgets);
    expect(find.text('Stage 2 flavor text'), findsOneWidget);
    expect(find.text('20 / 30 steps'), findsOneWidget);
  });

  testWidgets('shows final form at final threshold', (tester) async {
    setLargeScreenSize(tester);

    await tester.pumpWidget(buildTestWidget(30));
    await tester.pumpAndSettle();

    expect(find.text('Squidge - Final Stage (Final Form)'), findsOneWidget);
    expect(find.text('Final stage flavor text'), findsOneWidget);
    expect(find.text('30 steps'), findsOneWidget);
  });

  testWidgets('shows hatch banner when crossing from egg to Squidge', (
    tester,
  ) async {
    setLargeScreenSize(tester);

    await tester.pumpWidget(buildTestWidget(0));
    await tester.pump();

    await tester.pumpWidget(buildTestWidget(10));
    await tester.pump();

    expect(
      find.text('🥚 Mysterious Egg hatched into Squidge!'),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
  });
}
