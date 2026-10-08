import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashHeader extends StatelessWidget {
  const SplashHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Image.asset('assets/images/logo_l.png', fit: BoxFit.contain),
          ),
          Text(
            'Expense',
            style: GoogleFonts.poppins(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Tracker',
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 2, width: 40, color: AppColors.primary,),
              SizedBox(width: 8),
              CircleAvatar(radius: 3, backgroundColor: AppColors.primary),
              SizedBox(width: 8),
              Container(height: 2, width: 40, color: Colors.green),
            ],
          ),

          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Track your income, manage expenses and save more',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 50),

          Image.asset('assets/images/chart_logo.png', width: 350, height: 200,),
        ],

    );
  }
}
