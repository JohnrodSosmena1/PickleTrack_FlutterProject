import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/invitation.dart';
import '../../providers/coaching_provider.dart';
import '../../providers/auth_provider.dart';
import '../rooms/create_room_screen.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final auth = context.watch<AuthProvider>();
    final currentUserId = auth.currentUser?.uid ?? 'user_juan';
    final invitations = coaching.userInvitations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaching Invitations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primaryGreen),
            tooltip: 'Invite to Room',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateRoomScreen()),
              );
            },
          ),
        ],
      ),
      body: invitations.isEmpty
          ? EmptyState(
              icon: Icons.mail_outline_rounded,
              title: 'No Invitations Yet',
              description: 'When players or coaches invite you to establish a Coaching Room, you can review and accept them here.',
              buttonText: 'Create Room / Invite',
              onButtonPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateRoomScreen()),
                );
              },
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: invitations.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final inv = invitations[index];
                final isRecipient = inv.playerId == currentUserId || inv.playerEmail == auth.currentUser?.email;
                return _InvitationCard(invitation: inv, isRecipient: isRecipient);
              },
            ),
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final Invitation invitation;
  final bool isRecipient;

  const _InvitationCard({
    required this.invitation,
    required this.isRecipient,
  });

  @override
  Widget build(BuildContext context) {
    final coaching = context.read<CoachingProvider>();
    final isPending = invitation.isPending;

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
                  name: isRecipient ? invitation.coachName : invitation.playerName,
                  imageUrl: isRecipient ? invitation.coachAvatarUrl : null,
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRecipient ? invitation.coachName : invitation.playerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isRecipient ? 'Invited You to Train' : 'Invited by You',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge.forInvitation(invitation.status),
              ],
            ),
            const Divider(height: 24),
            _infoRow('Program', invitation.proposedProgramName),
            const SizedBox(height: 6),
            _infoRow('Duration', invitation.proposedDuration),
            const SizedBox(height: 6),
            _infoRow('Proposed Start', DateFormatter.formatShort(invitation.proposedStartDate)),
            if (invitation.message != null && invitation.message!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Text(
                  '"${invitation.message}"',
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
            // Accept / Decline Buttons (Mockup Screen 14)
            if (isPending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await coaching.declineInvitation(invitation.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invitation declined.')),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.dangerRed,
                        side: const BorderSide(color: AppColors.dangerRed),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Decline', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await coaching.acceptInvitation(invitation.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invitation accepted! Coaching Room is now active.'),
                              backgroundColor: AppColors.primaryGreen,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonLimeCard,
                        foregroundColor: AppColors.deepNavy,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Accept', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }
}
