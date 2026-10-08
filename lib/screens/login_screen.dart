import 'dart:math';

import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:expense_tracker/screens/Main_Navigation_Screen.dart';
import 'package:expense_tracker/screens/forgot_password_screen.dart';
import 'package:expense_tracker/screens/sign_up-screen.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:expense_tracker/utils/app_snackbar.dart';
import 'package:expense_tracker/widgets/auth_background.dart';
import 'package:expense_tracker/widgets/auth_header.dart';
import 'package:expense_tracker/widgets/auth_title.dart';
import 'package:expense_tracker/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/alternative_login_method.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                    SizedBox(height: 12),
                    AuthTitle(
                        title: 'Welcome Back',
                        subTitle: 'Login to continue'),

                    SizedBox(height: 25),

                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
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
                      hintText: 'Enter your password',
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

                    SizedBox(height: 5,),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                      }, child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),),
                    ),

                  SizedBox(height: 10),

                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return CustomButton(text: 'Login',
                          isLoading: authProvider.isLoading,
                          onPressed: _onTapLoginButton
                      );
                    }
                  ),

                    SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height: 2, width: 80, color: Colors.grey.shade500),

                          SizedBox(width: 10),

                          Text(
                            'or continue with',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500
                            ),
                          ),

                          SizedBox(width: 10),

                          Container(height: 2, width: 80, color: Colors.grey.shade500),
                        ],
                      ),


                    SizedBox(height: 16),

                    AlterNativeLoginMethod(),

                    SizedBox(height: 20),

                    Center(
                      child: RichText(text: TextSpan(
                          text: 'Don\'t have an account?  ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                    color: AppColors.primary
                                ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                              }
                            )
                          ]
                      )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapLoginButton () {
    if(_formKey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      );

      if(!mounted) return;

      showAppSnackBar(
          context: context,
          message: 'Login successful'
      );

      await Future.delayed(Duration(seconds: 1));

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainNavigationScreen()), (predicate) => false);
    } catch (e) {
      if(!mounted) return;

      showAppSnackBar(context: context, message: e.toString());
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}


