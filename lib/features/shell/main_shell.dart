import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/design_system.dart';

/// Scaffold shell with 5-tab bottom navigation.
/// Order: Settings, Statistics, Home (center, elevated), Tools, Journal.
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
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: 'Settings',
          ),
          AppBottomNavItem(
            icon: Icons.bar_chart_outlined,
            activeIcon: Icons.bar_chart_rounded,
            label: 'Statistics',
          ),
          AppBottomNavItem(
            icon: Icons.home_rounded,
            activeIcon: Icons.home_rounded,
            label: 'Home',
            isSpecial: true,
          ),
          AppBottomNavItem(
            icon: Icons.category_outlined,
            activeIcon: Icons.category_rounded,
            label: 'Tools',
          ),
          AppBottomNavItem(
            icon: Icons.edit_note_outlined,
            activeIcon: Icons.edit_note_rounded,
            label: 'Journal',
          ),
        ],
      ),
    );
  }
}
