import 'package:flutter/material.dart';

/// PickleTrack Design System Colors
/// Professional sports application palette: pickleball court green, deep navy,
/// ball accent yellow, clean whites, and slate neutrals.
class AppColors {
  // Primary brand colors (aligned with user mockup: Dark Navy & Vibrant Neon Lime)
  static const Color primaryGreen = Color(0xFF84CC16); // Vibrant Neon Lime
  static const Color primaryGreenDark = Color(0xFF65A30D);
  static const Color primaryGreenLight = Color(0xFF132A1C); // Subtle dark-green tint for pills
  static const Color primaryGreenSubtle = Color(0xFF0E2217);
  
  // Neon Lime specific
  static const Color neonLime = Color(0xFF84CC16);
  static const Color neonLimeLight = Color(0xFFA3E635);
  static const Color neonLimeDark = Color(0xFF65A30D);
  static const Color neonLimeCard = Color(0xFF8DE805); // Hero banner lime

  // Secondary / Contrast brand colors
  static const Color deepNavy = Color(0xFF070E1A); // Dark navy canvas
  static const Color primaryNavy = deepNavy;
  static const Color deepNavySurface = Color(0xFF0E1A2B); // Dark navy card
  static const Color navyCard = Color(0xFF0E1A2B);

  // Pickleball ball accent
  static const Color ballYellow = Color(0xFFEAB308);
  static const Color ballYellowAccent = Color(0xFFFACC15);
  static const Color ballYellowLight = Color(0xFFFEF9C3);
  static const Color accentOrange = Color(0xFFF97316);

  // Background and surfaces (Dark Navy sports tech matching user mockup)
  static const Color background = Color(0xFF070E1A); // Dark navy background
  static const Color surface = Color(0xFF0E1A2B); // Dark navy card surface
  static const Color surfaceVariant = Color(0xFF132238); // Elevated surface
  static const Color border = Color(0xFF1B2A40); // Clean subtle card border
  static const Color borderLight = Color(0xFF24364F);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF); // High contrast white
  static const Color textSecondary = Color(0xFF94A3B8); // Muted slate gray
  static const Color textTertiary = Color(0xFF64748B); // Slate-500
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFF070E1A); // Dark navy text on neon green buttons
  static const Color textOnNeon = Color(0xFF070E1A);

  // Status and Skill badge colors
  static const Color activeGreen = Color(0xFF84CC16);
  static const Color activeGreenBg = Color(0xFF10261A);
  
  static const Color pendingAmber = Color(0xFFF59E0B);
  static const Color pendingAmberBg = Color(0xFF281C08);
  
  static const Color completedBlue = Color(0xFF3B82F6);
  static const Color completedBlueBg = Color(0xFF0C223E);
  
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color dangerRedBg = Color(0xFF2D1214);

  static const Color archivedGray = Color(0xFF64748B);
  static const Color archivedGrayBg = Color(0xFF15202E);

  // Player skill level badge colors
  static const Color levelBeginner = Color(0xFF16A34A);
  static const Color levelDeveloping = Color(0xFFD97706);
  static const Color levelIntermediate = Color(0xFF2563EB);
  static const Color levelAdvanced = Color(0xFF7C3AED);

  // Gradients
  static const LinearGradient welcomeCourtGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF070E1A),
      Color(0xFF0B132B),
      Color(0xFF0F1B2B),
    ],
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0B132B),
      Color(0xFF14243B),
    ],
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF84CC16),
      Color(0xFFA3E635),
    ],
  );
}
