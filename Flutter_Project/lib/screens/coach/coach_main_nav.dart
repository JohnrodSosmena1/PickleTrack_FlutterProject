import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'coach_dashboard_screen.dart';
import 'coach_players_screen.dart';
import 'coach_programs_screen.dart';
import 'coach_profile_screen.dart';

class CoachMainNav extends StatefulWidget {
  final int initialIndex;
  const CoachMainNav({super.key, this.initialIndex = 0});

  @override
  State<CoachMainNav> createState() => _CoachMainNavState();
}

class _CoachMainNavState extends State<CoachMainNav> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    CoachDashboardScreen(),
    CoachPlayersScreen(),
    CoachProgramsScreen(),
    CoachProfileScreen(),
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
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people_alt_rounded),
              label: 'Players',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment_rounded),
              label: 'Programs',
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
