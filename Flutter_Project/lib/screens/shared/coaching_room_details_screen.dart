import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/skill_bar.dart';
import '../../models/coaching_room.dart';
import '../../providers/coaching_provider.dart';
import '../../providers/auth_provider.dart';
import 'evaluation_screen.dart';
import 'training_program_screen.dart';
import 'session_results_screen.dart';
import '../coach/record_session_screen.dart';
import 'drill_library_screen.dart';

class CoachingRoomDetailsScreen extends StatefulWidget {
  final String roomId;

  const CoachingRoomDetailsScreen({super.key, required this.roomId});

  @override
  State<CoachingRoomDetailsScreen> createState() => _CoachingRoomDetailsScreenState();
}

class _CoachingRoomDetailsScreenState extends State<CoachingRoomDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _handleEndProgram(CoachingRoom room) async {
    final notesController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text('End Coaching Program?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will mark the coaching room as completed and archive all records. The history and evaluations will remain viewable in read-only mode.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Final Completion Notes',
                hintText: 'e.g. Player showed strong progress on 3rd shot drop.',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonLimeCard,
              foregroundColor: AppColors.deepNavy,
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
            ),
            child: const Text('Complete & Archive'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final coaching = context.read<CoachingProvider>();
      await coaching.endCoachingProgram(room.id, notesController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coaching Room completed and archived.'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final auth = context.watch<AuthProvider>();
    final isCoach = auth.isCoach;

    final room = coaching.getRoom(widget.roomId) ?? coaching.allUserRooms.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${room.playerName} x ${room.coachName}',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: StatusBadge.forRoom(room.status)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primaryGreen,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primaryGreen,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Evaluation'),
                Tab(text: 'Program'),
                Tab(text: 'Sessions'),
                Tab(text: 'Feedback'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(room, coaching, isCoach),
          _buildEvaluationTab(room, coaching, isCoach),
          _buildProgramTab(room, coaching, isCoach),
          _buildSessionsTab(room, coaching, isCoach),
          _buildFeedbackTab(room, coaching, isCoach),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // OVERVIEW TAB
  // ---------------------------------------------------------
  Widget _buildOverviewTab(CoachingRoom room, CoachingProvider coaching, bool isCoach) {
    final latestEval = coaching.getLatestEvaluation(room.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Program Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                ProfileAvatar(
                  name: isCoach ? room.playerName : room.coachName,
                  imageUrl: isCoach ? room.playerAvatarUrl : room.coachAvatarUrl,
                  radius: 26,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.programName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateFormatter.formatShort(room.startDate)} – ${DateFormatter.formatShort(room.plannedEndDate)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Frequency: ${room.trainingFrequency}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryGreenDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Training Goals Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.track_changes_rounded, color: AppColors.primaryGreen, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Training Goals',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _goalBullet(room.mainGoal, isPrimary: true),
                  for (final g in room.secondaryGoals) _goalBullet(g),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Latest Evaluation Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Latest Evaluation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (latestEval != null)
                        Text(
                          DateFormatter.formatShort(latestEval.evaluationDate),
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (latestEval != null) ...[
                    Row(
                      children: [
                        Text(
                          '${latestEval.overallScore}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const Text(
                          ' / 10',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        StatusBadge.forPlayerLevel(latestEval.assignedLevel),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'View Full Evaluation',
                      isOutlined: true,
                      height: 44,
                      onPressed: () {
                        _tabController.animateTo(1);
                      },
                    ),
                  ] else ...[
                    const Text(
                      'No evaluations recorded yet.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Actions
          if (room.isActive) ...[
            CustomButton(
              text: 'Record Court Session',
              icon: Icons.sports_tennis_rounded,
              borderRadius: 30,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecordSessionScreen(roomId: room.id, playerId: room.playerId),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'End Coaching Program',
              icon: Icons.check_circle_outline,
              isOutlined: true,
              backgroundColor: AppColors.dangerRed,
              textColor: AppColors.dangerRed,
              borderRadius: 30,
              onPressed: () => _handleEndProgram(room),
            ),
          ],
        ],
      ),
    );
  }

  Widget _goalBullet(String text, {bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPrimary ? Icons.stars_rounded : Icons.check_circle_outline,
            size: 16,
            color: isPrimary ? AppColors.primaryGreen : AppColors.textTertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // EVALUATION TAB
  // ---------------------------------------------------------
  Widget _buildEvaluationTab(CoachingRoom room, CoachingProvider coaching, bool isCoach) {
    final initialEval = coaching.getInitialEvaluation(room.id);
    final latestEval = coaching.getLatestEvaluation(room.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Skill Assessment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Evaluated across 13 core pickleball categories',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              if (room.isActive)
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Assessment'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EvaluationScreen(roomId: room.id, playerId: room.playerId),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),

          if (latestEval != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Score: ${latestEval.overallScore} / 10',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Assigned Level: ${latestEval.assignedLevel.label}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  StatusBadge.forPlayerLevel(latestEval.assignedLevel),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Skill bars list
            for (final entry in latestEval.skillRatings.entries)
              SkillBar(
                skillName: entry.key,
                rating: entry.value,
                initialRating: initialEval?.skillRatings[entry.key],
              ),
          ] else ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No evaluations have been recorded yet.'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // PROGRAM TAB
  // ---------------------------------------------------------
  Widget _buildProgramTab(CoachingRoom room, CoachingProvider coaching, bool isCoach) {
    final program = coaching.getProgramForRoom(room.id);
    final assignments = coaching.getAssignmentsForRoom(room.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  program?.name ?? 'Training Program',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(color: AppColors.primaryGreen, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                icon: const Icon(Icons.menu_book_rounded, size: 15),
                label: const Text('Drill Library', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DrillLibraryScreen()),
                  );
                },
              ),
              if (room.isActive) ...[
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGreen),
                  tooltip: 'Assign Drill',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TrainingProgramScreen(roomId: room.id),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            program?.description ?? 'Personalized development program.',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          const Text(
            'Assigned Drills',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          if (assignments.isEmpty)
            const Text('No drills assigned to this program yet.')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: assignments.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final assign = assignments[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              assign.drillName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Week ${assign.weekNumber}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Target: ${assign.targetRepetitions} reps • ${assign.targetAccuracy.toInt()}% accuracy',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryGreenDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (assign.instructions != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            assign.instructions!,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SESSIONS TAB
  // ---------------------------------------------------------
  Widget _buildSessionsTab(CoachingRoom room, CoachingProvider coaching, bool isCoach) {
    final sessions = coaching.getSessionsForRoom(room.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Court Sessions (${sessions.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              if (room.isActive)
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Record Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecordSessionScreen(roomId: room.id, playerId: room.playerId),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),

          if (sessions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No court sessions recorded yet.'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final session = sessions[index];
                final results = coaching.getDrillResultsForSession(session.id);

                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SessionResultsScreen(
                            session: session,
                            drillResults: results,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${DateFormatter.formatShort(session.sessionDate)} • ${session.startTime ?? ""}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              StatusBadge.forAttendance(session.attendanceStatus),
                            ],
                          ),
                          if (session.drillsCovered.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Drills: ${session.drillsCovered.join(", ")}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                          if (results.isNotEmpty) ...[
                            const Divider(height: 20),
                            for (final res in results)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      res.drillName,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${res.successfulAttempts}/${res.attempts} (${res.accuracy.toInt()}%)',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                          if (session.notes != null && session.notes!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Notes: ${session.notes}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'View Full Results',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primaryGreen),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // FEEDBACK TAB
  // ---------------------------------------------------------
  Widget _buildFeedbackTab(CoachingRoom room, CoachingProvider coaching, bool isCoach) {
    final feedbacks = coaching.getFeedbackForRoom(room.id);

    return Column(
      children: [
        Expanded(
          child: feedbacks.isEmpty
              ? const Center(
                  child: Text('No coach feedback messages yet.'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: feedbacks.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final fb = feedbacks[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fb.coachName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  DateFormatter.formatShort(fb.createdAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fb.message,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (isCoach && room.isActive)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(
                      hintText: 'Write constructive feedback...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  icon: const Icon(Icons.send_rounded, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.neonLimeCard,
                    foregroundColor: AppColors.deepNavy,
                  ),
                  onPressed: () async {
                    if (_feedbackController.text.trim().isNotEmpty) {
                      await coaching.saveFeedback(
                        roomId: room.id,
                        playerId: room.playerId,
                        message: _feedbackController.text.trim(),
                      );
                      _feedbackController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
