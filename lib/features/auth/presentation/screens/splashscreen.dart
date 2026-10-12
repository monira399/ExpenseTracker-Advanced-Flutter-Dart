
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/splash_header.dart';
import 'Main_Navigation_Screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name  = '/splash';

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
     await Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        final user = context.read<AuthProvider>().getCurrentUser();

        if (user != null) {
        Navigator.pushReplacementNamed(context, MainNavigationScreen.name,
        );

        } else {
          Navigator.pushReplacementNamed(context, LoginScreen.name,
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
