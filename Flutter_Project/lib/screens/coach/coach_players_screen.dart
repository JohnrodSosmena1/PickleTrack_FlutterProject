import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/empty_state.dart';
import '../../providers/coaching_provider.dart';
import '../shared/coaching_room_details_screen.dart';
import 'invite_player_screen.dart';

class CoachPlayersScreen extends StatelessWidget {
  const CoachPlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final activeRooms = coaching.activeRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Players'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primaryGreen),
            tooltip: 'Invite Player',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InvitePlayerScreen()),
              );
            },
          ),
        ],
      ),
      body: activeRooms.isEmpty
          ? EmptyState(
              icon: Icons.people_outline_rounded,
              title: 'No Players Yet',
              description: 'Invite players by email to start personalized coaching programs.',
              buttonText: 'Invite Player',
              onButtonPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InvitePlayerScreen()),
                );
              },
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: activeRooms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final room = activeRooms[index];
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
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ProfileAvatar(
                            name: room.playerName,
                            imageUrl: room.playerAvatarUrl,
                            radius: 26,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.playerName,
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
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    StatusBadge.forPlayerLevel(PlayerLevel.intermediate),
                                    const SizedBox(width: 6),
                                    StatusBadge.forRoom(room.status),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
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
