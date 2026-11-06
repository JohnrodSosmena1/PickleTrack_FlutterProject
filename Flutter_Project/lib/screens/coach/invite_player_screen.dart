import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/coaching_provider.dart';

class InvitePlayerScreen extends StatefulWidget {
  const InvitePlayerScreen({super.key});

  @override
  State<InvitePlayerScreen> createState() => _InvitePlayerScreenState();
}

class _InvitePlayerScreenState extends State<InvitePlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _programNameController = TextEditingController(text: 'Intermediate Development');
  final _durationController = TextEditingController(text: '3 Months');
  final _messageController = TextEditingController(
    text: 'Looking forward to coaching you and working on your pickleball skills!',
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
        content: Text('Invitation sent successfully!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Player'),
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
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter the email of a registered player to propose a personalized coaching program.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Player Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Player Email Address',
                  hint: 'player@example.com (e.g. alex@pickletrack.com)',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Program Name
                CustomTextField(
                  controller: _programNameController,
                  label: 'Proposed Program Name',
                  hint: 'e.g. Intermediate Development',
                  prefixIcon: Icons.sports_tennis_outlined,
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),

                // Duration
                CustomTextField(
                  controller: _durationController,
                  label: 'Proposed Duration',
                  hint: 'e.g. 3 Months or 8 Weeks',
                  prefixIcon: Icons.schedule_outlined,
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),

                // Start Date Picker
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
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _pickStartDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 20, color: AppColors.textSecondary),
                            const SizedBox(width: 12),
                            Text(
                              DateFormatter.formatShort(_startDate),
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Optional Message
                CustomTextField(
                  controller: _messageController,
                  label: 'Welcome Message (Optional)',
                  hint: 'Personal note to the player...',
                  prefixIcon: Icons.chat_bubble_outline,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Send Invitation Button
                CustomButton(
                  text: 'Send Invitation',
                  borderRadius: 30,
                  isLoading: _isLoading,
                  icon: Icons.send_rounded,
                  onPressed: _handleSendInvitation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
