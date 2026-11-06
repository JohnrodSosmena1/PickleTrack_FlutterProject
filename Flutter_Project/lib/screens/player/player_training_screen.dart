import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../providers/coaching_provider.dart';
import '../shared/drill_library_screen.dart';
import '../shared/drill_detail_screen.dart';
import 'player_coaching_rooms_screen.dart';

class PlayerTrainingScreen extends StatelessWidget {
  const PlayerTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final activeRoom = coaching.activeRoom;

    if (activeRoom == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Training')),
        body: EmptyState(
          icon: Icons.fitness_center_outlined,
          title: 'No Active Training Program',
          description: 'Join a Coaching Room to view your customized weekly drills and training goals.',
          buttonText: 'View Coaching Rooms',
          onButtonPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlayerCoachingRoomsScreen()),
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
            // Program Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.heroCardGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program?.name ?? activeRoom.programName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Main Goal: ${program?.mainGoal ?? activeRoom.mainGoal}',
                    style: const TextStyle(
                      color: AppColors.ballYellow,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Frequency: ${program?.trainingFrequency ?? activeRoom.trainingFrequency}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Assigned Weekly Drills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            if (assignments.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Your coach has not assigned specific drills yet.'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: assignments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final a = assignments[index];
                  return Card(
                    child: InkWell(
                      onTap: () {
                        final drill = coaching.getDrill(a.drillId);
                        if (drill != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DrillDetailScreen(drill: drill),
                            ),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    a.drillName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreenLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Week ${a.weekNumber}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryGreenDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Target: ${a.targetRepetitions} reps (target: ${a.targetAccuracy.toInt()}%)',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryGreenDark,
                              ),
                            ),
                            if (a.instructions != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                a.instructions!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.35,
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Text(
                                  'Tap to view instructions',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.textTertiary),
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
      ),
    );
  }
}
