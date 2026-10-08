import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          //BackGround
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.background,
          ),

          //Bottom Wave
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/wave.png',
                height: 160,
                fit: BoxFit.fill,
              ),
            ),
          ),

          //Any Content
          SafeArea(child: child),
        ],

    );
  }
}
