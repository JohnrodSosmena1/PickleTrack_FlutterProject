import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/coaching_room.dart';
import '../models/invitation.dart';
import '../models/evaluation.dart';
import '../models/drill.dart';
import '../models/training_program.dart';
import '../models/drill_assignment.dart';
import '../models/training_session.dart';
import '../models/drill_result.dart';
import '../models/coach_feedback.dart';
import '../models/activity_item.dart';
import '../core/constants/app_constants.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class CoachingProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  DrillDifficulty? _selectedDifficulty;

  CoachingProvider(this._firestoreService, this._authService);

  // Getters
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  DrillDifficulty? get selectedDifficulty => _selectedDifficulty;

  void setDrillFilters({String? category, DrillDifficulty? difficulty, String? query}) {
    if (category != null) _selectedCategory = category;
    if (difficulty != null) _selectedDifficulty = difficulty;
    if (query != null) _searchQuery = query;
    notifyListeners();
  }

  void clearDrillFilters() {
    _selectedCategory = 'All';
    _selectedDifficulty = null;
    _searchQuery = '';
    notifyListeners();
  }

  // ---------------------------------------------------------
  // USER CONTEXT HELPERS
  // ---------------------------------------------------------

  AppUser? get _currentUser => _authService.currentUser;
  String get _currentUserId => _currentUser?.uid ?? 'user_juan';

  // ---------------------------------------------------------
  // ROOMS
  // ---------------------------------------------------------

  List<CoachingRoom> get allUserRooms =>
      _firestoreService.getRoomsForUser(_currentUserId);

  List<CoachingRoom> get activeRooms =>
      allUserRooms.where((r) => r.isActive).toList();

  List<CoachingRoom> get pastRooms =>
      allUserRooms.where((r) => r.isCompleted || r.isArchived).toList();

  CoachingRoom? get activeRoom =>
      _firestoreService.getActiveRoomForPlayer(_currentUserId);

  CoachingRoom? getRoom(String roomId) =>
      _firestoreService.getRoomById(roomId);

  // ---------------------------------------------------------
  // INVITATIONS
  // ---------------------------------------------------------

  List<Invitation> get userInvitations =>
      _firestoreService.getInvitationsForUser(_currentUserId);

  List<Invitation> get pendingInvitations =>
      userInvitations.where((i) => i.isPending).toList();

  int get pendingInvitationsCount => pendingInvitations.length;

  Future<void> sendInvitation({
    required String playerEmail,
    required String proposedProgramName,
    required String proposedDuration,
    required DateTime proposedStartDate,
    String? message,
  }) async {
    final player = _authService.getUserByEmail(playerEmail);

    final invitation = Invitation(
      id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
      coachId: _currentUser?.uid ?? 'coach_mark',
      coachName: _currentUser?.fullName ?? 'Coach Mark',
      coachAvatarUrl: _currentUser?.profilePictureUrl,
      playerId: player?.uid ?? 'player_${DateTime.now().millisecondsSinceEpoch}',
      playerName: player?.fullName ?? playerEmail.split('@').first,
      playerEmail: playerEmail.trim().toLowerCase(),
      proposedProgramName: proposedProgramName,
      proposedDuration: proposedDuration,
      proposedStartDate: proposedStartDate,
      message: message,
      status: InvitationStatus.pending,
      createdAt: DateTime.now(),
    );

    await _firestoreService.sendInvitation(invitation);
    notifyListeners();
  }

  Future<void> acceptInvitation(String invitationId) async {
    await _firestoreService.respondToInvitation(invitationId, InvitationStatus.accepted);
    notifyListeners();
  }

  Future<void> declineInvitation(String invitationId) async {
    await _firestoreService.respondToInvitation(invitationId, InvitationStatus.declined);
    notifyListeners();
  }

  // ---------------------------------------------------------
  // EVALUATIONS
  // ---------------------------------------------------------

  List<Evaluation> getEvaluationsForRoom(String roomId) =>
      _firestoreService.getEvaluationsForRoom(roomId);

  Evaluation? getLatestEvaluation(String roomId) =>
      _firestoreService.getLatestEvaluationForRoom(roomId);

  Evaluation? getInitialEvaluation(String roomId) =>
      _firestoreService.getInitialEvaluationForRoom(roomId);

  Future<void> saveEvaluation({
    required String roomId,
    required String playerId,
    required Map<String, int> skillRatings,
    Map<String, String> observations = const {},
    String? generalNotes,
    required PlayerLevel assignedLevel,
    String evaluationType = 'progress',
  }) async {
    final eval = Evaluation(
      id: 'eval_${DateTime.now().millisecondsSinceEpoch}',
      roomId: roomId,
      coachId: _currentUserId,
      playerId: playerId,
      evaluationType: evaluationType,
      evaluationDate: DateTime.now(),
      skillRatings: skillRatings,
      observations: observations,
      generalNotes: generalNotes,
      assignedLevel: assignedLevel,
      createdAt: DateTime.now(),
    );

    await _firestoreService.saveEvaluation(eval);
    notifyListeners();
  }

  // ---------------------------------------------------------
  // DRILLS
  // ---------------------------------------------------------

  List<Drill> get filteredDrills => _firestoreService.getDrills(
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
        query: _searchQuery,
      );

  Drill? getDrill(String drillId) => _firestoreService.getDrillById(drillId);

  Future<void> createDrill({
    required String name,
    required String category,
    required DrillDifficulty difficulty,
    required String objective,
    required String description,
    required List<String> instructions,
    int recommendedRepetitions = 20,
    String equipment = 'Paddle, 4+ Pickleballs, Court',
    String? imageUrl,
  }) async {
    final drill = Drill(
      id: 'drill_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      category: category,
      difficulty: difficulty,
      objective: objective,
      description: description,
      instructions: instructions,
      recommendedRepetitions: recommendedRepetitions,
      equipment: equipment,
      imageUrl: imageUrl,
      creatorId: _currentUserId,
      isPublic: true,
      createdAt: DateTime.now(),
    );

    await _firestoreService.saveDrill(drill);
    notifyListeners();
  }

  // ---------------------------------------------------------
  // TRAINING PROGRAM & ASSIGNMENTS
  // ---------------------------------------------------------

  TrainingProgram? getProgramForRoom(String roomId) =>
      _firestoreService.getProgramForRoom(roomId);

  List<DrillAssignment> getAssignmentsForRoom(String roomId) =>
      _firestoreService.getAssignmentsForRoom(roomId);

  Future<void> assignDrill({
    required String roomId,
    required String programId,
    required Drill drill,
    int targetRepetitions = 20,
    int targetSuccessfulAttempts = 14,
    double targetAccuracy = 70.0,
    int weekNumber = 1,
    String? instructions,
    String? coachNotes,
  }) async {
    final assignment = DrillAssignment(
      id: 'assign_${DateTime.now().millisecondsSinceEpoch}',
      roomId: roomId,
      programId: programId,
      drillId: drill.id,
      drillName: drill.name,
      drillCategory: drill.category,
      targetRepetitions: targetRepetitions,
      targetSuccessfulAttempts: targetSuccessfulAttempts,
      targetAccuracy: targetAccuracy,
      weekNumber: weekNumber,
      instructions: instructions,
      coachNotes: coachNotes,
      status: 'assigned',
      createdAt: DateTime.now(),
    );

    await _firestoreService.saveAssignment(assignment);
    notifyListeners();
  }

  // ---------------------------------------------------------
  // SESSIONS & DRILL RESULTS
  // ---------------------------------------------------------

  List<TrainingSession> getSessionsForRoom(String roomId) =>
      _firestoreService.getSessionsForRoom(roomId);

  TrainingSession? getNextScheduledSession(String roomId) =>
      _firestoreService.getNextScheduledSession(roomId);

  List<TrainingSession> get todayCoachSessions =>
      _firestoreService.getTodaySessionsForCoach(_currentUserId);

  List<DrillResult> getDrillResultsForSession(String sessionId) =>
      _firestoreService.getDrillResultsForSession(sessionId);

  List<DrillResult> getDrillResultsForRoom(String roomId) =>
      _firestoreService.getDrillResultsForRoom(roomId);

  Future<void> recordSession({
    required String roomId,
    required String playerId,
    required DateTime sessionDate,
    required AttendanceStatus attendanceStatus,
    required List<String> drillsCovered,
    required List<DrillResult> results,
    String? notes,
    String? feedback,
  }) async {
    final sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    final session = TrainingSession(
      id: sessionId,
      roomId: roomId,
      coachId: _currentUserId,
      playerId: playerId,
      sessionDate: sessionDate,
      attendanceStatus: attendanceStatus,
      sessionStatus: SessionStatus.completed,
      drillsCovered: drillsCovered,
      notes: notes,
      feedback: feedback,
      createdAt: DateTime.now(),
    );

    final mappedResults = results.map((r) {
      return DrillResult(
        id: 'res_${DateTime.now().millisecondsSinceEpoch}_${r.drillName.hashCode}',
        roomId: roomId,
        sessionId: sessionId,
        drillId: r.drillId,
        drillName: r.drillName,
        assignmentId: r.assignmentId,
        attempts: r.attempts,
        successfulAttempts: r.successfulAttempts,
        accuracy: r.accuracy,
        notes: r.notes,
        recordedBy: _currentUser?.fullName ?? 'Coach Mark',
      );
    }).toList();

    await _firestoreService.saveSession(session, mappedResults);

    if (feedback != null && feedback.trim().isNotEmpty) {
      await saveFeedback(
        roomId: roomId,
        playerId: playerId,
        sessionId: sessionId,
        message: feedback.trim(),
      );
    }

    notifyListeners();
  }

  // ---------------------------------------------------------
  // FEEDBACK
  // ---------------------------------------------------------

  List<CoachFeedback> getFeedbackForRoom(String roomId) =>
      _firestoreService.getFeedbackForRoom(roomId);

  CoachFeedback? getLatestFeedback(String playerId) =>
      _firestoreService.getLatestFeedbackForPlayer(playerId);

  Future<void> saveFeedback({
    required String roomId,
    required String playerId,
    String? sessionId,
    String? assignmentId,
    required String message,
  }) async {
    final fb = CoachFeedback(
      id: 'fb_${DateTime.now().millisecondsSinceEpoch}',
      roomId: roomId,
      coachId: _currentUserId,
      coachName: _currentUser?.fullName ?? 'Coach Mark',
      playerId: playerId,
      sessionId: sessionId,
      assignmentId: assignmentId,
      message: message,
      createdAt: DateTime.now(),
    );

    await _firestoreService.saveFeedback(fb);
    notifyListeners();
  }

  // ---------------------------------------------------------
  // RECENT ACTIVITIES
  // ---------------------------------------------------------

  List<ActivityItem> get recentActivities =>
      _firestoreService.getRecentActivities(limit: 5);

  List<ActivityItem> get allActivities =>
      _firestoreService.getAllActivities();

  // ---------------------------------------------------------
  // END / ARCHIVE COACHING PROGRAM
  // ---------------------------------------------------------

  Future<void> endCoachingProgram(String roomId, String notes) async {
    await _firestoreService.completeCoachingRoom(roomId, notes);
    notifyListeners();
  }
}
