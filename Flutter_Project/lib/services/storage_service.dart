import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage? storage;

  StorageService({this.storage});

  /// Uploads user profile picture and returns download URL
  Future<String?> uploadProfilePicture(String userId, XFile file) async {
    try {
      final s = storage;
      if (s != null) {
        final ref = s.ref().child('users').child(userId).child('profile.jpg');
        final metadata = SettableMetadata(contentType: 'image/jpeg');

        if (kIsWeb) {
          final bytes = await file.readAsBytes();
          final uploadTask = await ref.putData(bytes, metadata);
          return await uploadTask.ref.getDownloadURL();
        } else {
          final uploadTask = await ref.putFile(File(file.path), metadata);
          return await uploadTask.ref.getDownloadURL();
        }
      }
    } catch (e) {
      debugPrint('Firebase Storage error: $e. Falling back to local image path or avatar.');
    }

    // Fallback: If Firebase Storage is not yet configured or offline, return path
    return file.path;
  }
}
