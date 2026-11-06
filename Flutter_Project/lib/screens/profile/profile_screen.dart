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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            // Custom PickleTrack Player/Coach Card (Dark Navy with Neon Lime Ring)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.35), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ProfileAvatar(
                    name: user?.fullName ?? 'Juan Dela Cruz',
                    imageUrl: user?.profilePictureUrl,
                    radius: 46,
                    showBorder: true,
                    borderColor: AppColors.primaryGreen,
                    onEdit: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.fullName ?? 'Juan Dela Cruz',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'juan@email.com',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  StatusBadge.forPlayerLevel(
                    latestEval?.assignedLevel ?? user?.playerLevel ?? PlayerLevel.intermediate,
                  ),
                  if (user?.bio != null && user!.bio!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      user.bio!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Quick Stats Row
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
            const SizedBox(height: 20),

            // Skill Overview Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Skill Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (latestEval != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.activeGreenBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'Score: ${latestEval.overallScore.toStringAsFixed(1)} / 10',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (latestEval != null) ...[
                    SkillBar(
                      skillName: 'Third-Shot Drop',
                      currentRating: latestEval.skillRatings['Third-Shot Drop'] ?? 7,
                    ),
                    const SizedBox(height: 4),
                    SkillBar(
                      skillName: 'Dinking',
                      currentRating: latestEval.skillRatings['Dinking'] ?? 7,
                    ),
                    const SizedBox(height: 4),
                    SkillBar(
                      skillName: 'Serve Placement',
                      currentRating: latestEval.skillRatings['Serve'] ?? 8,
                    ),
                    const SizedBox(height: 4),
                    SkillBar(
                      skillName: 'Reset Shots',
                      currentRating: latestEval.skillRatings['Reset Shots'] ?? 7,
                    ),
                  ] else ...[
                    const Text(
                      'Not yet evaluated. Complete an assessment in a Coaching Room.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Navigation Options List
            Material(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _menuTile(
                    icon: Icons.history_edu_rounded,
                    title: 'Coaching History',
                    subtitle: 'View completed training programs & archives',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CoachingHistoryScreen()),
                      );
                    },
                  ),
                  Container(height: 1, color: AppColors.border),
                  _menuTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'Invitations & Notifications',
                    subtitle: 'Check pending invitations to rooms',
                    badgeCount: coaching.pendingInvitationsCount,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const InvitationsScreen()),
                      );
                    },
                  ),
                  Container(height: 1, color: AppColors.border),
                  _menuTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile Details',
                    subtitle: 'Update your name, bio, and avatar',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            CustomButton(
              text: 'Log Out',
              icon: Icons.logout_rounded,
              isOutlined: true,
              backgroundColor: AppColors.dangerRed,
              textColor: AppColors.dangerRed,
              borderRadius: 30,
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
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
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

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: badgeCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: const BoxDecoration(
                color: AppColors.dangerRed,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
              ),
            )
          : const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}
