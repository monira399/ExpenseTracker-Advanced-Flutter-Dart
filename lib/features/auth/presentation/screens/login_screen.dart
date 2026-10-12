import 'package:expense_tracker_advanced/screens/sign_up-screen.dart';
import 'package:expense_tracker_advanced/utils/app_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/auth_exception.dart';
import '../provider/auth_provider.dart';
import '../utils/app_color.dart';
import '../utils/app_snackbar.dart';
import '../widgets/alternative_login_method.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_title.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'Main_Navigation_Screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String name = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TapGestureRecognizer _loginTapRecognizer;

  @override
  void initState() {
    super.initState();
    _loginTapRecognizer = TapGestureRecognizer()..onTap = _onTapSignUp;
  }

  void _onTapSignUp() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthProvider, bool>(
      (provider) => provider.isLoading,
    );
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: AuthHeader(
            subText: 'Track your income, manage expenses and save more',
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    AuthTitle(
                      title: 'Welcome Back',
                      subTitle: 'Login to continue',
                    ),

                    SizedBox(height: 25),

                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      height: 55,
                      width: double.infinity,
                      validator: Validators.email,
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility,
                      height: 55,
                      width: double.infinity,
                      validator: Validators.loginPassword,
                    ),

                    SizedBox(height: 5),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            ForgotPasswordScreen.name,
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    CustomButton(
                      text: 'Login',
                      isLoading: isLoading,
                      onPressed: _onTapLoginButton,
                    ),

                    SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 2,
                          width: 80,
                          color: Colors.grey.shade500,
                        ),

                        SizedBox(width: 10),

                        Text(
                          'or continue with',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),

                        SizedBox(width: 10),

                        Container(
                          height: 2,
                          width: 80,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    AlterNativeLoginMethod(),

                    SizedBox(height: 20),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?  ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(color: AppColors.primary),
                              recognizer: _loginTapRecognizer,
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

  void _onTapLoginButton() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      showAppSnackBar(context: context, message: 'Login successful');

      Navigator.pushNamedAndRemoveUntil(
        context,
        MainNavigationScreen.name,
        (predicate) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      showAppSnackBar(context: context, message: e.message);
    } catch (e) {
      if (!mounted) return;

      showAppSnackBar(
        context: context,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginTapRecognizer.dispose();
    super.dispose();
  }
}
