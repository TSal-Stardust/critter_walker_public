import 'dart:async';

import 'package:flutter/material.dart';

import '../models/companion.dart';
import '../services/creature_catalog.dart';
import '../services/progress_storage.dart';
import '../services/step_tracking_service.dart';
import 'compendium_screen.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final ProgressStorage _progressStorage = ProgressStorage();
  final StepTrackingService _stepTrackingService = StepTrackingService();

  StreamSubscription<int>? _stepDeltaSubscription;

  int selectedIndex = 0;
  bool isLoading = true;
  List<Companion> roster = [];

  @override
  void initState() {
    super.initState();
    _loadRoster();
  }

  @override
  void dispose() {
    _stepDeltaSubscription?.cancel();
    _stepTrackingService.dispose();
    super.dispose();
  }

  Future<void> _loadRoster() async {
    final savedRoster = await _progressStorage.loadRoster();

    if (!mounted) return;

    setState(() {
      if (savedRoster.isNotEmpty) {
        roster = savedRoster;
      } else {
        roster = const [
          Companion(
            id: 'starter_egg_1',
            eggName: CreatureCatalog.mysteriousEggName,
            currentSteps: 0,
            speciesId: null,
            isActive: true,
          ),
        ];
      }
      isLoading = false;
    });

    await _progressStorage.saveRoster(roster);
    await _startStepTracking();
  }

  Future<void> _startStepTracking() async {
    await _stepTrackingService.start();

    await _stepDeltaSubscription?.cancel();
    _stepDeltaSubscription = _stepTrackingService.stepDeltaStream.listen(
      (int delta) {
        final companion = activeCompanion;
        if (companion == null || delta <= 0) {
          return;
        }

        final updatedCompanion = companion.copyWith(
          currentSteps: companion.currentSteps + delta,
        );

        _updateCompanion(updatedCompanion);
      },
      onError: (Object error) {
        debugPrint('Step delta stream error: $error');
      },
    );
  }

  Future<void> _saveRoster() async {
    await _progressStorage.saveRoster(roster);
  }

  Companion? get activeCompanion {
    try {
      return roster.firstWhere((companion) => companion.isActive);
    } catch (_) {
      return roster.isNotEmpty ? roster.first : null;
    }
  }

  Future<void> _updateCompanion(Companion updatedCompanion) async {
    final hatchThreshold = CreatureCatalog.hatchThresholdForEgg(
      updatedCompanion.eggName,
    );

    Companion resolvedCompanion = updatedCompanion;

    if (resolvedCompanion.speciesId == null &&
        resolvedCompanion.currentSteps >= hatchThreshold) {
      resolvedCompanion = resolvedCompanion.copyWith(
        speciesId: CreatureCatalog.speciesIdForEgg(resolvedCompanion.eggName),
      );
    }

    setState(() {
      roster = roster.map((companion) {
        return companion.id == resolvedCompanion.id
            ? resolvedCompanion
            : companion;
      }).toList();
    });

    await _saveRoster();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    final companion = activeCompanion;

    final pages = [
      HomeScreen(companion: companion, onCompanionChanged: _updateCompanion),
      CompendiumScreen(roster: roster),
      const Placeholder(),
      const Placeholder(),
      const Placeholder(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarItem(
                icon: Icons.pets,
                isSelected: selectedIndex == 0,
                onTap: () => _onTabTapped(0),
              ),
              NavBarItem(
                icon: Icons.book_outlined,
                isSelected: selectedIndex == 1,
                onTap: () => _onTabTapped(1),
              ),
              NavBarItem(
                icon: Icons.favorite_border,
                isSelected: selectedIndex == 2,
                onTap: () => _onTabTapped(2),
              ),
              NavBarItem(
                icon: Icons.storefront_outlined,
                isSelected: selectedIndex == 3,
                onTap: () => _onTabTapped(3),
              ),
              NavBarItem(
                icon: Icons.settings_outlined,
                isSelected: selectedIndex == 4,
                onTap: () => _onTabTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 30, color: Colors.black87),
        ),
      ),
    );
  }
}
