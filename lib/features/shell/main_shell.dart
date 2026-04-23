import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/design_system.dart';

/// Scaffold shell with 5-tab bottom navigation.
/// Code order: בית, תוכן, כלים, יומן, הגדרות.
/// Under app-wide RTL this renders visually as: הגדרות (left) → בית (right).
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          AppBottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'בית',
          ),
          AppBottomNavItem(
            icon: Icons.play_circle_outline_rounded,
            activeIcon: Icons.play_circle_rounded,
            label: 'תוכן',
          ),
          AppBottomNavItem(
            icon: Icons.category_outlined,
            activeIcon: Icons.category_rounded,
            label: 'כלים',
          ),
          AppBottomNavItem(
            icon: Icons.edit_note_outlined,
            activeIcon: Icons.edit_note_rounded,
            label: 'יומן',
          ),
          AppBottomNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: 'הגדרות',
          ),
        ],
      ),
    );
  }
}
