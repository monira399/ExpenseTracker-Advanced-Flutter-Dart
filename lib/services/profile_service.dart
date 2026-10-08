import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadProfilePicture({
    required String userId,
    required File image,
  }) async {
    final ref = _storage
        .ref()
        .child('profile_images')
        .child(userId)
        .child('profile.jpg');

    await ref.putFile(image);

    final downloadUrl = await ref.getDownloadURL();

    await _firestore.collection('users').doc(userId).update({
      'profileImage': downloadUrl,
    });

    return downloadUrl;
  }
}