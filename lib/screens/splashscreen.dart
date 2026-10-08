import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:expense_tracker/screens/Main_Navigation_Screen.dart';
import 'package:expense_tracker/widgets/auth_background.dart';
import 'package:expense_tracker/widgets/splash_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

    Future<void> _checkUser() async {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        final user = context.read<AuthProvider>().getCurrentUser();

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MainNavigationScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen(),
            ),
          );
        }
      }
      );
    }




  @override
  Widget build(BuildContext context) {
    return const AuthBackground(
        child: Center(
            child: SplashHeader(),
        ),
    );
  }
}
