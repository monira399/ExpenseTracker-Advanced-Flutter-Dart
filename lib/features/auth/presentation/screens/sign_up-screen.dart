
import 'package:expense_tracker_advanced/features/auth/auth_exception.dart';
import 'package:expense_tracker_advanced/utils/app_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utils/app_color.dart';
import '../utils/app_snackbar.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_title.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name  = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TapGestureRecognizer _signUpTapRecognizer;
  final _confirmPasswordKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();

    _signUpTapRecognizer = TapGestureRecognizer()
      ..onTap = _onTapLogin;
  }

  void _onTapLogin() {
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
                    SizedBox(height: 16),
                    AuthTitle(
                      title: 'Create Account',
                      subTitle: 'Sign up to manage your finances',
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      controller: _fullNameController,
                      hintText: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      height: 55,
                      width: double.infinity,
                       validator: Validators.name,
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                      height: 55,
                      width: double.infinity,
                        validator: Validators.email
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      controller: _passwordController,
                      onChanged: (_) {
                       if( _confirmPasswordController.text.isNotEmpty) {
                         _confirmPasswordKey.currentState?.validate();
                       }
                      },
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility,
                      height: 55,
                      width: double.infinity,
                      validator: Validators.signUpPassword
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      fieldKey: _confirmPasswordKey,
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility,
                      height: 55,
                      width: double.infinity,
                      validator: (value) {
                        return Validators.confirmPassword(
                            value,
                            _passwordController.text);
                      }
                    ),

                    SizedBox(height: 20),


                         CustomButton(text: 'Sign Up',
                            isLoading: isLoading,
                            onPressed: _onTapSignUpButton
                         ),


                    SizedBox(height: 25),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account?  ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(color: AppColors.primary),
                              recognizer: _signUpTapRecognizer
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

  void _onTapSignUpButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _fullNameController.text.trim(),
      );

      if (!mounted) return;

      showAppSnackBar(context: context, message: 'Account created successfully');

   Navigator.pushReplacementNamed(context, LoginScreen.name);
    } on AuthException catch (e) {
      if(!mounted) return;

      showAppSnackBar(context: context, message: e.message);
    }
      catch (e) {
      if (!mounted) return;

      showAppSnackBar(context: context, message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _signUpTapRecognizer.dispose();
    super.dispose();
  }
}
