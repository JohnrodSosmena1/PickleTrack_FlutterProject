import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/skill_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';
import '../../providers/coaching_provider.dart';
import '../shared/edit_profile_screen.dart';
import '../shared/coaching_history_screen.dart';
import '../shared/invitations_screen.dart';
import '../auth/login_screen.dart';

class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final coaching = context.watch<CoachingProvider>();
    final user = auth.currentUser;
    final activeRoom = coaching.activeRoom;
    final latestEval = activeRoom != null ? coaching.getLatestEvaluation(activeRoom.id) : null;

    final totalSessions = coaching.allUserRooms.fold<int>(0, (sum, r) => sum + r.totalSessions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar & Player Identity
            ProfileAvatar(
              name: user?.fullName ?? 'Player',
              imageUrl: user?.profilePictureUrl,
              radius: 46,
              onEdit: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              user?.fullName ?? 'Player',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            StatusBadge.forPlayerLevel(
              latestEval?.assignedLevel ?? user?.playerLevel ?? PlayerLevel.intermediate,
            ),
            if (user?.bio != null && user!.bio!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                user.bio!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 24),

            // Quick Stats Row (Screen 15 Mockup)
            Row(
              children: [
                _statCard('${coaching.allUserRooms.length}', 'Active Rooms'),
                const SizedBox(width: 10),
                _statCard('$totalSessions', 'Total Sessions'),
                const SizedBox(width: 10),
                _statCard(
                  DateFormatter.formatMonthYear(user?.createdAt),
                  'Member Since',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Skill Overview Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Skill Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (latestEval != null) ...[
                      for (final entry in latestEval.skillRatings.entries.take(6))
                        SkillBar(
                          skillName: entry.key,
                          rating: entry.value,
                          height: 6,
                        ),
                    ] else ...[
                      const Text(
                        'Not yet evaluated by a coach.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Navigation Options
            _navTile(
              icon: Icons.history_edu_rounded,
              title: 'Coaching History',
              subtitle: 'View active and completed coaching rooms',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CoachingHistoryScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            _navTile(
              icon: Icons.mail_outline_rounded,
              title: 'Invitations',
              subtitle: 'Check pending coach training invites',
              badge: coaching.pendingInvitationsCount > 0
                  ? '${coaching.pendingInvitationsCount}'
                  : null,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InvitationsScreen()),
                );
              },
            ),
            const SizedBox(height: 24),

            // Log Out Button
            CustomButton(
              text: 'Sign Out',
              isOutlined: true,
              backgroundColor: AppColors.dangerRed,
              textColor: AppColors.dangerRed,
              borderRadius: 30,
              icon: Icons.logout_rounded,
              onPressed: () async {
                await auth.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGreenLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryGreenDark, size: 20),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.dangerRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
      ),
    );
  }
}
