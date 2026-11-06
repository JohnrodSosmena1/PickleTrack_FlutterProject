/// Application-wide constants, enums, and string constants.
library;

class AppConstants {
  static const String appName = 'PickleTrack';
  static const String appTagline = 'Train. Track. Improve.';
  static const String appMotto = 'Better Players Build Better Games';

  // Firestore Collection Names
  static const String colUsers = 'users';
  static const String colPlayerProfiles = 'playerProfiles';
  static const String colCoachProfiles = 'coachProfiles';
  static const String colInvitations = 'invitations';
  static const String colCoachingRooms = 'coachingRooms';
  static const String colEvaluations = 'evaluations';
  static const String colTrainingPrograms = 'trainingPrograms';
  static const String colDrills = 'drills';
  static const String colDrillAssignments = 'drillAssignments';
  static const String colTrainingSessions = 'trainingSessions';
  static const String colDrillResults = 'drillResults';
  static const String colFeedback = 'feedback';
  static const String colActivities = 'activities';
}

/// User roles
enum UserRole {
  player,
  coach;

  String get displayName {
    switch (this) {
      case UserRole.player:
        return 'Player';
      case UserRole.coach:
        return 'Coach';
    }
  }

  static UserRole fromString(String? value) {
    if (value?.toLowerCase() == 'coach') return UserRole.coach;
    return UserRole.player;
  }
}

/// Player skill levels
enum PlayerLevel {
  notEvaluated('Not yet evaluated'),
  beginner('Beginner'),
  developing('Developing'),
  intermediate('Intermediate'),
  advanced('Advanced');

  final String label;
  const PlayerLevel(this.label);

  static PlayerLevel fromString(String? value) {
    if (value == null || value.isEmpty) return PlayerLevel.notEvaluated;
    switch (value.toLowerCase()) {
      case 'beginner':
        return PlayerLevel.beginner;
      case 'developing':
        return PlayerLevel.developing;
      case 'intermediate':
        return PlayerLevel.intermediate;
      case 'advanced':
        return PlayerLevel.advanced;
      default:
        return PlayerLevel.notEvaluated;
    }
  }
}

/// Invitation status
enum InvitationStatus {
  pending('Pending'),
  accepted('Accepted'),
  declined('Declined'),
  cancelled('Cancelled');

  final String label;
  const InvitationStatus(this.label);

  static InvitationStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'accepted':
        return InvitationStatus.accepted;
      case 'declined':
        return InvitationStatus.declined;
      case 'cancelled':
        return InvitationStatus.cancelled;
      case 'pending':
      default:
        return InvitationStatus.pending;
    }
  }
}

/// Coaching room status
enum CoachingRoomStatus {
  active('Active'),
  completed('Completed'),
  archived('Archived');

  final String label;
  const CoachingRoomStatus(this.label);

  static CoachingRoomStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'completed':
        return CoachingRoomStatus.completed;
      case 'archived':
        return CoachingRoomStatus.archived;
      case 'active':
      default:
        return CoachingRoomStatus.active;
    }
  }
}

/// Attendance status for court sessions
enum AttendanceStatus {
  present('Present'),
  absent('Absent'),
  late('Late'),
  excused('Excused');

  final String label;
  const AttendanceStatus(this.label);

  static AttendanceStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'absent':
        return AttendanceStatus.absent;
      case 'late':
        return AttendanceStatus.late;
      case 'excused':
        return AttendanceStatus.excused;
      case 'present':
      default:
        return AttendanceStatus.present;
    }
  }
}

/// Session schedule status
enum SessionStatus {
  scheduled('Scheduled'),
  completed('Completed'),
  cancelled('Cancelled');

  final String label;
  const SessionStatus(this.label);

  static SessionStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'completed':
        return SessionStatus.completed;
      case 'cancelled':
        return SessionStatus.cancelled;
      case 'scheduled':
      default:
        return SessionStatus.scheduled;
    }
  }
}

/// Drill difficulty level
enum DrillDifficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  final String label;
  const DrillDifficulty(this.label);

  static DrillDifficulty fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'advanced':
        return DrillDifficulty.advanced;
      case 'intermediate':
        return DrillDifficulty.intermediate;
      case 'beginner':
      default:
        return DrillDifficulty.beginner;
    }
  }
}

/// Activity feed event types
enum ActivityType {
  invitationAccepted('Invitation Accepted'),
  programAssigned('Training Program Assigned'),
  sessionRecorded('Training Session Recorded'),
  drillResultsAdded('Drill Results Added'),
  evaluationUpdated('Evaluation Updated'),
  feedbackAdded('Coach Feedback Added'),
  playerLevelUpdated('Player Level Updated'),
  programCompleted('Coaching Program Completed');

  final String title;
  String get label => title;
  const ActivityType(this.title);

  static ActivityType fromString(String? value) {
    for (final type in ActivityType.values) {
      if (type.name == value || type.title == value) return type;
    }
    return ActivityType.sessionRecorded;
  }
}
