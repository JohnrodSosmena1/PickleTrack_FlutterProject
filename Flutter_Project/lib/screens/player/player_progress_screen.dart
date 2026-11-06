import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/skill_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../../providers/coaching_provider.dart';

class PlayerProgressScreen extends StatefulWidget {
  const PlayerProgressScreen({super.key});

  @override
  State<PlayerProgressScreen> createState() => _PlayerProgressScreenState();
}

class _PlayerProgressScreenState extends State<PlayerProgressScreen> {
  int _selectedTab = 0; // 0 = Skills, 1 = Drill Accuracy, 2 = Goals

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final activeRoom = coaching.activeRoom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
      ),
      body: activeRoom == null
          ? const EmptyState(
              icon: Icons.insights_rounded,
              title: 'No Progress Data',
              description: 'Progress data is generated as your coach completes skill assessments and court sessions.',
            )
          : Column(
              children: [
                // Segmented Tabs: Skills | Drill Accuracy | Goals
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _tabButton(0, 'Skills'),
                        _tabButton(1, 'Drill Accuracy'),
                        _tabButton(2, 'Goals'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _selectedTab == 0
                        ? _buildSkillsTab(coaching, activeRoom.id)
                        : _selectedTab == 1
                            ? _buildAccuracyTab(coaching, activeRoom.id)
                            : _buildGoalsTab(activeRoom),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _tabButton(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsTab(CoachingProvider coaching, String roomId) {
    final latestEval = coaching.getLatestEvaluation(roomId);
    final initialEval = coaching.getInitialEvaluation(roomId);

    if (latestEval == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No evaluations have been recorded yet.'),
        ),
      );
    }

    final diff = initialEval != null
        ? double.parse((latestEval.overallScore - initialEval.overallScore).toStringAsFixed(1))
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skill Ratings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // Skill Bars
        for (final entry in latestEval.skillRatings.entries)
          SkillBar(
            skillName: entry.key,
            rating: entry.value,
            initialRating: initialEval?.skillRatings[entry.key],
          ),

        const SizedBox(height: 24),

        // Overall Progress Banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${latestEval.overallScore} / 10',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (diff != 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          diff > 0 ? '(+$diff since initial)' : '($diff since initial)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: diff > 0 ? AppColors.activeGreen : AppColors.dangerRed,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreenLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.trending_up, color: AppColors.primaryGreen, size: 24),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccuracyTab(CoachingProvider coaching, String roomId) {
    final results = coaching.getDrillResultsForRoom(roomId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Courtside Drill Accuracy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Official accuracy logged courtside by your coach during training sessions.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),

        if (results.isEmpty)
          const Text('No drill results recorded yet.')
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: results.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final r = results[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.drillName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${r.successfulAttempts} of ${r.attempts} attempts successful',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreenLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${r.accuracy.toInt()}%',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildGoalsTab(dynamic room) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Program Goals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.stars_rounded, color: AppColors.primaryGreen, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Primary Objective',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  room.mainGoal,
                  style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        for (final g in room.secondaryGoals) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.primaryGreen, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      g,
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
