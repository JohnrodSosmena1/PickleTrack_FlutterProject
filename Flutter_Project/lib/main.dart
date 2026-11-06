import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthService authService = AuthService();
  FirestoreService firestoreService = FirestoreService();

  try {
    // Attempt Firebase initialization
    await Firebase.initializeApp();
    debugPrint('PickleTrack: Firebase Core initialized successfully.');

    final firebaseAuth = FirebaseAuth.instance;
    final cloudFirestore = FirebaseFirestore.instance;

    authService.setFirebaseAuth(firebaseAuth);
    firestoreService.setFirestore(cloudFirestore);
  } catch (e) {
    debugPrint(
      '------------------------------------------------------------------------\n'
      'PickleTrack Notice:\n'
      'Firebase initialization skipped or pending FlutterFire configuration: $e\n'
      'The application is running with full local state & pre-seeded demo data.\n'
      'To link your live Firebase project, run:\n'
      '  flutterfire configure\n'
      '------------------------------------------------------------------------',
    );
  }

  runApp(
    PickleTrackApp(
      authService: authService,
      firestoreService: firestoreService,
    ),
  );
}
