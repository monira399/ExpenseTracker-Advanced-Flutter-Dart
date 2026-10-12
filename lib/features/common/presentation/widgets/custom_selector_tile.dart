import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomSelectorTile extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final IconData trailingIcon;
  final VoidCallback onTap;

  const CustomSelectorTile({
    super.key,
    required this.title,
    this.leadingIcon,
    required this.trailingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16)
        ),
        child: ListTile(
        title: Text(title),
          leading: Icon(
            leadingIcon ?? Icons.category_outlined,
          ),
        trailing: Icon(trailingIcon),
        onTap: onTap,
      ),
    );
  }
}
