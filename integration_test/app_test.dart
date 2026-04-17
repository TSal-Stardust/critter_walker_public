import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:critter_walker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> launchApp(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
  }

  Future<void> goToCompendium(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.book_outlined));
    await tester.pumpAndSettle();
  }

  Future<void> goToHomeTab(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();
  }

  Future<void> resetToEggState(WidgetTester tester) async {
    await goToHomeTab(tester);

    final resetFinder = find.text('Reset');
    if (resetFinder.evaluate().isNotEmpty) {
      await tester.tap(resetFinder);
      await tester.pumpAndSettle();
    }

    expect(find.text('Mysterious Egg'), findsWidgets);
  }

  group('Critter Walker integration flow', () {
    testWidgets('app launches and shows initial egg state', (tester) async {
      await launchApp(tester);
      await resetToEggState(tester);

      expect(find.text('Mysterious Egg'), findsWidgets);
      expect(find.text('+1 Step'), findsOneWidget);
      expect(find.text('+5 Steps'), findsOneWidget);
      expect(find.text('+10 Steps'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);

      expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
      expect(find.byIcon(Icons.book_outlined), findsOneWidget);
      expect(find.byIcon(Icons.pets), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('compendium is locked before hatch', (tester) async {
      await launchApp(tester);
      await resetToEggState(tester);
      await goToCompendium(tester);

      expect(find.text('Critter Compendium'), findsOneWidget);
      expect(find.text('Undiscovered'), findsWidgets);
      expect(find.text('Squidge (Hatchling)'), findsNothing);
      expect(find.text('Squidge (Juvenile)'), findsNothing);
      expect(find.text('Squidge (Final Form)'), findsNothing);
    });

    testWidgets('egg hatches into Squidge after enough steps', (tester) async {
      await launchApp(tester);
      await resetToEggState(tester);

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Squidge'), findsWidgets);
      expect(
        find.text('🥚 Mysterious Egg hatched into Squidge!'),
        findsOneWidget,
      );

      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();
    });

    testWidgets('manual steps can fully evolve Squidge', (tester) async {
      await launchApp(tester);
      await resetToEggState(tester);

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Squidge'), findsWidgets);

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Squidge - Stage 2'), findsWidgets);

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Squidge - Final Stage'), findsWidgets);

      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();
    });

    testWidgets('compendium unlocks all forms after full evolution', (
      tester,
    ) async {
      await launchApp(tester);
      await resetToEggState(tester);

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();

      await goToCompendium(tester);

      expect(find.text('Critter Compendium'), findsOneWidget);
      expect(find.text('Squidge (Hatchling)'), findsOneWidget);
      expect(find.text('Squidge (Juvenile)'), findsOneWidget);
      expect(find.text('Squidge (Final Form)'), findsOneWidget);
    });

    testWidgets(
      'tapping a compendium entry opens detail screen and back works',
      (tester) async {
        await launchApp(tester);
        await resetToEggState(tester);

        await tester.tap(find.text('+10 Steps'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('+10 Steps'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('+10 Steps'));
        await tester.pumpAndSettle();

        await goToCompendium(tester);

        await tester.tap(find.text('Squidge (Hatchling)'));
        await tester.pumpAndSettle();

        expect(find.text('Squidge (Hatchling)'), findsWidgets);
        expect(
          find.textContaining('A freshly hatched Squidge'),
          findsOneWidget,
        );

        await tester.pageBack();
        await tester.pumpAndSettle();

        expect(find.text('Critter Compendium'), findsOneWidget);
        expect(find.text('Squidge (Juvenile)'), findsOneWidget);
      },
    );

    testWidgets('reset returns companion to egg state and relocks compendium', (
      tester,
    ) async {
      await launchApp(tester);
      await resetToEggState(tester);

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Squidge'), findsWidgets);

      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(find.text('Mysterious Egg'), findsWidgets);

      await goToCompendium(tester);

      expect(find.text('Undiscovered'), findsWidgets);
      expect(find.text('Squidge (Hatchling)'), findsNothing);
      expect(find.text('Squidge (Juvenile)'), findsNothing);
      expect(find.text('Squidge (Final Form)'), findsNothing);
    });

    testWidgets('navigation tabs remain usable throughout the flow', (
      tester,
    ) async {
      await launchApp(tester);
      await resetToEggState(tester);

      await goToCompendium(tester);
      expect(find.text('Critter Compendium'), findsOneWidget);

      await goToHomeTab(tester);
      expect(find.text('Mysterious Egg'), findsWidgets);

      await tester.tap(find.byIcon(Icons.pets));
      await tester.pumpAndSettle();
      expect(find.byType(Placeholder), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();
      expect(find.byType(Placeholder), findsOneWidget);

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(Placeholder), findsOneWidget);

      await goToHomeTab(tester);
      expect(find.text('Mysterious Egg'), findsWidgets);
    });

    testWidgets('full end to end user journey works', (tester) async {
      await launchApp(tester);
      await resetToEggState(tester);

      expect(find.text('Mysterious Egg'), findsWidgets);

      await goToCompendium(tester);
      expect(find.text('Undiscovered'), findsWidgets);

      await goToHomeTab(tester);

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Squidge'), findsWidgets);

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Squidge - Stage 2'), findsWidgets);

      await tester.tap(find.text('+10 Steps'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Squidge - Final Stage'), findsWidgets);

      await goToCompendium(tester);
      expect(find.text('Squidge (Hatchling)'), findsOneWidget);
      expect(find.text('Squidge (Juvenile)'), findsOneWidget);
      expect(find.text('Squidge (Final Form)'), findsOneWidget);

      await tester.tap(find.text('Squidge (Final Form)'));
      await tester.pumpAndSettle();
      expect(find.text('Squidge (Final Form)'), findsWidgets);
      expect(find.textContaining('A fully evolved Squidge'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await goToHomeTab(tester);
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(find.text('Mysterious Egg'), findsWidgets);

      await goToCompendium(tester);
      expect(find.text('Undiscovered'), findsWidgets);
    });
  });
}
