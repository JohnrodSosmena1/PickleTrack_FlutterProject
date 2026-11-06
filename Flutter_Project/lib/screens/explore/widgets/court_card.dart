import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/court.dart';
import '../court_details_screen.dart';

class CourtCard extends StatelessWidget {
  final Court court;

  const CourtCard({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
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
                builder: (_) => CourtDetailsScreen(courtId: court.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Name + Rate
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Court icon container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF15263F),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4), width: 1.2),
                      ),
                      child: const Center(
                        child: Icon(Icons.sports_tennis_rounded, color: AppColors.primaryGreen, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Name & City
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            court.name,
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
                                '${court.address.split(',').first}, ${court.city}',
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
                          '₱${court.hourlyRate.toInt()}',
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

                // Specs: Number of courts & Operating hours
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13283E),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${court.courtCount} ${court.courtCount == 1 ? 'Court' : 'Courts'}',
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF9AA8BF)),
                    const SizedBox(width: 4),
                    Text(
                      'Open ${court.operatingHours}',
                      style: const TextStyle(
                        color: Color(0xFF9AA8BF),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Facility chips + Coach count badge
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...court.facilities.map((f) => _buildChip(f)),
                    if (court.coachIds.isNotEmpty)
                      _buildCoachCountChip(court.coachIds.length),
                  ],
                ),
                const SizedBox(height: 14),

                // Button: View Court Details
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: AppColors.neonLimeCard,
                      foregroundColor: const Color(0xFF070E1A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CourtDetailsScreen(courtId: court.id),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View Court Details',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF101E33),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E3250), width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFCBD5E1),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCoachCountChip(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF13283E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_pin_rounded, size: 13, color: AppColors.primaryGreen),
          const SizedBox(width: 4),
          Text(
            '$count ${count == 1 ? 'Coach' : 'Coaches'} affiliated',
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
