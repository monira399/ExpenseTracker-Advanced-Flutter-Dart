import 'package:expense_tracker/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signUp(
          email: email,
          password: password,
          name: name);
    } on FirebaseAuthException catch (e) {
      print('Code: ${e.code}');
      print('Message: ${e.message}');
      throw _getSignUpErrorMessage(e.code);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
        required email,
        required password,
      })  async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.login(
          email: email,
          password: password);
    } on FirebaseAuthException catch (e) {
      print('Code: ${e.code}');
      print('Message: ${e.message}');
      throw _getLoginErrorMessage(e.code);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logOut();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  User? getCurrentUser () {
    return _authService.getCurrentUser();
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.resetPassword(email);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  String _getSignUpErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already exists';

      case 'weak-password':
        return 'Password is too weak';

      case 'invalid-email':
        return 'Invalid email';

      case 'network-request-failed' :
        return 'Check your internet connection';

      default:
        return 'something went wrong';
    }
  }

  String _getLoginErrorMessage(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'Email or password is incorrect';
      case 'invalid-email':
        return 'Please enter a valid email';
      case 'user-disabled' :
        return 'This account has been disabled';
      case 'network-request-failed'  :
        return 'Check your internet connection';
      case 'too-many-request'  :
        return 'Too many attempts. Please try again later';
      default:
        return 'Login failed, Please try again';
    }
  }
}

