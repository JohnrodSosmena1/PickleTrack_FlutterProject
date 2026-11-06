import '../models/app_user.dart';
import '../models/drill.dart';
import '../models/coaching_room.dart';
import '../models/invitation.dart';
import '../models/evaluation.dart';
import '../models/training_program.dart';
import '../models/drill_assignment.dart';
import '../models/training_session.dart';
import '../models/drill_result.dart';
import '../models/coach_feedback.dart';
import '../models/activity_item.dart';
import '../core/constants/app_constants.dart';

class DemoDataSeeder {
  static List<Drill> getSeedDrills() {
    return [
      Drill(
        id: 'drill_1',
        name: 'Cross-Court Dinking',
        category: 'Dinking',
        difficulty: DrillDifficulty.beginner,
        objective: 'Build muscle memory, patience, and unattackable low trajectory in cross-court kitchen exchanges.',
        description: 'Both players stand diagonally at the non-volley zone (NVZ) kitchen line and engage in sustained cross-court dinking rallies.',
        instructions: [
          'Position feet shoulder-width apart behind kitchen line with paddle out in front.',
          'Lift ball with shoulder push without wrist flicking.',
          'Keep ball height within 2-4 inches above the net cord.',
          'Aim cross-court into the opponent’s kitchen zone.',
          'Perform 20 continuous controlled exchanges.'
        ],
        recommendedRepetitions: 20,
        equipment: 'Paddle, 2 balls, court kitchen zone',
      ),
      Drill(
        id: 'drill_2',
        name: 'Deep Serve Placement',
        category: 'Serving',
        difficulty: DrillDifficulty.intermediate,
        objective: 'Develop high-percentage deep serves landing in the back 2 feet of the service box to pin opponents back.',
        description: 'Practice serving to corners and deep baseline targets under coach observation and target scoring.',
        instructions: [
          'Establish pre-serve routine and target point.',
          'Maintain upward paddle arc with consistent contact below the waist.',
          'Target the deep centerline and outer sideline corners.',
          'Track target depth and landing accuracy across 20 serves.'
        ],
        recommendedRepetitions: 20,
        equipment: 'Paddle, 10 pickleballs, baseline target cones',
      ),
      Drill(
        id: 'drill_3',
        name: 'Third-Shot Drop Consistency',
        category: 'Third-Shot Drop',
        difficulty: DrillDifficulty.intermediate,
        objective: 'Master the high-percentage soft arc drop from the baseline into the opposing kitchen to neutralize opponent advantage.',
        description: 'Player feeds or receives returns from baseline, dropping gently into the kitchen target hoops.',
        instructions: [
          'Stay balanced behind baseline with open paddle face.',
          'Lift ball softly using legs and shoulder stroke.',
          'Aim ball to apex on player side of the net and drop into the kitchen.',
          'Move forward toward the NVZ after executing high quality drops.'
        ],
        recommendedRepetitions: 20,
        equipment: 'Paddle, 12 balls, target hoops in kitchen',
      ),
      Drill(
        id: 'drill_4',
        name: 'Third-Shot Drive Accuracy',
        category: 'Third-Shot Drive',
        difficulty: DrillDifficulty.intermediate,
        objective: 'Deliver heavy topspin drives low across net to freeze NVZ opponents or force pop-ups.',
        description: 'Practice controlled aggressive third-shot drives down the middle and to opponent backhands.',
        instructions: [
          'Transfer body weight forward through contact.',
          'Brush upward from low to high for heavy topspin.',
          'Clear net by only 6 inches to prevent volleys from being stepped on.',
          'Target opponent transition zone or middle line.'
        ],
        recommendedRepetitions: 20,
        equipment: 'Paddle, 10 pickleballs',
      ),
      Drill(
        id: 'drill_5',
        name: 'Volley Reaction Drill',
        category: 'Volley',
        difficulty: DrillDifficulty.advanced,
        objective: 'Increase hand speed, punch control, and block mechanics during rapid NVZ firefights.',
        description: 'Coach feeds fast alternating balls at NVZ while player executes punch and block volleys.',
        instructions: [
          'Keep paddle at eye level in ready position between shots.',
          'Punch with short 3-inch forward extension, avoiding backswing.',
          'Angle paddle face down on attack volleys and soft on block resets.',
          'Maintain athletic low stance and soft grip.'
        ],
        recommendedRepetitions: 25,
        equipment: 'Paddle, bucket of balls',
      ),
      Drill(
        id: 'drill_6',
        name: 'Groundstroke Consistency',
        category: 'Groundstroke',
        difficulty: DrillDifficulty.beginner,
        objective: 'Establish reliable topspin and slice groundstrokes from deep baseline positions.',
        description: 'Rally from baseline to baseline with emphasis on depth and minimal unforced errors.',
        instructions: [
          'Split-step as opponent strikes ball.',
          'Early unit turn with non-dominant arm tracking incoming ball.',
          'Strike ball in front of lead hip.',
          'Follow through to opposite shoulder.'
        ],
        recommendedRepetitions: 20,
        equipment: 'Paddle, 6 balls',
      ),
      Drill(
        id: 'drill_7',
        name: 'Reset Under Pressure',
        category: 'Reset',
        difficulty: DrillDifficulty.advanced,
        objective: 'Absorb hard overheads and fast body attacks from midcourt and drop them cleanly into kitchen.',
        description: 'Coach smashes or attacks from NVZ; player in transition zone absorbs pace with loose paddle grip.',
        instructions: [
          'Hold paddle with relaxed grip pressure (3 out of 10).',
          'Let the paddle cushion the incoming speed without swinging forward.',
          'Direct the bounce into the deepest part of the opponent kitchen.',
          'Prepare instantly for the next attack.'
        ],
        recommendedRepetitions: 20,
        equipment: 'Paddle, balls, safety glasses recommended',
      ),
      Drill(
        id: 'drill_8',
        name: 'Return of Serve Depth',
        category: 'Return of Serve',
        difficulty: DrillDifficulty.beginner,
        objective: 'Keep returning team in control by sending returns deep into baseline corners.',
        description: 'Receive coach serves and return deep with generous clearance to allow partner and self to reach kitchen line.',
        instructions: [
          'Stand 1-2 feet behind baseline to allow for deep serves.',
          'Step forward into return with smooth continuous stroke.',
          'Target the deep center or opponent’s weaker wing.',
          'Follow return immediately to the non-volley zone line.'
        ],
        recommendedRepetitions: 20,
        equipment: 'Paddle, 10 pickleballs',
      ),
      Drill(
        id: 'drill_9',
        name: 'Transition Zone Control',
        category: 'Transition',
        difficulty: DrillDifficulty.intermediate,
        objective: 'Transition safely from baseline to kitchen through the no-man’s land using drop-and-step technique.',
        description: 'Player progresses through midcourt, executing drops and reset volleys while moving forward.',
        instructions: [
          'Split-step whenever the ball is hit on opponent side.',
          'Never hit while running; pause, balance, drop, then advance.',
          'Reach kitchen line within 2 drop shots.',
          'Establish solid stance at kitchen before next ball.'
        ],
        recommendedRepetitions: 15,
        equipment: 'Paddle, 8 pickleballs',
      ),
      Drill(
        id: 'drill_10',
        name: 'Doubles Positioning Drill',
        category: 'Doubles Strategy',
        difficulty: DrillDifficulty.intermediate,
        objective: 'Reinforce tandem movement, middle coverage, and court geometry with partner.',
        description: 'Simulated point play practicing lateral shifts and callouts on middle balls.',
        instructions: [
          'Move together connected by an imaginary 10-foot rope.',
          'Player on diagonal covers down-the-line; partner protects middle.',
          'Verbalize "MINE" or "YOURS" early on floaters.',
          'Shift laterally with opponent ball trajectory.'
        ],
        recommendedRepetitions: 15,
        equipment: 'Paddles, 6 balls, 4 players or coach assist',
      ),
    ];
  }

  static List<AppUser> getSeedUsers() {
    return [
      AppUser(
        uid: 'user_juan',
        fullName: 'Juan Dela Cruz',
        email: 'juan@email.com',
        role: UserRole.player,
        profilePictureUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
        playerLevel: PlayerLevel.intermediate,
        bio: 'Dedicated pickleball player working on 3rd shot drops and kitchen dinking patience.',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      AppUser(
        uid: 'coach_mark',
        fullName: 'Coach Mark',
        email: 'coach.mark@pickletrack.com',
        role: UserRole.coach,
        profilePictureUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
        specialization: 'Tactical & 3rd Shot Strategy',
        bio: 'PPR Certified Pickleball Coach with 10+ years of player development experience.',
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
      ),
      AppUser(
        uid: 'player_john',
        fullName: 'John Santos',
        email: 'john@pickletrack.com',
        role: UserRole.player,
        profilePictureUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400&auto=format&fit=crop&q=80',
        playerLevel: PlayerLevel.intermediate,
        bio: 'Passionate pickleball player working on 3rd shot drops and court positioning.',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      AppUser(
        uid: 'player_alex',
        fullName: 'Alex Rivera',
        email: 'alex@pickletrack.com',
        role: UserRole.player,
        profilePictureUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80',
        playerLevel: PlayerLevel.beginner,
        bio: 'Pickleball enthusiast building solid foundations.',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      AppUser(
        uid: 'player_james',
        fullName: 'James Lee',
        email: 'james@pickletrack.com',
        role: UserRole.player,
        profilePictureUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80',
        playerLevel: PlayerLevel.developing,
        bio: 'Working to transition from casual recreational to tournament play.',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
  }

  static CoachingRoom getSeedRoom() {
    return CoachingRoom(
      id: 'room_john_mark',
      coachId: 'coach_mark',
      coachName: 'Coach Mark',
      coachAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
      playerId: 'user_juan',
      playerName: 'Juan Dela Cruz',
      playerAvatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400&auto=format&fit=crop&q=80',
      programName: 'Intermediate Development',
      startDate: DateTime(2026, 10, 1),
      plannedEndDate: DateTime(2026, 12, 31),
      status: CoachingRoomStatus.active,
      mainGoal: 'Improve third-shot drop consistency',
      secondaryGoals: [
        'Better court positioning',
        'Reduce unforced errors',
      ],
      trainingFrequency: '2x per week',
      totalSessions: 8,
      latestEvaluationScore: 7.2,
      createdAt: DateTime(2026, 10, 1),
    );
  }

  static CoachingRoom getPastSeedRoom() {
    return CoachingRoom(
      id: 'room_john_alex_past',
      coachId: 'coach_alex_smith',
      coachName: 'Coach Alex',
      coachAvatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80',
      playerId: 'user_juan',
      playerName: 'Juan Dela Cruz',
      playerAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
      programName: 'Beginner Foundation',
      startDate: DateTime(2026, 1, 5),
      plannedEndDate: DateTime(2026, 3, 30),
      completedAt: DateTime(2026, 3, 30),
      status: CoachingRoomStatus.completed,
      mainGoal: 'Master pickleball fundamentals and rules',
      secondaryGoals: ['Learn basic dinking', 'Consistent legal serving'],
      trainingFrequency: '2x per week',
      totalSessions: 12,
      latestEvaluationScore: 5.2,
      completionNotes: 'Juan successfully demonstrated complete grasp of court rules, basic dinking exchanges, and proper baseline stance.',
      createdAt: DateTime(2026, 1, 5),
    );
  }

  static List<Evaluation> getSeedEvaluations() {
    return [
      Evaluation(
        id: 'eval_initial_john',
        roomId: 'room_john_mark',
        coachId: 'coach_mark',
        playerId: 'user_juan',
        evaluationType: 'initial',
        evaluationDate: DateTime(2026, 10, 1),
        skillRatings: {
          'Serve': 6,
          'Return of Serve': 5,
          'Dinking': 4,
          'Volley': 6,
          'Groundstrokes': 7,
          'Third-Shot Drop': 3,
          'Third-Shot Drive': 6,
          'Reset Shots': 4,
          'Transition Game': 5,
          'Court Positioning': 5,
          'Shot Selection': 5,
          'Consistency': 6,
          'Doubles Communication': 6,
        },
        observations: {
          'Dinking': 'Tends to hurry the shot and pop balls up over net.',
          'Third-Shot Drop': 'Pushes wrist through ball rather than lifting with legs and shoulder.',
          'Groundstrokes': 'Good power and baseline depth.',
        },
        generalNotes: 'Solid athletic baseline. Needs focus on kitchen patience and third-shot drops.',
        overallScore: 5.2,
        assignedLevel: PlayerLevel.developing,
        createdAt: DateTime(2026, 10, 1),
      ),
      Evaluation(
        id: 'eval_latest_john',
        roomId: 'room_john_mark',
        coachId: 'coach_mark',
        playerId: 'user_juan',
        evaluationType: 'progress',
        evaluationDate: DateTime(2026, 10, 23),
        skillRatings: {
          'Serve': 8,
          'Return of Serve': 7,
          'Dinking': 7,
          'Volley': 6,
          'Groundstrokes': 8,
          'Third-Shot Drop': 7,
          'Third-Shot Drive': 7,
          'Reset Shots': 7,
          'Transition Game': 7,
          'Court Positioning': 8,
          'Shot Selection': 7,
          'Consistency': 8,
          'Doubles Communication': 7,
        },
        observations: {
          'Dinking': 'Remarkable patience improvement. Stays low at NVZ.',
          'Third-Shot Drop': 'Arc trajectory is consistent into the kitchen apex.',
          'Serve': 'Placement depth is consistently within back 2 feet.',
        },
        generalNotes: 'Superb development over the last 3 weeks. Ready for intermediate match play.',
        overallScore: 7.2,
        assignedLevel: PlayerLevel.intermediate,
        createdAt: DateTime(2026, 10, 23),
      ),
    ];
  }

  static TrainingProgram getSeedProgram() {
    return TrainingProgram(
      id: 'prog_intermediate_john',
      roomId: 'room_john_mark',
      name: 'Intermediate Development',
      description: 'Personalized pickleball training focused on third-shot execution, soft game control, and court positioning.',
      mainGoal: 'Improve third-shot drop consistency',
      secondaryGoals: [
        'Better court positioning',
        'Reduce unforced errors',
      ],
      startDate: DateTime(2026, 10, 1),
      endDate: DateTime(2026, 12, 31),
      trainingFrequency: '2x per week',
      status: 'active',
      createdAt: DateTime(2026, 10, 1),
    );
  }

  static List<DrillAssignment> getSeedAssignments() {
    return [
      DrillAssignment(
        id: 'assign_1',
        roomId: 'room_john_mark',
        programId: 'prog_intermediate_john',
        drillId: 'drill_1',
        drillName: 'Cross-Court Dinking',
        drillCategory: 'Dinking',
        targetRepetitions: 20,
        targetSuccessfulAttempts: 14,
        targetAccuracy: 70.0,
        weekNumber: 1,
        instructions: 'Focus on staying behind kitchen line and keeping paddle face open.',
        coachNotes: 'Watch footwork when reaching to the backhand side.',
        status: 'completed',
      ),
      DrillAssignment(
        id: 'assign_2',
        roomId: 'room_john_mark',
        programId: 'prog_intermediate_john',
        drillId: 'drill_3',
        drillName: 'Third-Shot Drop Fundamentals',
        drillCategory: 'Third-Shot Drop',
        targetRepetitions: 15,
        targetSuccessfulAttempts: 9,
        targetAccuracy: 60.0,
        weekNumber: 1,
        instructions: 'Drop balls from baseline into target hoops.',
        coachNotes: 'Lift with shoulders, don’t swat.',
        status: 'completed',
      ),
      DrillAssignment(
        id: 'assign_3',
        roomId: 'room_john_mark',
        programId: 'prog_intermediate_john',
        drillId: 'drill_7',
        drillName: 'Reset Under Pressure',
        drillCategory: 'Reset',
        targetRepetitions: 20,
        targetSuccessfulAttempts: 15,
        targetAccuracy: 75.0,
        weekNumber: 2,
        instructions: 'Neutralize hard coach feeds from midcourt.',
        coachNotes: 'Keep grip loose to absorb pace.',
        status: 'in_progress',
      ),
      DrillAssignment(
        id: 'assign_4',
        roomId: 'room_john_mark',
        programId: 'prog_intermediate_john',
        drillId: 'drill_9',
        drillName: 'Transition Zone Control',
        drillCategory: 'Transition',
        targetRepetitions: 15,
        targetSuccessfulAttempts: 12,
        targetAccuracy: 80.0,
        weekNumber: 2,
        instructions: 'Move baseline to kitchen with 2 drop-and-step stops.',
        coachNotes: 'Never hit on the run.',
        status: 'assigned',
      ),
    ];
  }

  static List<TrainingSession> getSeedSessions() {
    return [
      TrainingSession(
        id: 'session_1',
        roomId: 'room_john_mark',
        coachId: 'coach_mark',
        playerId: 'player_john',
        sessionDate: DateTime(2026, 10, 25, 17, 0),
        startTime: '5:00 PM',
        endTime: '6:30 PM',
        attendanceStatus: AttendanceStatus.present,
        sessionStatus: SessionStatus.completed,
        drillsCovered: ['Third-Shot Drop', 'Dinking', 'Volley'],
        notes: 'Good control today. Still needs work on transition shots.',
        feedback: 'Great improvement on the soft game! Your third-shot drop consistency was noticeable.',
        createdAt: DateTime(2026, 10, 25, 17, 0),
      ),
      TrainingSession(
        id: 'session_upcoming',
        roomId: 'room_john_mark',
        coachId: 'coach_mark',
        playerId: 'player_john',
        sessionDate: DateTime(2026, 10, 27, 17, 0),
        startTime: '5:00 PM',
        endTime: '6:30 PM',
        attendanceStatus: AttendanceStatus.present,
        sessionStatus: SessionStatus.scheduled,
        drillsCovered: ['Third-Shot Drop', 'Dinking', 'Volley'],
        notes: 'Targeting transition zone resets and baseline drops.',
        createdAt: DateTime(2026, 10, 25),
      ),
    ];
  }

  static List<DrillResult> getSeedDrillResults() {
    return [
      DrillResult(
        id: 'res_1',
        roomId: 'room_john_mark',
        sessionId: 'session_1',
        drillId: 'drill_3',
        drillName: 'Third-Shot Drop',
        assignmentId: 'assign_2',
        attempts: 20,
        successfulAttempts: 14,
        accuracy: 70.0,
        notes: 'Soft touch landed inside kitchen cleanly.',
        recordedBy: 'Coach Mark',
        createdAt: DateTime(2026, 10, 25, 17, 45),
      ),
      DrillResult(
        id: 'res_2',
        roomId: 'room_john_mark',
        sessionId: 'session_1',
        drillId: 'drill_1',
        drillName: 'Dinking',
        assignmentId: 'assign_1',
        attempts: 20,
        successfulAttempts: 16,
        accuracy: 80.0,
        notes: 'Cross-court angles were sharp.',
        recordedBy: 'Coach Mark',
        createdAt: DateTime(2026, 10, 25, 18, 10),
      ),
      DrillResult(
        id: 'res_3',
        roomId: 'room_john_mark',
        sessionId: 'session_1',
        drillId: 'drill_5',
        drillName: 'Volley',
        assignmentId: null,
        attempts: 20,
        successfulAttempts: 13,
        accuracy: 65.0,
        notes: 'Quick hand speed, keep paddle up between reps.',
        recordedBy: 'Coach Mark',
        createdAt: DateTime(2026, 10, 25, 18, 25),
      ),
    ];
  }

  static List<CoachFeedback> getSeedFeedback() {
    return [
      CoachFeedback(
        id: 'fb_1',
        roomId: 'room_john_mark',
        coachId: 'coach_mark',
        coachName: 'Coach Mark',
        playerId: 'player_john',
        sessionId: 'session_1',
        message: 'Great progress today, John! Your third-shot drop is much softer and has the right apex height.',
        createdAt: DateTime(2026, 10, 20),
      ),
      CoachFeedback(
        id: 'fb_2',
        roomId: 'room_john_mark',
        coachId: 'coach_mark',
        coachName: 'Coach Mark',
        playerId: 'player_john',
        message: 'Remember to pause before making the transition drop rather than hitting while running forward.',
        createdAt: DateTime(2026, 10, 23),
      ),
    ];
  }

  static List<ActivityItem> getSeedActivities() {
    return [
      ActivityItem(
        id: 'act_1',
        actorId: 'coach_mark',
        actorName: 'Coach Mark',
        roomId: 'room_john_mark',
        type: ActivityType.sessionRecorded,
        description: 'Oct 25 • 3 drills completed',
        createdAt: DateTime(2026, 10, 25, 18, 30),
      ),
      ActivityItem(
        id: 'act_2',
        actorId: 'coach_mark',
        actorName: 'Coach Mark',
        roomId: 'room_john_mark',
        type: ActivityType.evaluationUpdated,
        description: 'Oct 23 • Dinking: 7/10',
        createdAt: DateTime(2026, 10, 23, 16, 0),
      ),
      ActivityItem(
        id: 'act_3',
        actorId: 'coach_mark',
        actorName: 'Coach Mark',
        roomId: 'room_john_mark',
        type: ActivityType.feedbackAdded,
        description: 'Oct 20 • Great progress!',
        createdAt: DateTime(2026, 10, 20, 19, 0),
      ),
      ActivityItem(
        id: 'act_4',
        actorId: 'coach_mark',
        actorName: 'Coach Mark',
        roomId: 'room_john_mark',
        type: ActivityType.programAssigned,
        description: 'Oct 1 • Intermediate Development program started',
        createdAt: DateTime(2026, 10, 1, 10, 0),
      ),
    ];
  }

  static List<Invitation> getSeedInvitations() {
    return [
      Invitation(
        id: 'inv_to_juan',
        coachId: 'coach_sarah',
        coachName: 'Coach Sarah Miller',
        coachAvatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
        playerId: 'user_juan',
        playerName: 'Juan Dela Cruz',
        playerEmail: 'juan@email.com',
        proposedProgramName: 'Advanced Dink & Drop Masterclass',
        proposedDuration: '4 Weeks',
        proposedStartDate: DateTime.now().add(const Duration(days: 3)),
        message: 'Hey Juan, I noticed your great court mobility! Let’s partner up for this 4-week dinking & reset masterclass.',
        status: InvitationStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      Invitation(
        id: 'inv_1',
        coachId: 'coach_mark',
        coachName: 'Coach Mark',
        coachAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
        playerId: 'player_alex',
        playerName: 'Alex Rivera',
        playerEmail: 'alex@pickletrack.com',
        proposedProgramName: 'Beginner Foundation',
        proposedDuration: '3 Months',
        proposedStartDate: DateTime.now().add(const Duration(days: 3)),
        message: 'Looking forward to coaching you through your pickleball fundamentals!',
        status: InvitationStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      Invitation(
        id: 'inv_2',
        coachId: 'coach_mark',
        coachName: 'Coach Mark',
        coachAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
        playerId: 'player_james',
        playerName: 'James Lee',
        playerEmail: 'james@pickletrack.com',
        proposedProgramName: 'Tournament Prep & Drills',
        proposedDuration: '2 Months',
        proposedStartDate: DateTime.now().add(const Duration(days: 7)),
        message: 'Let’s work on your tournament prep and match play strategies.',
        status: InvitationStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 24)),
      ),
    ];
  }
}
