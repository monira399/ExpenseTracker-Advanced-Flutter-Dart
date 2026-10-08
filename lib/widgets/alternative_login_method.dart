import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlterNativeLoginMethod extends StatelessWidget {
  const AlterNativeLoginMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
          ),
          label: Text('Google', style: Theme.of(context).textTheme.bodyMedium),
          icon: Image.asset(
            'assets/icons/google.png',
            height: 30,
            width: 20,
          ),

        ),

        SizedBox(width: 12),

        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
          ),
          label: Text('Facebook', style: Theme.of(context).textTheme.bodyMedium,),
          icon: Image.asset(
            'assets/icons/facebook.png',
            height: 30,
            width: 20,
          ),
        ),

        SizedBox(width: 30),

      ],
    );
  }
}