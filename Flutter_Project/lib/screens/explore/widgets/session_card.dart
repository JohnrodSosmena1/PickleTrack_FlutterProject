import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/coaching_session_listing.dart';
import 'request_coaching_sheet.dart';

class SessionCard extends StatelessWidget {
  final CoachingSessionListing session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDateTime(session.dateTime);

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Skill Level Chip & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13283E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryGreen.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    session.skillLevel,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '₱${session.price.toInt()}',
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Session Title
            Text(
              session.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            // Coach Name & Venue
            Row(
              children: [
                const Icon(Icons.person_rounded, size: 14, color: Color(0xFF9AA8BF)),
                const SizedBox(width: 4),
                Text(
                  session.coachName,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('•', style: TextStyle(color: Color(0xFF1B2B45))),
                const SizedBox(width: 8),
                const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primaryGreen),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${session.venue} (${session.city})',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF9AA8BF),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date & Time
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.primaryGreen),
                const SizedBox(width: 5),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Color(0xFF9AA8BF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Bottom Row: Slots Left Counter & "Request Session" Button
            Row(
              children: [
                // Slots Left badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: session.slotsLeft <= 2
                        ? const Color(0xFF2E151B)
                        : const Color(0xFF101E33),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: session.slotsLeft <= 2
                          ? Colors.redAccent.withValues(alpha: 0.4)
                          : const Color(0xFF1E3250),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group_outlined,
                        size: 14,
                        color: session.slotsLeft <= 2 ? Colors.redAccent : const Color(0xFF9AA8BF),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${session.slotsLeft} slots left',
                        style: TextStyle(
                          color: session.slotsLeft <= 2 ? Colors.redAccent : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Button: Request Session
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: session.isFull ? const Color(0xFF1E293B) : AppColors.neonLimeCard,
                      foregroundColor: session.isFull ? const Color(0xFF94A3B8) : const Color(0xFF070E1A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: session.isFull
                        ? null
                        : () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => RequestCoachingSheet(session: session),
                            );
                          },
                    child: Text(
                      session.isFull ? 'Session Full' : 'Request Session',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} · $hour:$minute $ampm';
  }
}
