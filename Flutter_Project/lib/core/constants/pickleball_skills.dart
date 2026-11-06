/// Comprehensive definitions for the 13 Pickleball Skill Evaluation Categories
/// and Drill Library Categories.
library;

class PickleballSkills {
  /// The 13 official skill categories for player evaluations
  static const List<String> categories = [
    'Serve',
    'Return of Serve',
    'Dinking',
    'Volley',
    'Groundstrokes',
    'Third-Shot Drop',
    'Third-Shot Drive',
    'Reset Shots',
    'Transition Game',
    'Court Positioning',
    'Shot Selection',
    'Consistency',
    'Doubles Communication',
  ];

  /// Category descriptions for coaches and players
  static const Map<String, String> categoryDescriptions = {
    'Serve': 'Placement, depth, speed control, consistency, and spin on the serve.',
    'Return of Serve': 'Deep returns targeting backcourt to keep opponents at baseline.',
    'Dinking': 'Cross-court and straight dink control, patience, and unattackable height.',
    'Volley': 'Punch volleys, roll volleys, block volleys, and hand speed at the NVZ.',
    'Groundstrokes': 'Topspin/slice forehands and backhands with depth and court penetration.',
    'Third-Shot Drop': 'Soft arcing ball from baseline into opponent kitchen with precision.',
    'Third-Shot Drive': 'Paced drive designed to freeze opponents or force a high pop-up.',
    'Reset Shots': 'Neutralizing hard attacks from midcourt or NVZ into opponent kitchen.',
    'Transition Game': 'Moving smoothly from baseline to kitchen through the transition zone.',
    'Court Positioning': 'Maintaining court geometry, spacing with partner, and shifting.',
    'Shot Selection': 'Choosing high-percentage shots based on opponent position and balance.',
    'Consistency': 'Limiting unforced errors during sustained rallies.',
    'Doubles Communication': 'Call-outs (mine/yours/switch), stacking, and tandem synergy.',
  };

  /// Drill categories
  static const List<String> drillCategories = [
    'Serving',
    'Return of Serve',
    'Dinking',
    'Volley',
    'Groundstroke',
    'Third-Shot Drop',
    'Third-Shot Drive',
    'Reset',
    'Transition',
    'Shot Placement',
    'Doubles Strategy',
  ];
}
