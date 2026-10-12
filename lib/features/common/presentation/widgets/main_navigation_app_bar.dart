import 'package:flutter/material.dart';

import '../utils/app_color.dart';

typedef NavItemData = ({
  IconData icon,
  String label,
  int index
});

class MainNavigationAppBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainNavigationAppBar(
      {super.key, required this.currentIndex, required this.onTap});

  static const List<NavItemData> _navItems = [
    (
    icon: Icons.home_outlined,
    label: 'Home',
    index: 0,
    ),

    (
    icon: Icons.receipt_long_outlined,
    label: 'Transaction',
    index: 1,
    ),

    (
    icon: Icons.bar_chart_outlined,
    label: 'Report',
    index: 2,
    ),

    (
    icon: Icons.person_outline_rounded,
    label: 'Profile',
    index: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10,
      color: AppColors.white,
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ..._buildNavItems(_navItems.take(2)),
            const SizedBox(width: 50,),
            ..._buildNavItems(_navItems.skip(2)),

          ],
        ),
      ),


    );
  }

  List<Widget> _buildNavItems(Iterable<NavItemData> items,) {
    return items.map((item) {
      return _buildNavItem(
        icon: item.icon,
        label: item.label,
        index: item.index,
      );
    }).toList();
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    final color = isSelected
        ? AppColors.primary
        : Colors.grey;

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
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
