import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../core/constants/app_constants.dart';
import 'demo_data_seeder.dart';

class AuthService {
  FirebaseAuth? _firebaseAuth;
  final Map<String, AppUser> _mockUsers = {};
  AppUser? _currentMockUser;

  AuthService({this._firebaseAuth}) {
    // Populate initial demo accounts
    for (final user in DemoDataSeeder.getSeedUsers()) {
      _mockUsers[user.email.toLowerCase()] = user;
    }
  }

  void setFirebaseAuth(FirebaseAuth auth) {
    _firebaseAuth = auth;
  }

  bool get isFirebaseAvailable => _firebaseAuth != null;

  AppUser? get currentUser => _currentMockUser;

  Stream<AppUser?> authStateChanges() async* {
    if (_firebaseAuth != null) {
      await for (final user in _firebaseAuth!.authStateChanges()) {
        if (user == null) {
          _currentMockUser = null;
          yield null;
        } else {
          // If logged in via Firebase Auth, return current user representation
          yield _currentMockUser;
        }
      }
    } else {
      yield _currentMockUser;
    }
  }

  /// Sign In with Email and Password
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    if (_firebaseAuth != null) {
      try {
        final credential = await _firebaseAuth!.signInWithEmailAndPassword(
          email: cleanEmail,
          password: password,
        );
        final uid = credential.user?.uid ?? '';
        final existing = _mockUsers[cleanEmail];
        if (existing != null) {
          _currentMockUser = existing;
          return existing;
        }
        final newUser = AppUser(
          uid: uid,
          fullName: credential.user?.displayName ?? 'User',
          email: cleanEmail,
          role: UserRole.player,
        );
        _mockUsers[cleanEmail] = newUser;
        _currentMockUser = newUser;
        return newUser;
      } catch (e) {
        debugPrint('Firebase Auth sign in failed: $e. Checking mock store.');
        // If Firebase error occurs, let's check mock users
        if (_mockUsers.containsKey(cleanEmail)) {
          _currentMockUser = _mockUsers[cleanEmail];
          return _currentMockUser!;
        }
        rethrow;
      }
    }

    // Demo store fallback
    if (_mockUsers.containsKey(cleanEmail)) {
      _currentMockUser = _mockUsers[cleanEmail];
      return _currentMockUser!;
    }

    // Allow quick sign in for demo if unknown
    final newUser = AppUser(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: cleanEmail.split('@').first,
      email: cleanEmail,
      role: UserRole.player,
    );
    _mockUsers[cleanEmail] = newUser;
    _currentMockUser = newUser;
    return newUser;
  }

  /// Register with Email, Password, Name and Role
  Future<AppUser> registerWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    UserRole role = UserRole.player,
    String? profilePictureUrl,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    String uid = 'uid_${DateTime.now().millisecondsSinceEpoch}';

    if (_firebaseAuth != null) {
      try {
        final credential = await _firebaseAuth!.createUserWithEmailAndPassword(
          email: cleanEmail,
          password: password,
        );
        await credential.user?.updateDisplayName(fullName);
        uid = credential.user?.uid ?? uid;
      } catch (e) {
        debugPrint('Firebase register error: $e');
        // If user already exists in Firebase or mock store, rethrow or fall back
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          rethrow;
        }
      }
    }

    final newUser = AppUser(
      uid: uid,
      fullName: fullName.trim(),
      email: cleanEmail,
      role: role,
      profilePictureUrl: profilePictureUrl,
      playerLevel: role == UserRole.player ? PlayerLevel.notEvaluated : PlayerLevel.notEvaluated,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _mockUsers[cleanEmail] = newUser;
    _currentMockUser = newUser;
    return newUser;
  }

  /// Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (_firebaseAuth != null) {
      try {
        await _firebaseAuth!.sendPasswordResetEmail(email: cleanEmail);
        return;
      } catch (e) {
        debugPrint('Firebase reset password error: $e');
      }
    }
  }

  /// Update Profile
  Future<AppUser> updateProfile({
    String? fullName,
    String? profilePictureUrl,
    String? bio,
    String? specialization,
    PlayerLevel? playerLevel,
  }) async {
    if (_currentMockUser == null) {
      throw Exception('No authenticated user to update');
    }

    final updated = _currentMockUser!.copyWith(
      fullName: fullName,
      profilePictureUrl: profilePictureUrl,
      bio: bio,
      specialization: specialization,
      playerLevel: playerLevel,
      updatedAt: DateTime.now(),
    );

    _mockUsers[updated.email.toLowerCase()] = updated;
    _currentMockUser = updated;
    return updated;
  }

  /// Sign Out
  Future<void> signOut() async {
    if (_firebaseAuth != null) {
      try {
        await _firebaseAuth!.signOut();
      } catch (e) {
        debugPrint('Firebase sign out error: $e');
      }
    }
    _currentMockUser = null;
  }

  /// Helper to get user by email (for invitations)
  AppUser? getUserByEmail(String email) {
    return _mockUsers[email.trim().toLowerCase()];
  }
}
