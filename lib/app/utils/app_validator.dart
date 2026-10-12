class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    return null;
  }

  static String? name (String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  static String? signUpPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }

    return null;
  }

  static String? confirmPassword(
      String? value,
      String? password) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
  if(value != password) {
  return 'Confirm password does\'nt match';
  }
  return null;
  }
}