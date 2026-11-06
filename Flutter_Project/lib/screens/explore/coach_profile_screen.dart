import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/coaching_provider.dart';
import 'widgets/request_coaching_sheet.dart';

class CoachProfileScreen extends StatelessWidget {
  final String coachId;

  const CoachProfileScreen({super.key, required this.coachId});

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final coach = coaching.getCoachProfile(coachId);

    if (coach == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF070E1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF070E1A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Text(
            'Coach profile not found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final initials = coach.displayName.isNotEmpty
        ? coach.displayName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join()
        : 'C';

    return Scaffold(
      backgroundColor: const Color(0xFF070E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070E1A),
        elevation: 0,
        title: const Text(
          'Coach Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: AppColors.neonLimeCard,
              foregroundColor: const Color(0xFF070E1A),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => RequestCoachingSheet(coach: coach),
              );
            },
            child: const Text(
              'Request Coaching',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0E1A2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF1B2B45), width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF15263F),
                      border: Border.all(color: AppColors.primaryGreen, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coach.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primaryGreen),
                            const SizedBox(width: 4),
                            Text(
                              coach.city,
                              style: const TextStyle(
                                color: Color(0xFF9AA8BF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: Color(0xFF23354E))),
                            const SizedBox(width: 8),
                            Text(
                              '${coach.yearsExperience} yrs exp',
                              style: const TextStyle(
                                color: Color(0xFF9AA8BF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF13283E),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            '₱${coach.hourlyRate.toInt()} / hour',
                            style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bio Section
            _buildSectionCard(
              title: 'About the Coach',
              icon: Icons.person_outline_rounded,
              child: Text(
                coach.bio,
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Specialties Section
            _buildSectionCard(
              title: 'Coaching Specialties',
              icon: Icons.stars_rounded,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: coach.specialties.map((spec) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13283E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.35)),
                    ),
                    child: Text(
                      spec,
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Target Skill Levels
            _buildSectionCard(
              title: 'Trained Skill Levels',
              icon: Icons.bar_chart_rounded,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: coach.skillLevels.map((lvl) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101E33),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF1E3250)),
                    ),
                    child: Text(
                      lvl,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Available Schedule
            _buildSectionCard(
              title: 'Typical Availability',
              icon: Icons.calendar_today_rounded,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      coach.availableSchedule,
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B2B45), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryGreen),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
