import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/coaching_room.dart';
import '../../models/coaching_request.dart';
import '../../providers/coaching_provider.dart';
import '../../providers/auth_provider.dart';
import '../shared/coaching_room_details_screen.dart';
import 'create_room_screen.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  int _selectedTab = 0; // 0 = Active, 1 = Past, 2 = Requests

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final auth = context.watch<AuthProvider>();
    final isCoach = auth.isCoach;

    final activeRooms = coaching.activeRooms;
    final pastRooms = coaching.pastRooms;
    final pendingCoachReqs = coaching.pendingCoachRequests;
    final playerReqs = coaching.playerRequests;
    final requests = isCoach ? pendingCoachReqs : playerReqs;

    return Scaffold(
      backgroundColor: const Color(0xFF070E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070E1A),
        elevation: 0,
        title: const Text(
          'My Coaching Rooms',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Colors.white),
        ),
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
          // Segmented Tabs: Active | Past | Requests
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF0C1726),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF1B2C42), width: 1.2),
              ),
              child: Row(
                children: [
                  _buildTabButton('Active (${activeRooms.length})', 0),
                  _buildTabButton('Past (${pastRooms.length})', 1),
                  _buildTabButton(
                    'Requests (${requests.length})',
                    2,
                    hasAlert: isCoach && pendingCoachReqs.isNotEmpty,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Main Tab Content
          Expanded(
            child: _selectedTab == 0
                ? _buildActiveRoomsTab(activeRooms, isCoach, pendingCoachReqs)
                : _selectedTab == 1
                    ? _buildPastRoomsTab(pastRooms)
                    : _buildRequestsTab(requests, isCoach),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index, {bool hasAlert = false}) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.neonLimeCard : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  fontSize: 12,
                  color: isSelected ? const Color(0xFF070E1A) : const Color(0xFF9AA8BF),
                ),
              ),
              if (hasAlert && !isSelected) ...[
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveRoomsTab(
    List<CoachingRoom> activeRooms,
    bool isCoach,
    List<CoachingRequest> pendingCoachReqs,
  ) {
    if (activeRooms.isEmpty && (!isCoach || pendingCoachReqs.isEmpty)) {
      return EmptyState(
        icon: Icons.meeting_room_outlined,
        title: 'No Active Rooms',
        description: 'Invite a player or coach, or explore coaches to create your first Coaching Room.',
        buttonText: 'Create Room / Invite',
        onButtonPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateRoomScreen()),
          );
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
      children: [
        // Incoming Requests Banner for Coaches
        if (isCoach && pendingCoachReqs.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF13283E),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mark_email_unread_rounded, color: AppColors.primaryGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${pendingCoachReqs.length} Incoming Coaching Request${pendingCoachReqs.length == 1 ? '' : 's'}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Players want to start coaching programs with you.',
                        style: TextStyle(color: Color(0xFF9AA8BF), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedTab = 2),
                  child: const Text('Review', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ],

        ...activeRooms.map((room) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildRoomCard(room),
            )),
      ],
    );
  }

  Widget _buildPastRoomsTab(List<CoachingRoom> pastRooms) {
    if (pastRooms.isEmpty) {
      return const EmptyState(
        icon: Icons.archive_outlined,
        title: 'No Past Rooms',
        description: 'Completed training programs and archived rooms will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
      itemCount: pastRooms.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _buildRoomCard(pastRooms[index]),
        );
      },
    );
  }

  Widget _buildRequestsTab(List<CoachingRequest> requests, bool isCoach) {
    if (requests.isEmpty) {
      return EmptyState(
        icon: Icons.inbox_rounded,
        title: isCoach ? 'No Incoming Requests' : 'No Coaching Requests',
        description: isCoach
            ? 'When players request coaching or session slots from Explore, they will appear here.'
            : 'You have not submitted any coaching or clinic requests yet. Visit Explore to get started!',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return _buildRequestCard(req, isCoach);
      },
    );
  }

  Widget _buildRequestCard(CoachingRequest req, bool isCoach) {
    final coaching = context.read<CoachingProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B2B45), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  req.targetTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              _buildRequestStatusBadge(req.status),
            ],
          ),
          const SizedBox(height: 10),

          // Player / Coach Info
          Row(
            children: [
              Icon(
                isCoach ? Icons.person_rounded : Icons.sports_tennis_rounded,
                size: 14,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 6),
              Text(
                isCoach ? 'Player: ${req.playerName}' : 'Coach: ${req.coachName}',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Schedule & Skill
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 13, color: Color(0xFF9AA8BF)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Schedule: ${req.preferredSchedule} · ${req.skillLevel}',
                  style: const TextStyle(color: Color(0xFF9AA8BF), fontSize: 12),
                ),
              ),
            ],
          ),

          if (req.message != null && req.message!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF101E33),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '"${req.message}"',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ),
          ],

          // Actions for Coach on Pending requests
          if (isCoach && req.isPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 42),
                      side: const BorderSide(color: Color(0xFF223552)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await coaching.declineCoachingRequest(req.id);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Request declined.'),
                            backgroundColor: Color(0xFF1E293B),
                          ),
                        );
                      }
                    },
                    child: const Text('Decline', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 42),
                      backgroundColor: AppColors.neonLimeCard,
                      foregroundColor: const Color(0xFF070E1A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await coaching.acceptCoachingRequest(req.id);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Request accepted! A new Coaching Room has been created.'),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                        );
                        setState(() => _selectedTab = 0);
                      }
                    },
                    child: const Text('Accept & Create Room', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],

          // If accepted and player, show button to jump to active room
          if (!isCoach && req.isAccepted && req.requestType == CoachingRequestType.coaching) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  backgroundColor: AppColors.neonLimeCard,
                  foregroundColor: const Color(0xFF070E1A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.meeting_room_rounded, size: 16),
                label: const Text('Open Coaching Room', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                onPressed: () => setState(() => _selectedTab = 0),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequestStatusBadge(CoachingRequestStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case CoachingRequestStatus.pending:
        bg = const Color(0xFF2E2209);
        fg = const Color(0xFFFBBF24);
        label = 'Pending';
        break;
      case CoachingRequestStatus.accepted:
        bg = const Color(0xFF13283E);
        fg = AppColors.primaryGreen;
        label = 'Accepted';
        break;
      case CoachingRequestStatus.declined:
        bg = const Color(0xFF2E151B);
        fg = Colors.redAccent;
        label = 'Declined';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildRoomCard(CoachingRoom room) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B2B45), width: 1.2),
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
                          border: Border.all(color: const Color(0xFF0E1A2E), width: 2),
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
                            border: Border.all(color: const Color(0xFF0E1A2E), width: 2),
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
                    '${room.playerName}  •  ${room.coachName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textTertiary),
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
                    color: const Color(0xFF13283E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1B2B45)),
                  ),
                  child: Text(
                    '${room.totalSessions} Sessions',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomButton(
              text: 'Open Room',
              icon: Icons.arrow_forward,
              height: 40,
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
