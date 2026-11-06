import 'package:flutter/material.dart';

import 'water_tracker_model.dart';
import 'goal_card.dart';
import 'action_button.dart';

class WaterTrackerScreen extends StatelessWidget {
  const WaterTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const data = WaterTrackerModel();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 320,

            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: const Color(0xFF1565C0),
                  child: const Text(
                    'Water Tracker',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Main Content Area
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.water_drop,
                        size: 60,
                        color: Color(0xFF1976D2),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 24),

                      GoalCard(
                        goalNumber: data.dailyGoal,
                        unitText: data.goalUnit,
                      ),
                      const SizedBox(height: 24),

                      ...data.tips
                          .map(
                            (tip) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: ActionButton(text: tip),
                            ),
                          )
                          .toList(),

                      const SizedBox(height: 12),

                      Text(
                        data.footerText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF29B6F6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
