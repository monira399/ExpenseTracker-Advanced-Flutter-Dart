import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:expense_tracker/utils/app_snackbar.dart';
import 'package:expense_tracker/widgets/auth_background.dart';
import 'package:expense_tracker/widgets/auth_title.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/forgot_password_card.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      body: AuthBackground(
          child:SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                   mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logo_l.png', height: 80, width: 80, fit: BoxFit.contain,),
                      const SizedBox(height: 30),
                      Center(
                        child: AuthTitle(
                            title: 'Forgot Password',
                            subTitle: 'Enter your email to reset your password.'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: ForgotPasswordCard(
                            emailAddressController: _emailController, onTapResetPassword: _onTapForgotButton),
                      ),

                      authProvider.isLoading
                          ? Center(child:
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2,),
                      ),)
                      : Center(
                        child: RichText(text: TextSpan(
                            text: 'Don\'t receive the email?  ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                  text: 'Resend Link',
                                  style: TextStyle(
                                      color: AppColors.primary
                                  ),
                                  recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                     _onTapForgotButton();
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
          ) ),
    );
  }

  void _onTapForgotButton(){
    if(_formKey.currentState!.validate()) {
       _resetPassword();
    }
  }

  Future<void> _resetPassword() async{

    try{
    await context.read<AuthProvider>().resetPassword(_emailController.text.trim());

    if(!mounted) return;

    showAppSnackBar(context: context, message: 'Password reset email sent successfully');

    Navigator.pop(context);
    } catch (e) {

      if(!mounted) return;

      showAppSnackBar(context: context, message: 'Something went wrong');
    }
  }
}


