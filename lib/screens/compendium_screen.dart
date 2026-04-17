import 'package:flutter/material.dart';
import '../models/companion.dart';
import '../services/creature_catalog.dart';
import '../widgets/compendium_entry_tile.dart';
import 'critter_detail_screen_form.dart';

class CompendiumScreen extends StatelessWidget {
  final List<Companion> roster;

  const CompendiumScreen({super.key, required this.roster});

  bool _isFormDiscovered(String speciesId, int requiredSteps) {
    return roster.any(
      (companion) =>
          companion.speciesId == speciesId &&
          companion.currentSteps >= requiredSteps,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Critter Compendium',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: CreatureCatalog.forms.length,
              itemBuilder: (context, index) {
                final form = CreatureCatalog.forms[index];
                final discovered = _isFormDiscovered(
                  form.speciesId,
                  form.requiredSteps,
                );

                return CompendiumEntryTile(
                  title: discovered ? form.name : 'Undiscovered',
                  imagePath: form.assetPath,
                  isDiscovered: discovered,
                  onTap: () {
                    if (!discovered) return;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CritterDetailScreenForm(form: form),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
