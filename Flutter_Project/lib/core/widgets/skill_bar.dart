import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SkillBar extends StatelessWidget {
  final String skillName;
  final int rating; // 1 to 10
  final int maxRating;
  final int? initialRating; // for progress comparison (+/- change)
  final int? previousRating;
  final Color? barColor;
  final bool showLabel;
  final double height;

  const SkillBar({
    super.key,
    required this.skillName,
    int? rating,
    int? currentRating,
    this.maxRating = 10,
    this.initialRating,
    this.previousRating,
    this.barColor,
    this.showLabel = true,
    this.height = 8,
  }) : rating = currentRating ?? rating ?? 0;

  @override
  Widget build(BuildContext context) {
    final progress = (rating / maxRating).clamp(0.0, 1.0);
    final effectiveInitial = initialRating ?? previousRating;
    final change = effectiveInitial != null ? rating - effectiveInitial : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    skillName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$rating/$maxRating',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (change != null && change != 0) ...[
                      const SizedBox(width: 6),
                      Text(
                        change > 0 ? '(+$change)' : '($change)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: change > 0 ? AppColors.activeGreen : AppColors.dangerRed,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(height),
            child: Container(
              height: height,
              width: double.infinity,
              color: AppColors.border,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: barColor != null ? null : AppColors.primaryButtonGradient,
                    color: barColor ?? AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
