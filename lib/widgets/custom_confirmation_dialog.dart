import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;
  final Color? confirmTextBackgroundColor;
  final Color? confirmTextColor;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    this.confirmTextBackgroundColor,
    this.confirmTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,

      title: Text(title, style: Theme.of(context).textTheme.titleLarge,),

      content: Text(message, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600) ),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Cancel', style: GoogleFonts.poppins(
              backgroundColor: AppColors.background,color: Colors.black,
              fontWeight: FontWeight.w600
            ),)),

            ElevatedButton(onPressed: (){
              Navigator.pop(context);
              onConfirm();
            }, style: ElevatedButton.styleFrom(
              backgroundColor: confirmTextBackgroundColor ?? AppColors.primary,
              foregroundColor: confirmTextColor ?? Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12
            )
            ),

                child: Text(confirmText,style: Theme.of(context).textTheme.bodyMedium?.copyWith(color:confirmTextColor ?? Colors.white,
                fontWeight: FontWeight.w600)  )),
          ],
        )
      ],
    );
  }
}
