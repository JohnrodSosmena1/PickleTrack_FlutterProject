import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/pickleball_logo.dart';
import '../../core/widgets/custom_button.dart';
import 'role_selection_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Court Graphic & Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.welcomeCourtGradient,
            ),
          ),

          // Court Net Lines Design
          CustomPaint(
            size: Size.infinite,
            painter: _CourtLinesPainter(),
          ),

          // Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),

                  // Center Logo & Tagline
                  const Column(
                    children: [
                      PickleballLogo(
                        size: 96,
                        showText: true,
                        isDarkBackground: true,
                      ),
                      SizedBox(height: 36),
                      Text(
                        'Better Players\nBuild Better Games',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'The complete coaching and player\ndevelopment system for pickleball.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Buttons
                  Column(
                    children: [
                      CustomButton(
                        text: 'Get Started',
                        borderRadius: 30,
                        backgroundColor: AppColors.primaryGreen,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RoleSelectionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                color: AppColors.ballYellow,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourtLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerY = size.height * 0.45;

    // Baseline
    canvas.drawLine(Offset(20, centerY - 120), Offset(size.width - 20, centerY - 120), paint);
    // NVZ Kitchen Line
    canvas.drawLine(Offset(20, centerY), Offset(size.width - 20, centerY), paint);
    // Centerline
    canvas.drawLine(Offset(size.width / 2, centerY - 120), Offset(size.width / 2, centerY), paint);
    // Net
    final netPaint = Paint()
      ..color = AppColors.primaryGreen.withValues(alpha: 0.12)
      ..strokeWidth = 4;
    canvas.drawLine(Offset(0, centerY + 40), Offset(size.width, centerY + 40), netPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
