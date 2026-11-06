import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/coaching_room.dart';
import '../../providers/coaching_provider.dart';
import '../shared/coaching_room_details_screen.dart';

class PlayerCoachingRoomsScreen extends StatefulWidget {
  const PlayerCoachingRoomsScreen({super.key});

  @override
  State<PlayerCoachingRoomsScreen> createState() => _PlayerCoachingRoomsScreenState();
}

class _PlayerCoachingRoomsScreenState extends State<PlayerCoachingRoomsScreen> {
  int _selectedTab = 0; // 0 = Active, 1 = Past

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final activeRooms = coaching.activeRooms;
    final pastRooms = coaching.pastRooms;
    final displayedRooms = _selectedTab == 0 ? activeRooms : pastRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Coaching Rooms'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Segmented Tabs: Active | Past
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? AppColors.primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Active',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _selectedTab == 0 ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? AppColors.primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Past',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _selectedTab == 1 ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Rooms List
          Expanded(
            child: displayedRooms.isEmpty
                ? EmptyState(
                    icon: Icons.meeting_room_outlined,
                    title: _selectedTab == 0 ? 'No Active Rooms' : 'No Past Rooms',
                    description: _selectedTab == 0
                        ? 'When a coach invites you and you accept, your private Coaching Room appears here.'
                        : 'Completed coaching engagements are preserved here for your review.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: displayedRooms.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final room = displayedRooms[index];
                      return _PlayerRoomCard(room: room);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PlayerRoomCard extends StatelessWidget {
  final CoachingRoom room;

  const _PlayerRoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileAvatar(
                  name: room.coachName,
                  imageUrl: room.coachAvatarUrl,
                  radius: 24,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.coachName,
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
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.schedule_outlined, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 6),
                Text(
                  '${DateFormatter.formatShort(room.startDate)} – ${DateFormatter.formatShort(room.completedAt ?? room.plannedEndDate)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            if (room.isActive) ...[
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.sports_tennis_rounded, size: 14, color: AppColors.primaryGreen),
                  SizedBox(width: 6),
                  Text(
                    'Next Session: Oct 27, 2026 • 5:00 PM',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            CustomButton(
              text: 'View Room',
              borderRadius: 12,
              height: 44,
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
  }
}
