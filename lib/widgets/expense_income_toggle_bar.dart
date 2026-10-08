import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseIncomeToggleBar extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const ExpenseIncomeToggleBar({super.key, required this.onChanged});

  @override
  State<ExpenseIncomeToggleBar> createState() => _ExpenseIncomeToggleBarState();
}

class _ExpenseIncomeToggleBarState extends State<ExpenseIncomeToggleBar> {
  int isSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 52,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  isSelected =0;
                });
                widget.onChanged(true);
              },
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected == 0 ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(16),

                ),
                child: Text('Income', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: isSelected == 0 ? AppColors.white : Colors.black87,) ),

              ),
            ),

            SizedBox(width: 2,),
            InkWell(
              borderRadius: BorderRadius.circular(16) ,
              onTap: (){
                setState(() {
                  isSelected =1;
                });
                widget.onChanged(false);
              },
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: isSelected == 1 ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Text('Expense',style: Theme.of(context).textTheme.titleMedium?.copyWith(color: isSelected == 1 ? AppColors.white : Colors.black87,) ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
