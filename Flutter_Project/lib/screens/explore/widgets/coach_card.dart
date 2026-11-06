import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/coach_profile.dart';
import '../coach_profile_screen.dart';
import 'request_coaching_sheet.dart';

class CoachCard extends StatelessWidget {
  final CoachProfile coach;

  const CoachCard({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final initials = coach.displayName.isNotEmpty
        ? coach.displayName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join()
        : 'C';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B2B45), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CoachProfileScreen(coachId: coach.userId),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Avatar + Name + Rate
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF15263F),
                        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4), width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Name & Experience
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coach.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 13, color: AppColors.primaryGreen),
                              const SizedBox(width: 3),
                              Text(
                                '${coach.city} · ${coach.yearsExperience} yrs exp',
                                style: const TextStyle(
                                  color: Color(0xFF9AA8BF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Hourly Rate
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₱${coach.hourlyRate.toInt()}',
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          '/ hr',
                          style: TextStyle(
                            color: Color(0xFF9AA8BF),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Specialty tagline
                Text(
                  coach.specialties.isNotEmpty
                      ? 'Specializes in ${coach.specialties.join(", ")}'
                      : coach.bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),

                // Skill level & specialty tag chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...coach.skillLevels.map((lvl) => _buildTag(lvl, isLevel: true)),
                    ...coach.specialties.take(2).map((s) => _buildTag(s)),
                  ],
                ),
                const SizedBox(height: 14),

                // Buttons: View Profile & Request Coaching
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          side: const BorderSide(color: Color(0xFF223552), width: 1.2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CoachProfileScreen(coachId: coach.userId),
                            ),
                          );
                        },
                        child: const Text(
                          'View Profile',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          backgroundColor: AppColors.neonLimeCard,
                          foregroundColor: const Color(0xFF070E1A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, {bool isLevel = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLevel ? const Color(0xFF13283E) : const Color(0xFF101E33),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLevel
              ? AppColors.primaryGreen.withValues(alpha: 0.3)
              : const Color(0xFF1E3250),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isLevel ? AppColors.primaryGreen : const Color(0xFF9AA8BF),
          fontSize: 11,
          fontWeight: isLevel ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}
