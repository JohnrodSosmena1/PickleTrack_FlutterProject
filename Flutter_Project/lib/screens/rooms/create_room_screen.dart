import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/coaching_provider.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _programNameController = TextEditingController(text: 'Intermediate Development');
  final _durationController = TextEditingController(text: '3 Months');
  final _messageController = TextEditingController(
    text: 'Looking forward to training with you and working on our pickleball skills!',
  );

  DateTime _startDate = DateTime.now().add(const Duration(days: 3));
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _programNameController.dispose();
    _durationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _handleSendInvitation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final coaching = context.read<CoachingProvider>();

    await coaching.sendInvitation(
      playerEmail: _emailController.text.trim(),
      proposedProgramName: _programNameController.text.trim(),
      proposedDuration: _durationController.text.trim(),
      proposedStartDate: _startDate,
      message: _messageController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invitation sent successfully! Coaching Room will activate once accepted.'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room / Invite'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Start a New Coaching Room',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Invite a player or coach to establish a private digital room with structured pickleball skill tracking.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 24),

                // Invitee Search / Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'User Email Address or Username',
                  hint: 'e.g. coach.mark@pickletrack.com',
                  prefixIcon: Icons.search_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 18),

                // Program Name
                CustomTextField(
                  controller: _programNameController,
                  label: 'Proposed Program Name',
                  hint: 'e.g. Intermediate Development',
                  prefixIcon: Icons.sports_tennis_rounded,
                  validator: Validators.required,
                ),
                const SizedBox(height: 18),

                // Duration
                CustomTextField(
                  controller: _durationController,
                  label: 'Proposed Duration',
                  hint: 'e.g. 3 Months, 8 Weeks',
                  prefixIcon: Icons.timelapse_rounded,
                  validator: Validators.required,
                ),
                const SizedBox(height: 18),

                // Proposed Start Date Picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Proposed Start Date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickStartDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormatter.formatDate(_startDate),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Icon(Icons.calendar_month_rounded, color: AppColors.primaryGreen, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Message / Training Goals
                CustomTextField(
                  controller: _messageController,
                  label: 'Training Goals & Message (Optional)',
                  hint: 'Share focus areas, e.g. soft game, resets, and third-shot drops.',
                  prefixIcon: Icons.message_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 28),

                // Send Invitation Button
                CustomButton(
                  text: 'Send Invitation',
                  icon: Icons.send_rounded,
                  borderRadius: 30,
                  isLoading: _isLoading,
                  onPressed: _handleSendInvitation,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
