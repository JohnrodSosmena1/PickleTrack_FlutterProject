class WaterTrackerModel {
  final String title;
  final String subtitle;
  final int dailyGoal;
  final String goalUnit;
  final List<String> tips;
  final String footerText;

  const WaterTrackerModel({
    this.title = 'Stay Hydrated!',
    this.subtitle = 'Build a healthy daily habit',
    this.dailyGoal = 8,
    this.goalUnit = 'glasses per day',
    this.tips = const ['Drink water regularly', 'Bring your water bottle'],
    this.footerText = 'Every glass counts!',
  });
}
