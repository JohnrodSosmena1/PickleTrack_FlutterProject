import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/logo_bytes.dart';

/// Official PickleTrack Logo widget that renders Logo 1.png (Pickle Track)
class PickleballLogo extends StatelessWidget {
  final double? size;
  final double? radius;
  final double? height;
  final double? width;
  final bool showText;
  final bool isDarkBackground;
  final bool compact;
  final bool useTransparent;
  final BoxFit fit;

  const PickleballLogo({
    super.key,
    this.size,
    this.radius,
    this.height,
    this.width,
    this.showText = true,
    this.isDarkBackground = false,
    this.compact = false,
    this.useTransparent = true,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? (size ?? (radius != null ? radius! * 2 : 110));
    final effectiveWidth = width;

    // Direct in-memory byte buffer of Logo 1.png guarantees instant rendering
    // on Flutter Web and Mobile without requiring dev-server asset bundle restarts.
    final imageBytes = (isDarkBackground || !useTransparent) ? kLogo1Bytes : kLogo1TransparentBytes;

    if (compact) {
      return Semantics(
        label: 'PickleTrack Logo',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(
              imageBytes,
              height: effectiveHeight * 0.7,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              'PickleTrack',
              style: TextStyle(
                fontSize: effectiveHeight * 0.4,
                fontWeight: FontWeight.w800,
                color: isDarkBackground ? Colors.white : AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      );
    }

    return Semantics(
      label: 'PickleTrack Official Logo',
      child: Image.memory(
        imageBytes,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
      ),
    );
  }
}
