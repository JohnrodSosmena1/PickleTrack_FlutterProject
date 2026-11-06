import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/drill.dart';
import '../../providers/coaching_provider.dart';
import '../../providers/auth_provider.dart';
import 'drill_library_screen.dart';
import 'drill_detail_screen.dart';

class TrainingProgramScreen extends StatelessWidget {
  final String roomId;

  const TrainingProgramScreen({super.key, required this.roomId});

  void _showAssignDrillDialog(BuildContext context, Drill drill) {
    final repsController = TextEditingController(text: '${drill.recommendedRepetitions}');
    final accuracyController = TextEditingController(text: '70');
    final weekController = TextEditingController(text: '1');
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('Assign ${drill.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weekController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Week Number', hintText: '1'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Repetitions', hintText: '20'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: accuracyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Accuracy (%)', hintText: '70'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Coach Instructions / Focus'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonLimeCard,
              foregroundColor: AppColors.deepNavy,
              elevation: 0,
            ),
            onPressed: () async {
              final coaching = context.read<CoachingProvider>();
              final program = coaching.getProgramForRoom(roomId);
              if (program != null) {
                await coaching.assignDrill(
                  roomId: roomId,
                  programId: program.id,
                  drill: drill,
                  weekNumber: int.tryParse(weekController.text) ?? 1,
                  targetRepetitions: int.tryParse(repsController.text) ?? 20,
                  targetAccuracy: double.tryParse(accuracyController.text) ?? 70.0,
                  instructions: notesController.text.trim(),
                );
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Assign Drill', style: TextStyle(color: AppColors.deepNavy, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final auth = context.watch<AuthProvider>();
    final isCoach = auth.isCoach;

    final program = coaching.getProgramForRoom(roomId);
    final room = coaching.getRoom(roomId) ?? coaching.allUserRooms.first;
    final assignments = coaching.getAssignmentsForRoom(roomId);

    // Group assignments by week number
    final Map<int, List<dynamic>> weeklyMap = {};
    for (final a in assignments) {
      weeklyMap.putIfAbsent(a.weekNumber, () => []).add(a);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Program'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (isCoach)
            IconButton(
              icon: const Icon(Icons.library_add_outlined, color: AppColors.primaryGreen),
              tooltip: 'Browse Drill Library to Assign',
              onPressed: () async {
                final selectedDrill = await Navigator.of(context).push<Drill>(
                  MaterialPageRoute(builder: (_) => const DrillLibraryScreen(isPickerMode: true)),
                );
                if (selectedDrill != null && context.mounted) {
                  _showAssignDrillDialog(context, selectedDrill);
                }
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
                    program?.name ?? room.programName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Main Goal: ${program?.mainGoal ?? room.mainGoal}',
                    style: const TextStyle(
                      color: AppColors.ballYellow,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Frequency: ${program?.trainingFrequency ?? room.trainingFrequency}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Weekly Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (isCoach)
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Drill'),
                    onPressed: () async {
                      final selectedDrill = await Navigator.of(context).push<Drill>(
                        MaterialPageRoute(
                          builder: (_) => const DrillLibraryScreen(isPickerMode: true),
                        ),
                      );
                      if (selectedDrill != null && context.mounted) {
                        _showAssignDrillDialog(context, selectedDrill);
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),

            if (weeklyMap.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No weekly drills assigned yet.'),
                ),
              )
            else
              for (final entry in weeklyMap.entries) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Week ${entry.key}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${entry.value.length} Drills',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                for (final assign in entry.value) ...[
                  Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreenLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.sports_tennis_rounded,
                          color: AppColors.primaryGreenDark,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        assign.drillName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${assign.targetRepetitions} reps (target: ${assign.targetAccuracy.toInt()}%)',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
                      onTap: () {
                        final drill = coaching.getDrill(assign.drillId);
                        if (drill != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => DrillDetailScreen(drill: drill)),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 16),
              ],
          ],
        ),
      ),
    );
  }
}
