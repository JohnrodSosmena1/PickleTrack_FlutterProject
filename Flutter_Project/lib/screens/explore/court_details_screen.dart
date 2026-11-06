import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/coach_profile.dart';
import '../../providers/coaching_provider.dart';
import 'coach_profile_screen.dart';

class CourtDetailsScreen extends StatelessWidget {
  final String courtId;

  const CourtDetailsScreen({super.key, required this.courtId});

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final court = coaching.getCourt(courtId);

    if (court == null) {
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
            'Court details not found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final affiliatedCoaches = coaching.getCoachesForCourt(court);

    return Scaffold(
      backgroundColor: const Color(0xFF070E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070E1A),
        elevation: 0,
        title: const Text(
          'Court Details',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Banner / Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF0E1A2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF1B2B45), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF13283E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.35)),
                        ),
                        child: Text(
                          court.city,
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '₱${court.hourlyRate.toInt()} / hr',
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    court.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primaryGreen),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          court.address,
                          style: const TextStyle(
                            color: Color(0xFF9AA8BF),
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Court Specs Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0E1A2E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1B2B45), width: 1.2),
              ),
              child: Column(
                children: [
                  _buildSpecRow(
                    Icons.sports_tennis_rounded,
                    'Available Courts',
                    '${court.courtCount} dedicated pickleball courts',
                  ),
                  const Divider(color: Color(0xFF1B2B45), height: 24),
                  _buildSpecRow(
                    Icons.access_time_rounded,
                    'Operating Hours',
                    'Open daily ${court.operatingHours}',
                  ),
                  const Divider(color: Color(0xFF1B2B45), height: 24),
                  _buildSpecRow(
                    Icons.payments_outlined,
                    'Standard Court Rate',
                    '₱${court.hourlyRate.toInt()} per hour (advance reservation)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Facilities & Amenities
            Container(
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
                  const Row(
                    children: [
                      Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.primaryGreen),
                      SizedBox(width: 6),
                      Text(
                        'Facilities & Amenities',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: court.facilities.map((fac) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF101E33),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF1E3250)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.done_rounded, size: 13, color: AppColors.primaryGreen),
                            const SizedBox(width: 6),
                            Text(
                              fac,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Affiliated Coaches
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Affiliated Coaches',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${affiliatedCoaches.length} Available',
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (affiliatedCoaches.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E1A2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1B2B45)),
                ),
                child: const Text(
                  'No coaches currently affiliated with this court facility.',
                  style: TextStyle(color: Color(0xFF9AA8BF), fontSize: 13),
                ),
              )
            else
              ...affiliatedCoaches.map((c) => _buildCoachItem(context, c)),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryGreen),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF9AA8BF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoachItem(BuildContext context, CoachProfile coach) {
    final initials = coach.displayName.isNotEmpty
        ? coach.displayName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join()
        : 'C';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B2B45)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF15263F),
            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4)),
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ),
        title: Text(
          coach.displayName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          '${coach.specialties.take(2).join(", ")} · ₱${coach.hourlyRate.toInt()}/hr',
          style: const TextStyle(
            color: Color(0xFF9AA8BF),
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primaryGreen),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CoachProfileScreen(coachId: coach.userId),
            ),
          );
        },
      ),
    );
  }
}
