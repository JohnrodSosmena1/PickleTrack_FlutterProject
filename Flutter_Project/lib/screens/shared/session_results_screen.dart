import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/drill_result.dart';
import '../../models/training_session.dart';

class SessionResultsScreen extends StatelessWidget {
  final TrainingSession session;
  final List<DrillResult> drillResults;

  const SessionResultsScreen({
    super.key,
    required this.session,
    required this.drillResults,
  });

  @override
  Widget build(BuildContext context) {
    final totalAttempts = drillResults.fold<int>(0, (sum, r) => sum + r.attempts);
    final totalSuccess = drillResults.fold<int>(0, (sum, r) => sum + r.successfulAttempts);
    final overallAccuracy = totalAttempts > 0
        ? ((totalSuccess / totalAttempts) * 100).toStringAsFixed(1)
        : '0.0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Results'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Session Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.heroCardGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryNavy.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.white70),
                            const SizedBox(width: 8),
                            Text(
                              DateFormatter.formatDate(session.sessionDate),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        StatusBadge.forAttendance(session.attendanceStatus),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _statBox(
                            title: 'Drills Completed',
                            value: '${drillResults.length}',
                            icon: Icons.sports_tennis_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statBox(
                            title: 'Overall Accuracy',
                            value: '$overallAccuracy%',
                            icon: Icons.track_changes_rounded,
                            isHighlight: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Drill Results Breakdown (Mockup Screen 8)
              const Text(
                'Drill Performance Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              if (drillResults.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No specific drill results recorded for this session.'),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: drillResults.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final result = drillResults[index];
                    return _buildDrillResultCard(result);
                  },
                ),
              const SizedBox(height: 24),

              // Feedback Card
              if (session.feedback != null && session.feedback!.isNotEmpty) ...[
                const Text(
                  'Coach & Partner Feedback',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreenLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.format_quote_rounded, color: AppColors.primaryGreenDark, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          session.feedback!,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Notes Card
              if (session.notes != null && session.notes!.isNotEmpty) ...[
                const Text(
                  'Session Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    session.notes!,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Return Button
              CustomButton(
                text: 'Return to Room',
                borderRadius: 30,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox({
    required String title,
    required String value,
    required IconData icon,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: isHighlight ? AppColors.ballYellow : Colors.white70),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isHighlight ? AppColors.ballYellow : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrillResultCard(DrillResult result) {
    final percent = (result.accuracy / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                result.drillName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: result.accuracy >= 70
                      ? AppColors.activeGreenBg
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: result.accuracy >= 70
                        ? AppColors.primaryGreen.withValues(alpha: 0.3)
                        : AppColors.borderLight,
                  ),
                ),
                child: Text(
                  '${result.accuracy.toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: result.accuracy >= 70
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Successful Reps: ${result.successfulAttempts} / ${result.attempts}',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                result.accuracy >= 70 ? AppColors.primaryGreen : AppColors.accentOrange,
              ),
            ),
          ),
          if (result.notes != null && result.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              result.notes!,
              style: const TextStyle(fontSize: 12, color: AppColors.textTertiary, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
