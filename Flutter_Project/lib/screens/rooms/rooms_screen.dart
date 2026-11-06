import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/coaching_room.dart';
import '../../providers/coaching_provider.dart';
import '../shared/coaching_room_details_screen.dart';
import 'create_room_screen.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  int _selectedTab = 0; // 0 = Active, 1 = Past

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final activeRooms = coaching.activeRooms;
    final pastRooms = coaching.pastRooms;
    final displayedRooms = _selectedTab == 0 ? activeRooms : pastRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Coaching Rooms',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateRoomScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryGreen, width: 1.2),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 14, color: AppColors.primaryGreen),
                    SizedBox(width: 4),
                    Text(
                      'Invite / New',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.neonLimeCard,
        foregroundColor: AppColors.deepNavy,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.deepNavy),
        label: const Text(
          'Invite / New Room',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.deepNavy),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateRoomScreen()),
          );
        },
      ),
      body: Column(
        children: [
          // Segmented Tabs: Active | Past
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 46,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? AppColors.neonLimeCard : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Active (${activeRooms.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: _selectedTab == 0 ? AppColors.deepNavy : AppColors.textSecondary,
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
                          color: _selectedTab == 1 ? AppColors.neonLimeCard : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Past (${pastRooms.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: _selectedTab == 1 ? AppColors.deepNavy : AppColors.textSecondary,
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
          const SizedBox(height: 6),

          // Rooms List
          Expanded(
            child: displayedRooms.isEmpty
                ? EmptyState(
                    icon: Icons.meeting_room_outlined,
                    title: _selectedTab == 0 ? 'No Active Rooms' : 'No Past Rooms',
                    description: _selectedTab == 0
                        ? 'Invite a player or coach to create your first Coaching Room.'
                        : 'Completed training programs and archived rooms will appear here.',
                    buttonText: _selectedTab == 0 ? 'Create Room / Invite' : null,
                    onButtonPressed: _selectedTab == 0
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const CreateRoomScreen()),
                            );
                          }
                        : null,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                    itemCount: displayedRooms.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final room = displayedRooms[index];
                      return _buildRoomCard(room);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(CoachingRoom room) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
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
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                StatusBadge.forRoom(room.status),
              ],
            ),
            const SizedBox(height: 14),

            // Overlapping Avatars & Names
            Row(
              children: [
                SizedBox(
                  width: 52,
                  height: 32,
                  child: Stack(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surface, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            room.coachName.isNotEmpty ? room.coachName.substring(0, 1).toUpperCase() : 'C',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              room.playerName.isNotEmpty ? room.playerName.substring(0, 1).toUpperCase() : 'P',
                              style: const TextStyle(color: AppColors.deepNavy, fontSize: 12, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${room.coachName} & ${room.playerName}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              height: 1,
              color: AppColors.border,
            ),
            const SizedBox(height: 14),

            // Metadata Row & View Room action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.date_range_rounded, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Text(
                      '${DateFormatter.formatShort(room.startDate)} – ${DateFormatter.formatShort(room.plannedEndDate)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    '${room.totalSessions} Sessions',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // View Room Button
            CustomButton(
              text: 'View Room',
              trailingIcon: Icons.arrow_forward_rounded,
              height: 44,
              borderRadius: 14,
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
