import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_color.dart';

class AuthHeader extends StatelessWidget {
  final Widget child;
  final String subText;
  const AuthHeader({super.key, required this.child, required this.subText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        const SizedBox(height: 48),

        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: Image.asset('assets/images/logo_l.png', fit: BoxFit.contain),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Expense',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Tracker',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            subText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),

      SafeArea(child: child)
      ],
    );
  }
}
