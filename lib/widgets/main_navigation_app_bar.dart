import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';

class MainNavigationAppBar extends StatelessWidget {
final int currentIndex;
final Function(int) onTap;

  const MainNavigationAppBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10,
      color: AppColors.white,
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height:70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           _buildNavItem(
               icon: Icons.home_outlined,
               label: 'Home',
               index: 0) ,
            _buildNavItem(
               icon: Icons.receipt_long_rounded,
               label: 'Transaction',
               index: 1),

            const SizedBox(width: 50),

            _buildNavItem(
               icon: Icons.bar_chart_rounded,
               label: 'Report',
               index: 2),
            _buildNavItem(
               icon: Icons.person_outline_rounded,
               label: 'Profile',
               index: 3)
          ],
        ),
      ),


    ) ;


  }
 Widget _buildNavItem({
  required IconData icon,
  required String label,
  required int index,


}) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
          SizedBox(height:4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          )
        ],
      ),),

    );
 }


}
