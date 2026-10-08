import 'package:expense_tracker/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_color.dart';
import 'custom_button.dart';
import 'custom_textfield.dart';

class ForgotPasswordCard extends StatelessWidget {
  final VoidCallback onTapResetPassword;
  final TextEditingController emailAddressController;

  const ForgotPasswordCard({
    super.key,
    required this.emailAddressController,
    required this.onTapResetPassword,
  }) ;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: emailAddressController,
              hintText: 'Email Address',
              prefixIcon: Icons.email_outlined,
              height: 55,
              width: double.infinity,
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: 'Send Reset Link',
              onPressed: onTapResetPassword,
              icon: Icons.near_me_rounded,
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade400,
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  'OR',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (predicate)=>false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  side: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 24,
                  color: AppColors.primary,
                ),
                label: Text(
                  'Back to Login',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}