import 'package:expense_tracker_advanced/features/auth/auth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  })  {
    return _runWithLoading(() async {
      try {
        await _authService.signUp(
            name: name,
            email: email,
            password: password,
        );
    } on FirebaseAuthException catch (e) {
        throw AuthException(
          _getSignUpErrorMessage(e.code),
        );
      }
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) {
    return _runWithLoading(() async {
      try {
        await _authService.login(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        throw AuthException(
          _getLoginErrorMessage(e.code),
        );
      }
    });
  }

  Future<void> logOut() async {
    return _runWithLoading(
        () => _authService.logOut(),
    );
  }

  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  Future<void> resetPassword(String email) {
    return _runWithLoading(() async {
      try {
        await _authService.resetPassword(email);
      } on FirebaseAuthException catch (e) {
        throw AuthException(
          _getResetPasswordErrorMessage(e.code),
        );
      }
    }
    );
  }

  String _getSignUpErrorMessage(String code) => switch (code) {
    'email-already-in-use' => 'Email already exists',
    'weak-password' => 'Password is too weak',
    'invalid-email' => 'Invalid email',
    'network-request-failed' => 'Check your internet connection',
    _ => 'Something went wrong',
  };

  String _getLoginErrorMessage(String code) => switch (code) {
    'invalid-credential' => 'Email or password is incorrect',
    'invalid-email' => 'Please enter a valid email',
    'user-disabled' => 'This account has been disabled',
    'network-request-failed' => 'Check your internet connection',
    'too-many-requests' => 'Too many attempts. Please try again later',
    _ => 'Login failed, Please try again',
  };

  String _getResetPasswordErrorMessage(String code) => switch (code) {
    'invalid-email' => 'Please enter a valid email address',

    'user-not-found' => 'No account found with this email',

    'network-request-failed' => 'Check your internet connection',

    _ => 'Unable to send password reset email. Please try again',
  };

  Future<void> _runWithLoading (
      Future<void> Function() action
      ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await action();
    } finally {
      _isLoading = false ;
      notifyListeners();
    }
  }
}


