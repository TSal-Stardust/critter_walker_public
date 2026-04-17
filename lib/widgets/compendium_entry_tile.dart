import 'package:flutter/material.dart';

class CompendiumEntryTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isDiscovered;
  final VoidCallback onTap;

  const CompendiumEntryTile({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isDiscovered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAD5F1),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 42,
                height: 42,
                fit: BoxFit.contain,
                color: isDiscovered ? null : Colors.black54,
                colorBlendMode: isDiscovered ? null : BlendMode.srcIn,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
