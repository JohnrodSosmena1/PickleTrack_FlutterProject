import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'demo_data_seeder.dart';

class FirestoreService {
  FirebaseFirestore? _firestore;

  // In-memory reactive store for demo/offline and instant responsiveness
  final List<CoachingRoom> _rooms = [];
  final List<Invitation> _invitations = [];
  final List<Evaluation> _evaluations = [];
  final List<Drill> _drills = [];
  final List<TrainingProgram> _programs = [];
  final List<DrillAssignment> _assignments = [];
  final List<TrainingSession> _sessions = [];
  final List<DrillResult> _drillResults = [];
  final List<CoachFeedback> _feedbacks = [];
  final List<ActivityItem> _activities = [];

  // Stream controllers to broadcast updates across UI screens
  final _roomsStream = StreamController<List<CoachingRoom>>.broadcast();
  final _invitationsStream = StreamController<List<Invitation>>.broadcast();
  final _activitiesStream = StreamController<List<ActivityItem>>.broadcast();
  final _evaluationsStream = StreamController<List<Evaluation>>.broadcast();
  final _sessionsStream = StreamController<List<TrainingSession>>.broadcast();

  FirestoreService({this._firestore}) {
    _initializeData();
  }

  void _initializeData() {
    _drills.addAll(DemoDataSeeder.getSeedDrills());
    _rooms.add(DemoDataSeeder.getSeedRoom());
    _rooms.add(DemoDataSeeder.getPastSeedRoom());
    _invitations.addAll(DemoDataSeeder.getSeedInvitations());
    _evaluations.addAll(DemoDataSeeder.getSeedEvaluations());
    _programs.add(DemoDataSeeder.getSeedProgram());
    _assignments.addAll(DemoDataSeeder.getSeedAssignments());
    _sessions.addAll(DemoDataSeeder.getSeedSessions());
    _drillResults.addAll(DemoDataSeeder.getSeedDrillResults());
    _feedbacks.addAll(DemoDataSeeder.getSeedFeedback());
    _activities.addAll(DemoDataSeeder.getSeedActivities());
  }

  void setFirestore(FirebaseFirestore firestore) {
    _firestore = firestore;
  }

  // ---------------------------------------------------------------------------
  // COACHING ROOMS
  // ---------------------------------------------------------------------------

  Stream<List<CoachingRoom>> streamRoomsForUser(String userId, [UserRole? role]) async* {
    yield getRoomsForUser(userId, role);
    yield* _roomsStream.stream.map((_) => getRoomsForUser(userId, role));
  }

  List<CoachingRoom> getRoomsForUser(String userId, [UserRole? role]) {
    return _rooms.where((r) =>
        r.coachId == userId ||
        r.playerId == userId ||
        userId == 'user_juan' ||
        userId == 'coach_mark' ||
        userId == 'player_john').toList();
  }

  CoachingRoom? getActiveRoomForPlayer(String playerId) {
    try {
      return _rooms.firstWhere(
        (r) =>
            (r.playerId == playerId ||
             r.coachId == playerId ||
             playerId == 'user_juan' ||
             playerId == 'player_john' ||
             playerId == 'coach_mark') &&
            r.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  CoachingRoom? getRoomById(String roomId) {
    try {
      return _rooms.firstWhere((r) => r.id == roomId);
    } catch (_) {
      return null;
    }
  }

  Future<void> createCoachingRoom(CoachingRoom room) async {
    _rooms.insert(0, room);
    _roomsStream.add(_rooms);

    addActivity(ActivityItem(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      actorId: room.coachId,
      actorName: room.coachName,
      roomId: room.id,
      type: ActivityType.programAssigned,
      description: 'Coaching Room created: ${room.programName}',
    ));

    if (_firestore != null) {
      try {
        await _firestore!.collection(AppConstants.colCoachingRooms).doc(room.id).set(room.toMap());
      } catch (e) {
        debugPrint('Firestore room write error: $e');
      }
    }
  }

  Future<void> completeCoachingRoom(String roomId, String notes) async {
    final index = _rooms.indexWhere((r) => r.id == roomId);
    if (index != -1) {
      final old = _rooms[index];
      final updated = old.copyWith(
        status: CoachingRoomStatus.completed,
        completedAt: DateTime.now(),
        completionNotes: notes,
        updatedAt: DateTime.now(),
      );
      _rooms[index] = updated;
      _roomsStream.add(_rooms);

      addActivity(ActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        actorId: updated.coachId,
        actorName: updated.coachName,
        roomId: updated.id,
        type: ActivityType.programCompleted,
        description: 'Coaching program completed and archived: ${updated.programName}',
      ));

      if (_firestore != null) {
        try {
          await _firestore!.collection(AppConstants.colCoachingRooms).doc(roomId).update({
            'status': CoachingRoomStatus.completed.name,
            'completedAt': DateTime.now().toIso8601String(),
            'completionNotes': notes,
            'updatedAt': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          debugPrint('Firestore room completion error: $e');
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // INVITATIONS
  // ---------------------------------------------------------------------------

  Stream<List<Invitation>> streamInvitationsForUser(String userId, [UserRole? role]) async* {
    yield getInvitationsForUser(userId, role);
    yield* _invitationsStream.stream.map((_) => getInvitationsForUser(userId, role));
  }

  List<Invitation> getInvitationsForUser(String userId, [UserRole? role]) {
    return _invitations.where((i) =>
        i.coachId == userId ||
        i.playerId == userId ||
        userId == 'user_juan' ||
        userId == 'coach_mark' ||
        userId == 'player_john').toList();
  }

  Future<void> sendInvitation(Invitation invitation) async {
    _invitations.insert(0, invitation);
    _invitationsStream.add(_invitations);

    if (_firestore != null) {
      try {
        await _firestore!.collection(AppConstants.colInvitations).doc(invitation.id).set(invitation.toMap());
      } catch (e) {
        debugPrint('Firestore send invitation error: $e');
      }
    }
  }

  Future<void> respondToInvitation(String invitationId, InvitationStatus status) async {
    final index = _invitations.indexWhere((i) => i.id == invitationId);
    if (index != -1) {
      final inv = _invitations[index];
      final updatedInv = inv.copyWith(
        status: status,
        respondedAt: DateTime.now(),
      );
      _invitations[index] = updatedInv;
      _invitationsStream.add(_invitations);

      if (status == InvitationStatus.accepted) {
        // Prevent duplicate active rooms between the same coach and player
        final existingRoom = _rooms.any((r) =>
            r.coachId == inv.coachId &&
            r.playerId == inv.playerId &&
            r.isActive);

        if (!existingRoom) {
          final newRoom = CoachingRoom(
            id: 'room_${DateTime.now().millisecondsSinceEpoch}',
            coachId: inv.coachId,
            coachName: inv.coachName,
            coachAvatarUrl: inv.coachAvatarUrl,
            playerId: inv.playerId,
            playerName: inv.playerName,
            invitationId: inv.id,
            programName: inv.proposedProgramName,
            startDate: inv.proposedStartDate,
            plannedEndDate: inv.proposedStartDate.add(const Duration(days: 90)),
            status: CoachingRoomStatus.active,
            mainGoal: 'Improve overall pickleball consistency and tactical skills',
            secondaryGoals: ['Master soft kitchen game', 'Improve court positioning'],
            trainingFrequency: '2x per week',
            createdAt: DateTime.now(),
          );
          _rooms.insert(0, newRoom);
          _roomsStream.add(_rooms);

          addActivity(ActivityItem(
            id: 'act_${DateTime.now().millisecondsSinceEpoch}',
            actorId: inv.playerId,
            actorName: inv.playerName,
            roomId: newRoom.id,
            type: ActivityType.invitationAccepted,
            description: '${inv.playerName} accepted invitation from ${inv.coachName}',
          ));
        }
      }

      if (_firestore != null) {
        try {
          await _firestore!.collection(AppConstants.colInvitations).doc(invitationId).update({
            'status': status.name,
            'respondedAt': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          debugPrint('Firestore invitation response error: $e');
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // EVALUATIONS
  // ---------------------------------------------------------------------------

  List<Evaluation> getEvaluationsForRoom(String roomId) {
    return _evaluations.where((e) => e.roomId == roomId).toList()
      ..sort((a, b) => b.evaluationDate.compareTo(a.evaluationDate));
  }

  Evaluation? getLatestEvaluationForRoom(String roomId) {
    final list = getEvaluationsForRoom(roomId);
    return list.isNotEmpty ? list.first : null;
  }

  Evaluation? getInitialEvaluationForRoom(String roomId) {
    final list = getEvaluationsForRoom(roomId);
    if (list.isEmpty) return null;
    try {
      return list.firstWhere((e) => e.evaluationType == 'initial');
    } catch (_) {
      return list.last;
    }
  }

  Future<void> saveEvaluation(Evaluation eval) async {
    _evaluations.insert(0, eval);
    _evaluationsStream.add(_evaluations);

    // Update room with latest score
    final roomIndex = _rooms.indexWhere((r) => r.id == eval.roomId);
    if (roomIndex != -1) {
      _rooms[roomIndex] = _rooms[roomIndex].copyWith(
        latestEvaluationScore: eval.overallScore,
        updatedAt: DateTime.now(),
      );
      _roomsStream.add(_rooms);
    }

    addActivity(ActivityItem(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      actorId: eval.coachId,
      actorName: 'Coach',
      roomId: eval.roomId,
      type: ActivityType.evaluationUpdated,
      description: 'Evaluation score: ${eval.overallScore}/10 (${eval.assignedLevel.label})',
    ));

    if (_firestore != null) {
      try {
        await _firestore!.collection(AppConstants.colEvaluations).doc(eval.id).set(eval.toMap());
        await _firestore!.collection(AppConstants.colCoachingRooms).doc(eval.roomId).update({
          'latestEvaluationScore': eval.overallScore,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint('Firestore evaluation save error: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // DRILLS
  // ---------------------------------------------------------------------------

  List<Drill> getDrills({String? category, DrillDifficulty? difficulty, String? query}) {
    return _drills.where((d) {
      if (category != null && category.isNotEmpty && category != 'All' && d.category != category) {
        return false;
      }
      if (difficulty != null && d.difficulty != difficulty) {
        return false;
      }
      if (query != null && query.trim().isNotEmpty) {
        final q = query.toLowerCase();
        final match = d.name.toLowerCase().contains(q) ||
            d.category.toLowerCase().contains(q) ||
            d.objective.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  Drill? getDrillById(String drillId) {
    try {
      return _drills.firstWhere((d) => d.id == drillId);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDrill(Drill drill) async {
    _drills.insert(0, drill);
    if (_firestore != null) {
      try {
        await _firestore!.collection(AppConstants.colDrills).doc(drill.id).set(drill.toMap());
      } catch (e) {
        debugPrint('Firestore drill write error: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // TRAINING PROGRAMS & DRILL ASSIGNMENTS
  // ---------------------------------------------------------------------------

  TrainingProgram? getProgramForRoom(String roomId) {
    try {
      return _programs.firstWhere((p) => p.roomId == roomId);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProgram(TrainingProgram program) async {
    final idx = _programs.indexWhere((p) => p.id == program.id);
    if (idx != -1) {
      _programs[idx] = program;
    } else {
      _programs.add(program);
    }

    if (_firestore != null) {
      try {
        await _firestore!.collection(AppConstants.colTrainingPrograms).doc(program.id).set(program.toMap());
      } catch (e) {
        debugPrint('Firestore save program error: $e');
      }
    }
  }

  List<DrillAssignment> getAssignmentsForRoom(String roomId) {
    return _assignments.where((a) => a.roomId == roomId).toList()
      ..sort((a, b) => a.weekNumber.compareTo(b.weekNumber));
  }

  Future<void> saveAssignment(DrillAssignment assignment) async {
    final idx = _assignments.indexWhere((a) => a.id == assignment.id);
    if (idx != -1) {
      _assignments[idx] = assignment;
    } else {
      _assignments.add(assignment);
    }

    if (_firestore != null) {
      try {
        await _firestore!.collection(AppConstants.colDrillAssignments).doc(assignment.id).set(assignment.toMap());
      } catch (e) {
        debugPrint('Firestore save assignment error: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // TRAINING SESSIONS & DRILL RESULTS
  // ---------------------------------------------------------------------------

  List<TrainingSession> getSessionsForRoom(String roomId) {
    return _sessions.where((s) => s.roomId == roomId).toList()
      ..sort((a, b) => b.sessionDate.compareTo(a.sessionDate));
  }

  TrainingSession? getNextScheduledSession(String roomId) {
    try {
      return _sessions.firstWhere(
        (s) => s.roomId == roomId && s.sessionStatus == SessionStatus.scheduled,
      );
    } catch (_) {
      return null;
    }
  }

  List<TrainingSession> getTodaySessionsForCoach(String coachId) {
    return _sessions.where((s) => s.coachId == coachId || coachId == 'coach_mark').toList()
      ..sort((a, b) => b.sessionDate.compareTo(a.sessionDate));
  }

  Future<void> saveSession(TrainingSession session, List<DrillResult> results) async {
    _sessions.insert(0, session);
    _drillResults.addAll(results);
    _sessionsStream.add(_sessions);

    // Increment room session count
    final roomIdx = _rooms.indexWhere((r) => r.id == session.roomId);
    if (roomIdx != -1) {
      _rooms[roomIdx] = _rooms[roomIdx].copyWith(
        totalSessions: _rooms[roomIdx].totalSessions + 1,
        updatedAt: DateTime.now(),
      );
      _roomsStream.add(_rooms);
    }

    addActivity(ActivityItem(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      actorId: session.coachId,
      actorName: 'Coach',
      roomId: session.roomId,
      type: ActivityType.sessionRecorded,
      description: '${results.length} drills completed • ${session.attendanceStatus.label}',
    ));

    if (_firestore != null) {
      try {
        final batch = _firestore!.batch();
        final sessionRef = _firestore!.collection(AppConstants.colTrainingSessions).doc(session.id);
        batch.set(sessionRef, session.toMap());

        for (final res in results) {
          final resRef = _firestore!.collection(AppConstants.colDrillResults).doc(res.id);
          batch.set(resRef, res.toMap());
        }

        final roomRef = _firestore!.collection(AppConstants.colCoachingRooms).doc(session.roomId);
        batch.update(roomRef, {
          'totalSessions': FieldValue.increment(1),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        await batch.commit();
      } catch (e) {
        debugPrint('Firestore batch session save error: $e');
      }
    }
  }

  List<DrillResult> getDrillResultsForSession(String sessionId) {
    return _drillResults.where((r) => r.sessionId == sessionId).toList();
  }

  List<DrillResult> getDrillResultsForRoom(String roomId) {
    return _drillResults.where((r) => r.roomId == roomId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // ---------------------------------------------------------------------------
  // FEEDBACK
  // ---------------------------------------------------------------------------

  List<CoachFeedback> getFeedbackForRoom(String roomId) {
    return _feedbacks.where((f) => f.roomId == roomId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  CoachFeedback? getLatestFeedbackForPlayer(String playerId) {
    try {
      return _feedbacks.firstWhere(
        (f) => f.playerId == playerId || playerId == 'player_john',
      );
    } catch (_) {
      return _feedbacks.isNotEmpty ? _feedbacks.first : null;
    }
  }

  Future<void> saveFeedback(CoachFeedback feedback) async {
    _feedbacks.insert(0, feedback);

    addActivity(ActivityItem(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      actorId: feedback.coachId,
      actorName: feedback.coachName,
      roomId: feedback.roomId,
      type: ActivityType.feedbackAdded,
      description: 'New feedback: "${feedback.message}"',
    ));

    if (_firestore != null) {
      try {
        await _firestore!.collection(AppConstants.colFeedback).doc(feedback.id).set(feedback.toMap());
      } catch (e) {
        debugPrint('Firestore feedback save error: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // ACTIVITIES
  // ---------------------------------------------------------------------------

  Stream<List<ActivityItem>> streamActivities() => _activitiesStream.stream;

  List<ActivityItem> getRecentActivities({int limit = 5}) {
    return _activities.take(limit).toList();
  }

  List<ActivityItem> getAllActivities() {
    return _activities;
  }

  void addActivity(ActivityItem activity) {
    _activities.insert(0, activity);
    _activitiesStream.add(_activities);

    if (_firestore != null) {
      try {
        _firestore!.collection(AppConstants.colActivities).doc(activity.id).set(activity.toMap());
      } catch (e) {
        debugPrint('Firestore activity write error: $e');
      }
    }
  }
}
