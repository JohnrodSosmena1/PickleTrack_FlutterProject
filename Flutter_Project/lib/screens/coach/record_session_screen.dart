import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../models/drill_result.dart';
import '../../models/drill.dart';
import '../../providers/coaching_provider.dart';
import '../../providers/auth_provider.dart';
import '../shared/drill_library_screen.dart';

class RecordSessionScreen extends StatefulWidget {
  final String roomId;
  final String playerId;

  const RecordSessionScreen({
    super.key,
    required this.roomId,
    required this.playerId,
  });

  @override
  State<RecordSessionScreen> createState() => _RecordSessionScreenState();
}

class _DrillEntry {
  final String drillId;
  final String drillName;
  final TextEditingController attemptsCtrl;
  final TextEditingController successCtrl;
  final TextEditingController notesCtrl;

  _DrillEntry({
    required this.drillId,
    required this.drillName,
    int initialAttempts = 20,
    int initialSuccess = 14,
  })  : attemptsCtrl = TextEditingController(text: '$initialAttempts'),
        successCtrl = TextEditingController(text: '$initialSuccess'),
        notesCtrl = TextEditingController();

  int get attempts => int.tryParse(attemptsCtrl.text) ?? 0;
  int get successful => int.tryParse(successCtrl.text) ?? 0;
  double get accuracy => Validators.calculateAccuracy(successful, attempts);

  void dispose() {
    attemptsCtrl.dispose();
    successCtrl.dispose();
    notesCtrl.dispose();
  }
}

class _RecordSessionScreenState extends State<RecordSessionScreen> {
  DateTime _sessionDate = DateTime.now();
  AttendanceStatus _attendance = AttendanceStatus.present;
  final _notesController = TextEditingController(text: 'Good control today. Still needs work on transition shots.');
  final _feedbackController = TextEditingController(text: 'Great focus on kitchen patience! Keep working on third shot drop height.');
  final List<_DrillEntry> _drillEntries = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Default 3 drills matching the mockup
    _drillEntries.add(_DrillEntry(drillId: 'drill_3', drillName: 'Third-Shot Drop', initialAttempts: 20, initialSuccess: 14));
    _drillEntries.add(_DrillEntry(drillId: 'drill_1', drillName: 'Dinking', initialAttempts: 20, initialSuccess: 16));
    _drillEntries.add(_DrillEntry(drillId: 'drill_5', drillName: 'Volley', initialAttempts: 20, initialSuccess: 13));
  }

  @override
  void dispose() {
    _notesController.dispose();
    _feedbackController.dispose();
    for (final e in _drillEntries) {
      e.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _sessionDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _sessionDate = picked);
    }
  }

  void _addDrillEntry() async {
    final selectedDrill = await Navigator.of(context).push<Drill>(
      MaterialPageRoute(builder: (_) => const DrillLibraryScreen(isPickerMode: true)),
    );
    if (selectedDrill != null && mounted) {
      setState(() {
        _drillEntries.add(
          _DrillEntry(
            drillId: selectedDrill.id,
            drillName: selectedDrill.name,
            initialAttempts: selectedDrill.recommendedRepetitions,
            initialSuccess: (selectedDrill.recommendedRepetitions * 0.7).round(),
          ),
        );
      });
    }
  }

  Future<void> _handleSaveSession() async {
    // Validate inputs
    for (final entry in _drillEntries) {
      final err = Validators.drillAttempts(entry.attempts, entry.successful);
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${entry.drillName}: $err'), backgroundColor: AppColors.dangerRed),
        );
        return;
      }
    }

    setState(() => _isSaving = true);
    final coaching = context.read<CoachingProvider>();

    final results = _drillEntries.map((e) {
      return DrillResult(
        id: '',
        roomId: widget.roomId,
        sessionId: '',
        drillId: e.drillId,
        drillName: e.drillName,
        attempts: e.attempts,
        successfulAttempts: e.successful,
        accuracy: e.accuracy,
        notes: e.notesCtrl.text.trim().isNotEmpty ? e.notesCtrl.text.trim() : null,
        recordedBy: context.read<AuthProvider>().currentUser?.fullName ?? 'Coach Mark',
      );
    }).toList();

    await coaching.recordSession(
      roomId: widget.roomId,
      playerId: widget.playerId,
      sessionDate: _sessionDate,
      attendanceStatus: _attendance,
      drillsCovered: _drillEntries.map((e) => e.drillName).toList(),
      results: results,
      notes: _notesController.text.trim(),
      feedback: _feedbackController.text.trim(),
    );

    setState(() => _isSaving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session and drill results recorded successfully!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Session'),
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
              // Date Row
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, color: AppColors.primaryGreen, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        DateFormatter.formatDateTime(_sessionDate),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Attendance Selector
              const Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _attendancePill(AttendanceStatus.present, 'Present'),
                  const SizedBox(width: 10),
                  _attendancePill(AttendanceStatus.absent, 'Absent'),
                  const SizedBox(width: 10),
                  _attendancePill(AttendanceStatus.late, 'Late'),
                ],
              ),
              const SizedBox(height: 24),

              // Drill Results Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Drill Results',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Drill'),
                    onPressed: _addDrillEntry,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Drill input rows
              for (int i = 0; i < _drillEntries.length; i++) ...[
                _buildDrillResultCard(_drillEntries[i], i),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 16),

              // Session Notes
              const Text(
                'Session Notes',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Courtside observations, adjustments, movement notes...',
                ),
              ),
              const SizedBox(height: 16),

              // Feedback to Player
              const Text(
                'Feedback for Player',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _feedbackController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Constructive feedback and encouragement...',
                ),
              ),
              const SizedBox(height: 28),

              // Save Session Button
              CustomButton(
                text: 'Save Session',
                borderRadius: 30,
                isLoading: _isSaving,
                onPressed: _handleSaveSession,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attendancePill(AttendanceStatus status, String label) {
    final isSelected = _attendance == status;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _attendance = status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.neonLimeCard : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: isSelected ? AppColors.deepNavy : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrillResultCard(_DrillEntry entry, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.drillName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
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
                    '${entry.accuracy.toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                if (_drillEntries.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: AppColors.textTertiary),
                    onPressed: () {
                      setState(() {
                        _drillEntries.removeAt(index);
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: entry.successCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Successful',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '/',
                    style: TextStyle(fontSize: 20, color: AppColors.textSecondary),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: entry.attemptsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Attempts',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
