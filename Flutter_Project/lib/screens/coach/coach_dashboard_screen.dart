import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/coaching_provider.dart';
import '../shared/coaching_room_details_screen.dart';
import '../shared/drill_library_screen.dart';
import '../shared/invitations_screen.dart';
import 'invite_player_screen.dart';
import 'record_session_screen.dart';
import 'coach_players_screen.dart';

class CoachDashboardScreen extends StatelessWidget {
  const CoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final coaching = context.watch<CoachingProvider>();
    final user = auth.currentUser;
    final activeRooms = coaching.activeRooms;
    final pendingCount = coaching.pendingInvitationsCount;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Greeting & Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning,\n${user?.fullName ?? "Coach Mark"}!',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Manage players and training programs.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  ProfileAvatar(
                    name: user?.fullName ?? 'Coach',
                    imageUrl: user?.profilePictureUrl,
                    radius: 26,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3 Quick Stat Cards (Screen 6 Mockup)
              Row(
                children: [
                  _statCard(
                    icon: Icons.people_alt_rounded,
                    value: '${activeRooms.isNotEmpty ? activeRooms.length * 3 : 3}',
                    label: 'Active\nPlayers',
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 10),
                  _statCard(
                    icon: Icons.calendar_today_rounded,
                    value: '3',
                    label: "Today's\nSessions",
                    color: AppColors.completedBlue,
                  ),
                  const SizedBox(width: 10),
                  _statCard(
                    icon: Icons.mail_outline_rounded,
                    value: '$pendingCount',
                    label: 'Pending\nInvites',
                    color: AppColors.pendingAmber,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const InvitationsScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions Bar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.person_add_alt, size: 18),
                      label: const Text('Invite Player'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const InvitePlayerScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.sports_tennis_rounded, size: 18),
                      label: const Text('Drill Library'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DrillLibraryScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // My Players Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Players',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CoachPlayersScreen()),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Players List (Screen 6 Mockup)
              _playerItem(
                name: 'John Santos',
                level: PlayerLevel.intermediate,
                status: 'Active',
                imageUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400&auto=format&fit=crop&q=80',
                onTap: () {
                  if (activeRooms.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CoachingRoomDetailsScreen(roomId: activeRooms.first.id),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              _playerItem(
                name: 'Alex Rivera',
                level: PlayerLevel.beginner,
                status: 'Active',
                imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80',
                onTap: () {},
              ),
              const SizedBox(height: 10),
              _playerItem(
                name: 'James Lee',
                level: PlayerLevel.developing,
                status: 'Active',
                imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // Today's Training Sessions
              const Text(
                "Today's Training",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              _trainingSessionItem(
                time: '5:00 PM',
                playerName: 'John Santos',
                drillFocus: 'Third-Shot Drop',
                onRecord: () {
                  if (activeRooms.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecordSessionScreen(
                          roomId: activeRooms.first.id,
                          playerId: activeRooms.first.playerId,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              _trainingSessionItem(
                time: '6:00 PM',
                playerName: 'Alex Rivera',
                drillFocus: 'Serving & Returns',
                onRecord: () {
                  if (activeRooms.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecordSessionScreen(
                          roomId: activeRooms.first.id,
                          playerId: 'player_alex',
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playerItem({
    required String name,
    required PlayerLevel level,
    required String status,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: ProfileAvatar(name: name, imageUrl: imageUrl, radius: 22),
        title: Text(
          name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        subtitle: Row(
          children: [
            Text(
              level.label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const Text(' • ', style: TextStyle(color: AppColors.textTertiary)),
            Text(
              status,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.activeGreen,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
      ),
    );
  }

  Widget _trainingSessionItem({
    required String time,
    required String playerName,
    required String drillFocus,
    required VoidCallback onRecord,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Text(
                  drillFocus,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sports_tennis_rounded, color: AppColors.primaryGreen),
            tooltip: 'Record Courtside Results',
            onPressed: onRecord,
          ),
        ],
      ),
    );
  }
}
