
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../app/utils/notification_keys.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> initialize() async {
    final before = await _messaging.getNotificationSettings();
    print('BEFORE: ${before.authorizationStatus}');

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('AFTER: ${settings.authorizationStatus}');

    if (settings.authorizationStatus ==
        AuthorizationStatus.denied) {
      return null;
    }

    return _messaging.getToken();
  }

  Future<void> saveTokenForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final token = await initialize();

    if (token == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }

  Stream<String> get tokenRefreshStream {
    return _messaging.onTokenRefresh;
  }


  Future<void> updateTokenForCurrentUser(String token) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }


  void listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received');

      final notification = message.notification;

      if (notification != null) {
        debugPrint('Title: ${notification.title}');
        debugPrint('Body: ${notification.body}');

        debugPrint(
          'Messenger state: ${notificationMessengerKey.currentState}',
        );
        debugPrint('Message data: ${message.data}');

        notificationMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              '${notification.title ?? 'Notification'}: '
                  '${notification.body ?? ''}',
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        debugPrint('Message has no notification payload');
      }
    });
  }
}
