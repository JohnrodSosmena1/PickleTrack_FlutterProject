import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';
import '../../providers/coaching_provider.dart';
import '../shared/edit_profile_screen.dart';
import '../shared/invitations_screen.dart';
import '../shared/activity_history_screen.dart';
import '../shared/coaching_history_screen.dart';
import '../auth/login_screen.dart';

class CoachProfileScreen extends StatelessWidget {
  const CoachProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final coaching = context.watch<CoachingProvider>();
    final user = auth.currentUser;
    final activeRooms = coaching.activeRooms;
    final allRooms = coaching.allUserRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Profile'),
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
            // Coach Avatar
            ProfileAvatar(
              name: user?.fullName ?? 'Coach Mark',
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
              user?.fullName ?? 'Coach Mark',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                user?.specialization ?? 'Pickleball Coach',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreenDark,
                ),
              ),
            ),
            if (user?.bio != null && user!.bio!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                user.bio!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
              ),
            ],
            const SizedBox(height: 24),

            // Coach Stats Row
            Row(
              children: [
                _statCard('${activeRooms.isNotEmpty ? activeRooms.length * 3 : 3}', 'Active\nPlayers'),
                const SizedBox(width: 10),
                _statCard('${allRooms.length}', 'Coaching\nRooms'),
                const SizedBox(width: 10),
                _statCard('${coaching.pendingInvitationsCount}', 'Pending\nInvites'),
              ],
            ),
            const SizedBox(height: 24),

            // Menu Options
            _navTile(
              icon: Icons.mail_outline_rounded,
              title: 'Sent Invitations',
              subtitle: 'Track sent onboarding invitations',
              badge: coaching.pendingInvitationsCount > 0 ? '${coaching.pendingInvitationsCount}' : null,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InvitationsScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            _navTile(
              icon: Icons.history_edu_rounded,
              title: 'Coaching History',
              subtitle: 'View active and completed rooms',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CoachingHistoryScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            _navTile(
              icon: Icons.history_rounded,
              title: 'Recent Activity Logs',
              subtitle: 'Review logged training events and evaluations',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ActivityHistoryScreen()),
                );
              },
            ),
            const SizedBox(height: 28),

            // Sign Out
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
                fontSize: 18,
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
                height: 1.2,
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
                  color: AppColors.pendingAmber,
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
