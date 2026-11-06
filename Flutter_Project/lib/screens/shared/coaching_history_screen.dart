import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/coaching_provider.dart';
import '../../providers/auth_provider.dart';
import 'coaching_room_details_screen.dart';

class CoachingHistoryScreen extends StatelessWidget {
  const CoachingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final auth = context.watch<AuthProvider>();
    final isCoach = auth.isCoach;

    final rooms = coaching.allUserRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaching History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: rooms.isEmpty
          ? const EmptyState(
              icon: Icons.history_edu_rounded,
              title: 'No Coaching History',
              description: 'Completed and active coaching rooms will be preserved here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: rooms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final room = rooms[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ProfileAvatar(
                              name: isCoach ? room.playerName : room.coachName,
                              imageUrl: isCoach ? room.playerAvatarUrl : room.coachAvatarUrl,
                              radius: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isCoach ? room.playerName : room.coachName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    room.programName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge.forRoom(room.status),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 14, color: AppColors.textTertiary),
                            const SizedBox(width: 6),
                            Text(
                              '${DateFormatter.formatShort(room.startDate)} – ${DateFormatter.formatShort(room.completedAt ?? room.plannedEndDate)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.sports_tennis_rounded,
                                size: 14, color: AppColors.textTertiary),
                            const SizedBox(width: 6),
                            Text(
                              '${room.totalSessions} sessions recorded',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomButton(
                          text: 'View Room',
                          height: 40,
                          borderRadius: 20,
                          isOutlined: !room.isActive,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CoachingRoomDetailsScreen(roomId: room.id),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
