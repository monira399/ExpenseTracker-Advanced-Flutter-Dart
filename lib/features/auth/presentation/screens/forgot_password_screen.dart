import 'package:expense_tracker_advanced/features/auth/auth_exception.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utils/app_color.dart';
import '../utils/app_snackbar.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_title.dart';
import '../widgets/forgot_password_card.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const String name = '/forgot-pass';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TapGestureRecognizer _forgotPasswordTapRecognizer;

  @override
  void initState() {
    super.initState();
    _forgotPasswordTapRecognizer = TapGestureRecognizer()..onTap = _onTapForgotButton;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthProvider, bool>(
      (provider) => provider.isLoading,
    );

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo_l.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: AuthTitle(
                        title: 'Forgot Password',
                        subTitle: 'Enter your email to reset your password.',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: ForgotPasswordCard(
                        emailAddressController: _emailController,
                        onTapResetPassword: _onTapForgotButton,
                        isLoading: isLoading,
                      ),
                    ),

                   if(isLoading)
                       const CircularProgressIndicator()
                        else
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Don\'t receive the email?  ',
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: 'Resend Link',
                                    style: TextStyle(color: AppColors.primary),
                                    recognizer: _forgotPasswordTapRecognizer,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapForgotButton() {
    if (_formKey.currentState!.validate()) {
      _resetPassword();
    }
  }

  Future<void> _resetPassword() async {
    try {
      await context.read<AuthProvider>().resetPassword(
        _emailController.text.trim(),
      );

      if (!mounted) return;

      showAppSnackBar(
        context: context,
        message: 'Password reset email sent successfully',
      );

    } on AuthException catch (e) {
      if (!mounted) return;

      showAppSnackBar(context: context, message: e.message);
    }
    catch (e) {
      if (!mounted) return;

      showAppSnackBar(context: context, message:'Something went wrong. Please try again.',
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _forgotPasswordTapRecognizer.dispose();
    super.dispose();
  }
}
