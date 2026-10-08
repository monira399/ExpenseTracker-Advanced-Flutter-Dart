import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:expense_tracker/provider/category_provider.dart';
import 'package:expense_tracker/provider/profile_provider.dart';
import 'package:expense_tracker/provider/transaction_provider.dart';
import 'package:expense_tracker/screens/splashscreen.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (_) => AuthProvider()),
       ChangeNotifierProvider(create: (_) => CategoryProvider()),
       ChangeNotifierProvider(create: (_) => TransactionProvider()),
       ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,
            textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      
              titleLarge: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
              ),
      
            titleMedium: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
      
            bodyMedium: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
      
              bodySmall: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0 ,
          )
        ),
        home: SplashScreen(),
      ),
    );
  }
}
