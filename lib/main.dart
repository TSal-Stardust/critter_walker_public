import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EggScreen(),
    );
  }
}

class EggScreen extends StatefulWidget {
  const EggScreen({super.key});

  @override
  State<EggScreen> createState() => _EggScreenState();
}

class _EggScreenState extends State<EggScreen> {
  int selectedIndex = 2;

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          children: const [
            Expanded(child: Center(child: Text('Hello world!'))),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarItem(
                icon: Icons.storefront_outlined,
                isSelected: selectedIndex == 0,
                onTap: () => onTabTapped(0),
              ),
              NavBarItem(
                icon: Icons.book_outlined,
                isSelected: selectedIndex == 1,
                onTap: () => onTabTapped(1),
              ),
              NavBarItem(
                icon: Icons.pets,
                isSelected: selectedIndex == 2,
                onTap: () => onTabTapped(2),
              ),
              NavBarItem(
                icon: Icons.favorite_border,
                isSelected: selectedIndex == 3,
                onTap: () => onTabTapped(3),
              ),
              NavBarItem(
                icon: Icons.settings_outlined,
                isSelected: selectedIndex == 4,
                onTap: () => onTabTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
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
    return Material(
      color: isSelected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
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
