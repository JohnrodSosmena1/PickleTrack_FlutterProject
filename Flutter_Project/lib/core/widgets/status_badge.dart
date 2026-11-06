import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final IconData? icon;
  final double fontSize;
  final EdgeInsets padding;

  const StatusBadge({
    super.key,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    this.icon,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  /// Factory for Coaching Room status
  factory StatusBadge.forRoom(CoachingRoomStatus status) {
    switch (status) {
      case CoachingRoomStatus.active:
        return const StatusBadge(
          label: 'Active',
          textColor: AppColors.activeGreen,
          backgroundColor: AppColors.activeGreenBg,
          icon: Icons.circle,
        );
      case CoachingRoomStatus.completed:
        return const StatusBadge(
          label: 'Completed',
          textColor: AppColors.completedBlue,
          backgroundColor: AppColors.completedBlueBg,
          icon: Icons.check_circle_outline,
        );
      case CoachingRoomStatus.archived:
        return const StatusBadge(
          label: 'Archived',
          textColor: AppColors.archivedGray,
          backgroundColor: AppColors.archivedGrayBg,
          icon: Icons.archive_outlined,
        );
    }
  }

  /// Factory for Player Level
  factory StatusBadge.forPlayerLevel(PlayerLevel level) {
    switch (level) {
      case PlayerLevel.beginner:
        return const StatusBadge(
          label: 'Beginner',
          textColor: Color(0xFF4ADE80),
          backgroundColor: Color(0xFF0F2E1E),
          icon: Icons.shield_outlined,
        );
      case PlayerLevel.developing:
        return const StatusBadge(
          label: 'Developing',
          textColor: Color(0xFFFBBF24),
          backgroundColor: Color(0xFF281C08),
          icon: Icons.shield_outlined,
        );
      case PlayerLevel.intermediate:
        return const StatusBadge(
          label: 'Intermediate',
          textColor: Color(0xFF60A5FA),
          backgroundColor: Color(0xFF0C223E),
          icon: Icons.verified_outlined,
        );
      case PlayerLevel.advanced:
        return const StatusBadge(
          label: 'Advanced',
          textColor: Color(0xFFA78BFA),
          backgroundColor: Color(0xFF26103E),
          icon: Icons.stars_rounded,
        );
      case PlayerLevel.notEvaluated:
        return const StatusBadge(
          label: 'Not yet evaluated',
          textColor: AppColors.textSecondary,
          backgroundColor: Color(0xFF15202E),
          icon: Icons.info_outline,
        );
    }
  }

  /// Factory for Attendance
  factory StatusBadge.forAttendance(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return const StatusBadge(
          label: 'Present',
          textColor: AppColors.activeGreen,
          backgroundColor: AppColors.activeGreenBg,
        );
      case AttendanceStatus.absent:
        return const StatusBadge(
          label: 'Absent',
          textColor: AppColors.dangerRed,
          backgroundColor: AppColors.dangerRedBg,
        );
      case AttendanceStatus.late:
        return const StatusBadge(
          label: 'Late',
          textColor: AppColors.pendingAmber,
          backgroundColor: AppColors.pendingAmberBg,
        );
      case AttendanceStatus.excused:
        return const StatusBadge(
          label: 'Excused',
          textColor: AppColors.archivedGray,
          backgroundColor: AppColors.archivedGrayBg,
        );
    }
  }

  /// Factory for Invitation
  factory StatusBadge.forInvitation(InvitationStatus status) {
    switch (status) {
      case InvitationStatus.pending:
        return const StatusBadge(
          label: 'Pending',
          textColor: AppColors.pendingAmber,
          backgroundColor: AppColors.pendingAmberBg,
        );
      case InvitationStatus.accepted:
        return const StatusBadge(
          label: 'Accepted',
          textColor: AppColors.activeGreen,
          backgroundColor: AppColors.activeGreenBg,
        );
      case InvitationStatus.declined:
        return const StatusBadge(
          label: 'Declined',
          textColor: AppColors.dangerRed,
          backgroundColor: AppColors.dangerRedBg,
        );
      case InvitationStatus.cancelled:
        return const StatusBadge(
          label: 'Cancelled',
          textColor: AppColors.archivedGray,
          backgroundColor: AppColors.archivedGrayBg,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
