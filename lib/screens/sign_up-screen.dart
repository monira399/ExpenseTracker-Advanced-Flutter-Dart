import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:expense_tracker/utils/app_snackbar.dart';
import 'package:expense_tracker/widgets/auth_background.dart';
import 'package:expense_tracker/widgets/auth_header.dart';
import 'package:expense_tracker/widgets/auth_title.dart';
import 'package:expense_tracker/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
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
                      title: 'Welcome Back',
                      subTitle: 'Login to continue',
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      controller: _fullNameController,
                      hintText: 'Full Name',
                      prefixIcon: Icons.email,
                      height: 55,
                      width: double.infinity,
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter name';
                          }
                          return null;
                        }
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                      height: 55,
                      width: double.infinity,
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter valid email';
                          }
                          return null;
                        }
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility,
                      height: 55,
                      width: double.infinity,
                      validator: (String? value){
                        if(value == null || value.trim().isEmpty){
                          return 'Please enter your password';
                        }
                        if(value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if(!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain a uppercase letter';
                        }
                        if(!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password must contain a lowercase letter';
                        }
                        if(!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Password must contain a number';
                        }
                        return null;
                      }
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility,
                      height: 55,
                      width: double.infinity,
                      validator: (String? value) {
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter confirm password';
                        }
                        if(value! != _passwordController.text.trim()) {
                          return 'Confirm password does\'nt match';
                        }
                        return null;
                      }
                    ),

                    SizedBox(height: 20),

                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return CustomButton(text: 'Sign Up',
                            isLoading: authProvider.isLoading,
                            onPressed: _onTapSignUpButton
                        );
                      }
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
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                },
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
        password: _passwordController.text.trim(),
        name: _fullNameController.text.trim(),
      );

      if (!mounted) return;

      showAppSnackBar(context: context, message: 'Account create successfully');

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      if (!mounted) return;

      showAppSnackBar(context: context, message: e.toString());
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
