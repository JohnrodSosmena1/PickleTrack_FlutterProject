import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _specController;
  String? _profilePicUrl;
  bool _isUploading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _specController = TextEditingController(text: user?.specialization ?? '');
    _profilePicUrl = user?.profilePictureUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _specController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final userId = context.read<AuthProvider>().currentUser?.uid ?? 'temp_user';
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() => _isUploading = true);
      final storage = StorageService();
      final url = await storage.uploadProfilePicture(userId, picked);
      if (mounted) {
        setState(() {
          _profilePicUrl = url;
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final auth = context.read<AuthProvider>();
    await auth.updateProfile(
      fullName: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      specialization: auth.isCoach ? _specController.text.trim() : null,
      profilePictureUrl: _profilePicUrl,
    );

    setState(() => _isSaving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
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
        title: const Text('Edit Profile'),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ProfileAvatar(
                        name: _nameController.text,
                        imageUrl: _profilePicUrl,
                        radius: 50,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.neonLimeCard,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 2.5),
                        ),
                        child: _isUploading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.deepNavy),
                              )
                            : const Icon(Icons.camera_alt, color: AppColors.deepNavy, size: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _pickImage,
                  child: const Text('Change Photo'),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                if (isCoach) ...[
                  CustomTextField(
                    controller: _specController,
                    label: 'Coaching Specialization',
                    hint: 'e.g. Tactical & 3rd Shot Strategy',
                    prefixIcon: Icons.sports_tennis_outlined,
                  ),
                  const SizedBox(height: 16),
                ],

                CustomTextField(
                  controller: _bioController,
                  label: 'About / Bio',
                  hint: 'Short description of your pickleball background...',
                  prefixIcon: Icons.info_outline,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: 'Save Changes',
                  borderRadius: 30,
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
