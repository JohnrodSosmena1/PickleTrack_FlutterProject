import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final int goalNumber;
  final String unitText;

  const GoalCard({Key? key, required this.goalNumber, required this.unitText})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Daily Water Goal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            goalNumber.toString(),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0D47A1),
              height: 1.0, // Tighten the line height
            ),
          ),
          const SizedBox(height: 8),
          Text(
            unitText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2), // Slightly lighter blue
            ),
          ),
        ],
      ),
    );
  }
}
