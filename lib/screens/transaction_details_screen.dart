import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/provider/category_provider.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final category = context
        .read<CategoryProvider>()
        .getCategoryById(transaction.categoryId);

    final bool isIncome = transaction.isIncome;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= AMOUNT =================

            Center(
              child: Column(
                children: [
                  Text(
                    isIncome ? 'Income' : 'Expense',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${isIncome ? '+' : '-'} ৳ ${transaction.amount}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isIncome
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ================= TITLE =================

            Text(
              'Title',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              transaction.title,
                style: Theme.of(context).textTheme.bodyMedium
            ),

            const SizedBox(height: 24),

            // ================= DATE =================

            Text(
              'Date',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '${transaction.date.day}-'
                  '${transaction.date.month}-'
                  '${transaction.date.year}',
                style: Theme.of(context).textTheme.titleMedium
            ),

            const SizedBox(height: 24),

            // ================= CATEGORY =================

            Text(
              'Category',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: category?.color.withOpacity(0.15) ??
                      AppColors.secondary.withOpacity(0.15),
                  child: Icon(
                    category?.icon ?? Icons.category_outlined,
                    color: category?.color ?? AppColors.secondary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                Text(
                  category?.name ?? 'Unknown Category',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================= NOTE =================

            Text(
              'Note',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                transaction.note.trim().isNotEmpty == true
                    ? transaction.note!.trim()
                    : 'No note added',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}