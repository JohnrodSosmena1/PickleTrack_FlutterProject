import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/coaching_provider.dart';
import 'widgets/coach_card.dart';
import 'widgets/court_card.dart';
import 'widgets/session_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _activeSegmentIndex = 0; // 0: Coaches, 1: Courts, 2: Sessions

  final List<String> _sessionSkillFilters = [
    'All levels',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final cities = coaching.availableCities;
    final selectedCity = coaching.selectedCity;
    final selectedSkill = coaching.selectedSessionSkill;

    final coaches = coaching.filteredCoaches;
    final courts = coaching.filteredCourts;
    final sessions = coaching.filteredSessions;

    return Scaffold(
      backgroundColor: const Color(0xFF070E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070E1A),
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primaryGreen, size: 20),
            tooltip: 'Filter Options',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Use the filter chips below to quickly sort coaches, courts, and sessions.'),
                  backgroundColor: Color(0xFF0E1A2E),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segmented Pill Control: Coaches | Courts | Sessions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF0C1726),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF1B2C42), width: 1.2),
              ),
              child: Row(
                children: [
                  _buildSegmentButton('Coaches', 0),
                  _buildSegmentButton('Courts', 1),
                  _buildSegmentButton('Sessions', 2),
                ],
              ),
            ),
          ),

          // Horizontal Filter Chips (Location / Skill)
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 10),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Location Filter Chips
                  ...cities.map((city) {
                    final isSelected = selectedCity.toLowerCase() == city.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(city),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF070E1A) : const Color(0xFF9AA8BF),
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 12,
                        ),
                        backgroundColor: const Color(0xFF0E1A2E),
                        selectedColor: AppColors.neonLimeCard,
                        side: BorderSide(
                          color: isSelected ? AppColors.neonLimeCard : const Color(0xFF1B2B45),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        showCheckmark: false,
                        onSelected: (_) {
                          coaching.setCityFilter(city);
                        },
                      ),
                    );
                  }),

                  // Extra Skill Level Filter Chips when on Sessions Tab
                  if (_activeSegmentIndex == 2) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 20,
                      width: 1,
                      color: const Color(0xFF1E3250),
                    ),
                    ..._sessionSkillFilters.map((skill) {
                      final isSelected = selectedSkill.toLowerCase() == skill.toLowerCase();
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(skill),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF070E1A) : const Color(0xFF9AA8BF),
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            fontSize: 12,
                          ),
                          backgroundColor: const Color(0xFF0E1A2E),
                          selectedColor: AppColors.neonLimeCard,
                          side: BorderSide(
                            color: isSelected ? AppColors.neonLimeCard : const Color(0xFF1B2B45),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          showCheckmark: false,
                          onSelected: (_) {
                            coaching.setSessionSkillFilter(skill);
                          },
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),

          // Main Tab List View
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildActiveTabContent(coaches, courts, sessions, selectedCity),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String label, int index) {
    final isSelected = _activeSegmentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _activeSegmentIndex = index);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.neonLimeCard : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF070E1A) : const Color(0xFF9AA8BF),
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(
    List coaches,
    List courts,
    List sessions,
    String selectedCity,
  ) {
    switch (_activeSegmentIndex) {
      case 0:
        if (coaches.isEmpty) {
          return _buildEmptyState(
            icon: Icons.person_search_rounded,
            title: 'No coaches found in this area',
            subtitle: 'Try selecting "All" or a different city to find active pickleball coaches.',
          );
        }
        return ListView.builder(
          key: const ValueKey('coaches_list'),
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
          itemCount: coaches.length,
          itemBuilder: (context, i) => CoachCard(coach: coaches[i]),
        );

      case 1:
        if (courts.isEmpty) {
          return _buildEmptyState(
            icon: Icons.stadium_outlined,
            title: 'No courts found in this area',
            subtitle: 'Try selecting "All" or a different city to discover pickleball facilities.',
          );
        }
        return ListView.builder(
          key: const ValueKey('courts_list'),
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
          itemCount: courts.length,
          itemBuilder: (context, i) => CourtCard(court: courts[i]),
        );

      case 2:
        if (sessions.isEmpty) {
          return _buildEmptyState(
            icon: Icons.event_busy_rounded,
            title: 'No sessions found in this area',
            subtitle: 'Try adjusting the city or skill level filter to view upcoming masterclasses.',
          );
        }
        return ListView.builder(
          key: const ValueKey('sessions_list'),
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
          itemCount: sessions.length,
          itemBuilder: (context, i) => SessionCard(session: sessions[i]),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF0E1A2E),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1B2B45)),
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF9AA8BF),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
