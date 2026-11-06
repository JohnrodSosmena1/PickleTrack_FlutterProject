import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/drill.dart';
import '../../providers/coaching_provider.dart';
import '../shared/drill_library_screen.dart';
import '../shared/drill_detail_screen.dart';
import '../rooms/rooms_screen.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final activeRoom = coaching.activeRoom;

    if (activeRoom == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Training Program')),
        body: EmptyState(
          icon: Icons.fitness_center_outlined,
          title: 'No Active Training Program',
          description: 'Establish or join a Coaching Room to view your customized weekly drills and training goals.',
          buttonText: 'View Coaching Rooms',
          onButtonPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RoomsScreen()),
            );
          },
        ),
      );
    }

    final program = coaching.getProgramForRoom(activeRoom.id);
    final assignments = coaching.getAssignmentsForRoom(activeRoom.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Program'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryGreen),
            tooltip: 'Assign Drill',
            onPressed: () async {
              final selected = await Navigator.of(context).push<Drill>(
                MaterialPageRoute(builder: (_) => const DrillLibraryScreen(isPickerMode: true)),
              );
              if (selected != null && program != null) {
                await coaching.assignDrill(
                  roomId: activeRoom.id,
                  programId: program.id,
                  drill: selected,
                );
              }
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.menu_book_outlined, size: 18),
            label: const Text('Drill Library'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DrillLibraryScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vibrant Neon Lime Program Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.neonLimeCard,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonLimeCard.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.deepNavy,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'ACTIVE PROGRAM',
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.deepNavy.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Freq: ${program?.trainingFrequency ?? activeRoom.trainingFrequency}',
                          style: const TextStyle(
                            color: AppColors.deepNavy,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    program?.name ?? activeRoom.programName,
                    style: const TextStyle(
                      color: AppColors.deepNavy,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.stars_rounded, size: 16, color: AppColors.deepNavy),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Goal: ${program?.mainGoal ?? activeRoom.mainGoal}',
                          style: const TextStyle(
                            color: AppColors.deepNavy,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Assigned Weekly Drills',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    '${assignments.length} Drills',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            if (assignments.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Text(
                    'No drills assigned yet. Tap + or Drill Library to add drills.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: assignments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final assign = assignments[index];
                  final isCompleted = assign.status == 'completed';

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        onTap: () {
                          final drill = coaching.getDrill(assign.drillId);
                          if (drill != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DrillDetailScreen(drill: drill),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(18),
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
                                      assign.drillName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? AppColors.activeGreenBg
                                          : AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isCompleted
                                            ? AppColors.primaryGreen.withValues(alpha: 0.3)
                                            : AppColors.borderLight,
                                      ),
                                    ),
                                    child: Text(
                                      isCompleted ? '✓ Completed' : 'Week ${assign.weekNumber}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isCompleted
                                            ? AppColors.primaryGreen
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.bolt_rounded, size: 16, color: AppColors.primaryGreen),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Target: ${assign.targetRepetitions} reps • ${assign.targetAccuracy.toInt()}% accuracy',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              if (assign.instructions != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  assign.instructions!,
                                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.3),
                                ),
                              ],
                              if (assign.coachNotes != null) ...[
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.borderLight),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.comment_outlined, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Coach Note: ${assign.coachNotes!}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
