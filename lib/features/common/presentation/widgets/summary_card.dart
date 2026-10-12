import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final String? percentage;
  final String? subTitle;

  final IconData? icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  final Color amountColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    this.percentage,
    this.subTitle,
    this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.amountColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Icon
          CircleAvatar(
            radius: 25,
            backgroundColor: iconBackgroundColor,
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),

          const SizedBox(height: 20),

          /// Text
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),


          const SizedBox(height: 5),

          Text(
            '৳ ${amount.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),


          const SizedBox(height: 5),

          Row(
            children: [
              Text(
                percentage ?? '',
                style: GoogleFonts.poppins(
                  color: iconColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(width: 3),

              Center(
                child: Text(
                  subTitle ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 12
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}