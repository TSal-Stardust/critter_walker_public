import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:critter_walker/models/companion.dart';
import 'package:critter_walker/screens/compendium_screen.dart';

void main() {
  testWidgets('shows undiscovered entries when Squidge has not hatched', (
    tester,
  ) async {
    const roster = [
      Companion(
        id: 'starter',
        eggName: 'Mysterious Egg',
        currentSteps: 0,
        speciesId: null,
        isActive: true,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CompendiumScreen(roster: roster)),
      ),
    );

    expect(find.text('Undiscovered'), findsWidgets);
  });

  testWidgets('shows only first Squidge form discovered at 10 steps', (
    tester,
  ) async {
    const roster = [
      Companion(
        id: 'starter',
        eggName: 'Mysterious Egg',
        currentSteps: 10,
        speciesId: 'squidge',
        isActive: true,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CompendiumScreen(roster: roster)),
      ),
    );

    expect(find.text('Squidge (Hatchling)'), findsOneWidget);
    expect(find.text('Squidge (Juvenile)'), findsNothing);
    expect(find.text('Squidge (Final Form)'), findsNothing);
  });

  testWidgets('shows all Squidge forms discovered at 30 steps', (tester) async {
    const roster = [
      Companion(
        id: 'starter',
        eggName: 'Mysterious Egg',
        currentSteps: 30,
        speciesId: 'squidge',
        isActive: true,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CompendiumScreen(roster: roster)),
      ),
    );

    expect(find.text('Squidge (Hatchling)'), findsOneWidget);
    expect(find.text('Squidge (Juvenile)'), findsOneWidget);
    expect(find.text('Squidge (Final Form)'), findsOneWidget);
  });

  testWidgets('tapping discovered form opens detail screen', (tester) async {
    const roster = [
      Companion(
        id: 'starter',
        eggName: 'Mysterious Egg',
        currentSteps: 30,
        speciesId: 'squidge',
        isActive: true,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CompendiumScreen(roster: roster)),
      ),
    );

    await tester.tap(find.text('Squidge (Hatchling)'));
    await tester.pumpAndSettle();

    expect(find.text('Squidge (Hatchling)'), findsWidgets);
  });
}
