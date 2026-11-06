import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final VoidCallback? onEdit;
  final bool showBorder;
  final Color? borderColor;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 28,
    this.onEdit,
    this.showBorder = true,
    this.borderColor,
  });

  String get _initials {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarChild;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarChild = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: radius * 0.8,
              height: radius * 0.8,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    } else {
      avatarChild = _buildFallback();
    }

    final avatar = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: borderColor ?? AppColors.primaryGreen,
                width: 2.5,
              )
            : null,
      ),
      child: ClipOval(child: avatarChild),
    );

    if (onEdit == null) return avatar;

    return Stack(
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallback() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      color: AppColors.primaryGreenLight,
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.w800,
            fontSize: radius * 0.75,
          ),
        ),
      ),
    );
  }
}
