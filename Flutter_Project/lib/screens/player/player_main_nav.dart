import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'player_dashboard_screen.dart';
import 'player_training_screen.dart';
import 'player_progress_screen.dart';
import 'player_profile_screen.dart';

class PlayerMainNav extends StatefulWidget {
  final int initialIndex;
  const PlayerMainNav({super.key, this.initialIndex = 0});

  @override
  State<PlayerMainNav> createState() => _PlayerMainNavState();
}

class _PlayerMainNavState extends State<PlayerMainNav> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    PlayerDashboardScreen(),
    PlayerTrainingScreen(),
    PlayerProgressScreen(),
    PlayerProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_outlined),
              activeIcon: Icon(Icons.fitness_center_rounded),
              label: 'Training',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_rounded),
              activeIcon: Icon(Icons.insights_rounded),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
