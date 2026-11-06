import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../core/constants/app_constants.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._authService) {
    _init();
  }

  void _init() {
    _currentUser = _authService.currentUser;
    _authService.authStateChanges().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isCoach => _currentUser?.role == UserRole.coach;
  bool get isPlayer => _currentUser?.role == UserRole.player;
  UserRole get role => _currentUser?.role ?? UserRole.player;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    UserRole role = UserRole.player,
    String? profilePictureUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.registerWithEmailAndPassword(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        profilePictureUrl: profilePictureUrl,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? profilePictureUrl,
    String? bio,
    String? specialization,
    PlayerLevel? playerLevel,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.updateProfile(
        fullName: fullName,
        profilePictureUrl: profilePictureUrl,
        bio: bio,
        specialization: specialization,
        playerLevel: playerLevel,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Development & Testing Quick Logins
  Future<void> loginAsDemoJuan() async {
    await signIn('juan@email.com', 'password123');
  }

  Future<void> loginAsDemoCoach() async {
    await signIn('coach.mark@pickletrack.com', 'password123');
  }

  Future<void> loginAsDemoPlayer() async {
    await signIn('john@pickletrack.com', 'password123');
  }
}
