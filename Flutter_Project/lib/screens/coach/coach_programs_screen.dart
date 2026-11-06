import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/empty_state.dart';
import '../../providers/coaching_provider.dart';
import '../shared/coaching_room_details_screen.dart';
import '../shared/drill_library_screen.dart';
import 'invite_player_screen.dart';

class CoachProgramsScreen extends StatelessWidget {
  const CoachProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final rooms = coaching.allUserRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaching Programs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_outlined, color: AppColors.primaryGreen),
            tooltip: 'Drill Library',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DrillLibraryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primaryGreen),
            tooltip: 'New Program / Invite Player',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InvitePlayerScreen()),
              );
            },
          ),
        ],
      ),
      body: rooms.isEmpty
          ? EmptyState(
              icon: Icons.assignment_outlined,
              title: 'No Coaching Programs',
              description: 'Create personalized training programs by inviting players.',
              buttonText: 'Create Program',
              onButtonPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InvitePlayerScreen()),
                );
              },
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: rooms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final room = rooms[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CoachingRoomDetailsScreen(roomId: room.id),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  room.programName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              StatusBadge.forRoom(room.status),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Player: ${room.playerName}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreenDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Goal: ${room.mainGoal}',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${DateFormatter.formatShort(room.startDate)} – ${DateFormatter.formatShort(room.completedAt ?? room.plannedEndDate)}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
                              ),
                              Text(
                                '${room.totalSessions} sessions',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
