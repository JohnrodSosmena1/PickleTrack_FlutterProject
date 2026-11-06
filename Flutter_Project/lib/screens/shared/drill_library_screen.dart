import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/pickleball_skills.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../models/drill.dart';
import '../../providers/coaching_provider.dart';
import '../../providers/auth_provider.dart';
import 'drill_detail_screen.dart';

class DrillLibraryScreen extends StatefulWidget {
  final bool isPickerMode;

  const DrillLibraryScreen({super.key, this.isPickerMode = false});

  @override
  State<DrillLibraryScreen> createState() => _DrillLibraryScreenState();
}

class _DrillLibraryScreenState extends State<DrillLibraryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateDrillDialog(BuildContext context) {
    final nameController = TextEditingController();
    final objectiveController = TextEditingController();
    final descriptionController = TextEditingController();
    final instruction1Controller = TextEditingController();
    final instruction2Controller = TextEditingController();
    final repsController = TextEditingController(text: '20');
    final equipmentController = TextEditingController(text: 'Paddle, 4+ Pickleballs, Court');
    String category = 'Dinking';
    DrillDifficulty difficulty = DrillDifficulty.intermediate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Custom Drill',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: nameController,
                  label: 'Drill Name',
                  hint: 'e.g. Cross-Court Kitchen Firefight',
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: PickleballSkills.drillCategories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => category = val);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<DrillDifficulty>(
                  initialValue: difficulty,
                  decoration: const InputDecoration(labelText: 'Difficulty'),
                  items: const [
                    DropdownMenuItem(value: DrillDifficulty.beginner, child: Text('Beginner')),
                    DropdownMenuItem(value: DrillDifficulty.intermediate, child: Text('Intermediate')),
                    DropdownMenuItem(value: DrillDifficulty.advanced, child: Text('Advanced')),
                  ],
                  onChanged: (val) {
                    if (val != null) setModalState(() => difficulty = val);
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: objectiveController,
                  label: 'Objective',
                  hint: 'What does this drill improve?',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: descriptionController,
                  label: 'Description',
                  hint: 'Drill mechanics and setup...',
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: instruction1Controller,
                  label: 'Step 1 Instruction',
                  hint: 'First key movement...',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: instruction2Controller,
                  label: 'Step 2 Instruction',
                  hint: 'Second key movement...',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: repsController,
                  label: 'Recommended Repetitions',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Save Drill to Library',
                  borderRadius: 30,
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) return;
                    final instructions = [
                      if (instruction1Controller.text.trim().isNotEmpty)
                        instruction1Controller.text.trim(),
                      if (instruction2Controller.text.trim().isNotEmpty)
                        instruction2Controller.text.trim(),
                    ];
                    await context.read<CoachingProvider>().createDrill(
                          name: nameController.text.trim(),
                          category: category,
                          difficulty: difficulty,
                          objective: objectiveController.text.trim(),
                          description: descriptionController.text.trim(),
                          instructions: instructions,
                          recommendedRepetitions: int.tryParse(repsController.text) ?? 20,
                          equipment: equipmentController.text.trim(),
                        );
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coaching = context.watch<CoachingProvider>();
    final auth = context.watch<AuthProvider>();
    final isCoach = auth.isCoach;

    final drills = coaching.filteredDrills;
    final selectedCat = coaching.selectedCategory;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPickerMode ? 'Select a Drill' : 'Drill Library'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (isCoach && !widget.isPickerMode)
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGreen),
              tooltip: 'Create Custom Drill',
              onPressed: () => _showCreateDrillDialog(context),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search drills by name or skill...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          coaching.setDrillFilters(query: '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (val) {
                coaching.setDrillFilters(query: val);
              },
            ),
          ),

          // Horizontal Category Filter Chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _filterChip('All', selectedCat == 'All', () {
                  coaching.setDrillFilters(category: 'All');
                }),
                for (final cat in PickleballSkills.drillCategories)
                  _filterChip(cat, selectedCat == cat, () {
                    coaching.setDrillFilters(category: cat);
                  }),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Drill Cards List
          Expanded(
            child: drills.isEmpty
                ? const EmptyState(
                    icon: Icons.sports_tennis_rounded,
                    title: 'No Drills Found',
                    description: 'Try adjusting your search query or category filters.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: drills.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final drill = drills[index];
                      return _DrillCard(
                        drill: drill,
                        onTap: () {
                          if (widget.isPickerMode) {
                            Navigator.of(context).pop(drill);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DrillDetailScreen(drill: drill),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.neonLimeCard,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.deepNavy : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        ),
        backgroundColor: AppColors.surface,
        side: BorderSide(
          color: isSelected ? AppColors.primaryGreen : AppColors.border,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class _DrillCard extends StatelessWidget {
  final Drill drill;
  final VoidCallback onTap;

  const _DrillCard({required this.drill, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color diffColor;
    Color diffBg;
    switch (drill.difficulty) {
      case DrillDifficulty.beginner:
        diffColor = const Color(0xFF4ADE80);
        diffBg = const Color(0xFF0F2E1E);
        break;
      case DrillDifficulty.intermediate:
        diffColor = const Color(0xFF60A5FA);
        diffBg = const Color(0xFF0C223E);
        break;
      case DrillDifficulty.advanced:
        diffColor = const Color(0xFFA78BFA);
        diffBg = const Color(0xFF26103E);
        break;
    }

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
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
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
                        drill.name,
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
                        color: diffBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: diffColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        drill.difficulty.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: diffColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Category: ${drill.category}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                drill.objective,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.repeat_rounded, size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        '${drill.recommendedRepetitions} reps',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primaryGreen),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
