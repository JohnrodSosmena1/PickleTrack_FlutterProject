import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/coach_profile.dart';
import '../../../models/coaching_session_listing.dart';
import '../../../providers/coaching_provider.dart';

class RequestCoachingSheet extends StatefulWidget {
  final CoachProfile? coach;
  final CoachingSessionListing? session;

  const RequestCoachingSheet({
    super.key,
    this.coach,
    this.session,
  }) : assert(coach != null || session != null, 'Must provide coach or session');

  @override
  State<RequestCoachingSheet> createState() => _RequestCoachingSheetState();
}

class _RequestCoachingSheetState extends State<RequestCoachingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _scheduleController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedSkillLevel = 'Intermediate (3.0)';
  bool _isSubmitting = false;

  final List<String> _skillLevels = [
    'Beginner (2.0 - 2.5)',
    'Developing (2.5 - 3.0)',
    'Intermediate (3.0 - 3.5)',
    'Advanced (4.0+)',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.session != null) {
      _selectedSkillLevel = '${widget.session!.skillLevel} (Session)';
      if (!_skillLevels.contains(_selectedSkillLevel)) {
        _skillLevels.insert(0, _selectedSkillLevel);
      }
      _scheduleController.text =
          '${widget.session!.dateTime.day}/${widget.session!.dateTime.month} at ${widget.session!.venue}';
    } else if (widget.coach != null) {
      _scheduleController.text = 'Weekdays Evening or Weekends';
    }
  }

  @override
  void dispose() {
    _scheduleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final coaching = context.read<CoachingProvider>();

      if (widget.coach != null) {
        await coaching.sendCoachingRequest(
          coach: widget.coach!,
          preferredSchedule: _scheduleController.text.trim(),
          skillLevel: _selectedSkillLevel,
          message: _messageController.text.trim().isNotEmpty
              ? _messageController.text.trim()
              : null,
        );
      } else if (widget.session != null) {
        await coaching.sendSessionBookingRequest(
          session: widget.session!,
          preferredSchedule: _scheduleController.text.trim(),
          skillLevel: _selectedSkillLevel,
          message: _messageController.text.trim().isNotEmpty
              ? _messageController.text.trim()
              : null,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF070E1A)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.coach != null
                        ? 'Coaching request sent to ${widget.coach!.displayName}!'
                        : 'Session booking requested! Coach will confirm your slot.',
                    style: const TextStyle(
                      color: Color(0xFF070E1A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Failed to submit request: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCoaching = widget.coach != null;
    final title = isCoaching
        ? 'Request Coaching with ${widget.coach!.displayName}'
        : 'Request Slot: ${widget.session!.title}';

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0C1726),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Color(0xFF1B2C42), width: 1.5),
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3D58),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF14243A),
                      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                    ),
                    child: Icon(
                      isCoaching ? Icons.sports_tennis_rounded : Icons.event_available_rounded,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isCoaching
                              ? '₱${widget.coach!.hourlyRate.toInt()}/hr · Status will be Pending until accepted'
                              : '₱${widget.session!.price.toInt()} · ${widget.session!.slotsLeft} slots remaining',
                          style: const TextStyle(
                            color: Color(0xFF9AA8BF),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Skill Level Selector
              const Text(
                'Your Current Skill Level',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF101E33),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E3250), width: 1.2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSkillLevel,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF0E1A2E),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryGreen),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    items: _skillLevels.map((lvl) {
                      return DropdownMenuItem<String>(
                        value: lvl,
                        child: Text(lvl),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSkillLevel = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Preferred Schedule Field
              const Text(
                'Preferred Schedule & Availability',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _scheduleController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g. Saturdays 8:00 AM - 10:00 AM',
                  hintStyle: const TextStyle(color: Color(0xFF5A6F8C), fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFF101E33),
                  prefixIcon: const Icon(Icons.schedule_rounded, color: Color(0xFF9AA8BF), size: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1E3250), width: 1.2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1E3250), width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your preferred schedule';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Optional Message / Notes
              const Text(
                'Message to Coach (Optional)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Share your key goals (e.g. "Want to improve 3rd shot drops and transition resets")',
                  hintStyle: const TextStyle(color: Color(0xFF5A6F8C), fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFF101E33),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1E3250), width: 1.2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1E3250), width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonLimeCard,
                    foregroundColor: const Color(0xFF070E1A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF070E1A)),
                        )
                      : Text(
                          isCoaching ? 'Submit Coaching Request' : 'Submit Session Request',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
