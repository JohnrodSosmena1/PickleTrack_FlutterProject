import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../providers/coaching_provider.dart';

class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final activities = coaching.allActivities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: activities.isEmpty
          ? const EmptyState(
              icon: Icons.history_rounded,
              title: 'No Activity History',
              description: 'Past coaching sessions, evaluations, and updates will be logged here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: activities.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final act = activities[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getActivityBgColor(act.type),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getActivityIcon(act.type),
                        color: _getActivityIconColor(act.type),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      act.type.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          act.description,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormatter.formatDateTime(act.createdAt),
                          style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.sessionRecorded:
        return Icons.sports_tennis_rounded;
      case ActivityType.evaluationUpdated:
        return Icons.insights_rounded;
      case ActivityType.feedbackAdded:
        return Icons.chat_bubble_outline_rounded;
      case ActivityType.invitationAccepted:
        return Icons.handshake_outlined;
      case ActivityType.programAssigned:
        return Icons.assignment_outlined;
      case ActivityType.playerLevelUpdated:
        return Icons.military_tech_outlined;
      case ActivityType.programCompleted:
        return Icons.verified_outlined;
      case ActivityType.drillResultsAdded:
        return Icons.playlist_add_check_rounded;
    }
  }

  Color _getActivityBgColor(ActivityType type) {
    switch (type) {
      case ActivityType.sessionRecorded:
      case ActivityType.programCompleted:
        return AppColors.activeGreenBg;
      case ActivityType.evaluationUpdated:
        return AppColors.completedBlueBg;
      case ActivityType.feedbackAdded:
        return AppColors.pendingAmberBg;
      default:
        return AppColors.surfaceVariant;
    }
  }

  Color _getActivityIconColor(ActivityType type) {
    switch (type) {
      case ActivityType.sessionRecorded:
      case ActivityType.programCompleted:
        return AppColors.activeGreen;
      case ActivityType.evaluationUpdated:
        return AppColors.completedBlue;
      case ActivityType.feedbackAdded:
        return AppColors.pendingAmber;
      default:
        return AppColors.deepNavy;
    }
  }
}
