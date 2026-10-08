import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/provider/category_provider.dart';
import 'package:expense_tracker/screens/transaction_details_screen.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/transaction_provider.dart';
import '../screens/add_transaction_screen.dart';
import '../utils/app_snackbar.dart';
import 'custom_confirmation_dialog.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({
    super.key,
    required this.transaction
  });

  @override
  Widget build(BuildContext context) {
    final category = context
        .read<CategoryProvider>()
        .getCategoryById(transaction.categoryId);

    return ListTile(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailsScreen(transaction: transaction)));
      },
      leading: CircleAvatar(
        radius: 20,
        backgroundColor:
        category?.color.withOpacity(0.15) ??
            AppColors.secondary.withOpacity(0.15),
        child: Icon(
          category?.icon ?? Icons.category_outlined,
          color: category?.color ?? AppColors.secondary,
          size: 16,
        ),
      ),

      title: Text(
        transaction.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),

      subtitle: Text(
        '${transaction.date.day}-${transaction.date.month}-${transaction.date.year}',
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${transaction.isIncome ? '+' : '-'} ৳ ${transaction.amount}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: transaction.isIncome
                  ? Colors.green
                  : Colors.red,
            ),
          ),

          const SizedBox(width: 15),

          PopupMenuButton<String>(
            color: AppColors.background,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_vert),

            onSelected: (value) async {

              // ============ EDIT ============
              if (value == 'edit') {

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(
                      transaction: transaction,
                    ),
                  ),
                );

                if (result == true && context.mounted) {
                  showAppSnackBar(
                    context: context,
                    message: 'Transaction updated successfully',
                  );
                }
              }

              // ============ DELETE ============
              if (value == 'delete') {

                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomConfirmationDialog(
                      title: 'Delete Transaction',
                      message: 'Do you want to delete ${transaction.title}?',
                      confirmText: 'Delete',
                      confirmTextBackgroundColor: Colors.red.withOpacity(0.15),
                      confirmTextColor: Colors.red,
                      onConfirm: () async {

                        await context
                            .read<TransactionProvider>()
                            .deleteTransaction(transaction.id);
                      },
                    );
                  },
                );
              }
            },

            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),

              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          )
        ],
      ),
    );
  }
}