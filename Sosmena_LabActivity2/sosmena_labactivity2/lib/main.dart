import 'package:flutter/material.dart';

import 'water_tracker_screen.dart';

void main() {
  runApp(const WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sans-serif', // Default sans-serif font
      ),
      home: const WaterTrackerScreen(),
    );
  }
}
