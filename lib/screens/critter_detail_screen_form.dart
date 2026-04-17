import 'package:flutter/material.dart';
import '../models/creature_form.dart';

class CritterDetailScreenForm extends StatelessWidget {
  final CreatureForm form;

  const CritterDetailScreenForm({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            children: [
              Text(
                form.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2CBCD),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Image.asset(
                  form.assetPath,
                  height: 320,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.accessibility_new, size: 26),
                  const SizedBox(width: 6),
                  Text(
                    form.heightText,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(width: 18),
                  const Icon(Icons.scale, size: 26),
                  const SizedBox(width: 6),
                  Text(
                    form.weightText,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                form.biography,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
