import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/pickleball_skills.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../providers/coaching_provider.dart';
import '../../providers/auth_provider.dart';

class EvaluationScreen extends StatefulWidget {
  final String roomId;
  final String playerId;

  const EvaluationScreen({
    super.key,
    required this.roomId,
    required this.playerId,
  });

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final Map<String, int> _ratings = {};
  final Map<String, TextEditingController> _observationControllers = {};
  final _generalNotesController = TextEditingController();
  PlayerLevel _assignedLevel = PlayerLevel.intermediate;
  String _evaluationType = 'progress';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    for (final cat in PickleballSkills.categories) {
      _ratings[cat] = 6;
      _observationControllers[cat] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _observationControllers.values) {
      c.dispose();
    }
    _generalNotesController.dispose();
    super.dispose();
  }

  double get _overallScore {
    if (_ratings.isEmpty) return 0.0;
    int sum = 0;
    for (final val in _ratings.values) {
      sum += val;
    }
    return double.parse((sum / _ratings.length).toStringAsFixed(1));
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    final coaching = context.read<CoachingProvider>();
    final observations = <String, String>{};
    for (final entry in _observationControllers.entries) {
      if (entry.value.text.trim().isNotEmpty) {
        observations[entry.key] = entry.value.text.trim();
      }
    }

    await coaching.saveEvaluation(
      roomId: widget.roomId,
      playerId: widget.playerId,
      skillRatings: _ratings,
      observations: observations,
      generalNotes: _generalNotesController.text.trim(),
      assignedLevel: _assignedLevel,
      evaluationType: _evaluationType,
    );

    setState(() => _isSaving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Player evaluation saved successfully!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isCoach = auth.isCoach;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Evaluation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Score Summary Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.heroCardGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overall Score',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$_overallScore',
                              style: const TextStyle(
                                color: AppColors.neonLimeCard,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text(
                              ' / 10',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    StatusBadge.forPlayerLevel(_assignedLevel),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Level & Assessment Type Config (For Coach)
              if (isCoach) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Assessment Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<PlayerLevel>(
                          initialValue: _assignedLevel,
                          decoration: const InputDecoration(labelText: 'Assign Player Level'),
                          items: const [
                            DropdownMenuItem(
                              value: PlayerLevel.beginner,
                              child: Text('Beginner'),
                            ),
                            DropdownMenuItem(
                              value: PlayerLevel.developing,
                              child: Text('Developing'),
                            ),
                            DropdownMenuItem(
                              value: PlayerLevel.intermediate,
                              child: Text('Intermediate'),
                            ),
                            DropdownMenuItem(
                              value: PlayerLevel.advanced,
                              child: Text('Advanced'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _assignedLevel = val);
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _evaluationType,
                          decoration: const InputDecoration(labelText: 'Evaluation Type'),
                          items: const [
                            DropdownMenuItem(value: 'initial', child: Text('Initial Assessment')),
                            DropdownMenuItem(value: 'progress', child: Text('Progress Assessment')),
                            DropdownMenuItem(value: 'final', child: Text('Final Evaluation')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _evaluationType = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const Text(
                'Skill Categories (1 - 10)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // 13 Pickleball Skill Categories
              for (final cat in PickleballSkills.categories) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    PickleballSkills.categoryDescriptions[cat] ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreenLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                '${_ratings[cat]}/10',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryGreen,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isCoach) ...[
                          Slider(
                            value: (_ratings[cat] ?? 6).toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            activeColor: AppColors.neonLimeCard,
                            inactiveColor: AppColors.surfaceVariant,
                            onChanged: (val) {
                              setState(() {
                                _ratings[cat] = val.round();
                              });
                            },
                          ),
                          TextField(
                            controller: _observationControllers[cat],
                            decoration: const InputDecoration(
                              hintText: 'Observation note (e.g. good paddle angle)...',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              const SizedBox(height: 12),
              if (isCoach) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'General Summary & Recommendations',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _generalNotesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Summary of player progression and next focus areas...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Save Evaluation',
                  borderRadius: 30,
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
