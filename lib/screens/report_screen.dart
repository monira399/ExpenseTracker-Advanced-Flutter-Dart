import 'package:expense_tracker/provider/transaction_provider.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:expense_tracker/widgets/monthly_report_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../provider/category_provider.dart';
import '../widgets/report_summary_card.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final report = provider.getMonthlyReport();
    final topCategories = provider.getTopSpendingCategories();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Report Screen',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(DateFormat('MMM yyyy').format(DateTime.now()), style: Theme.of(context).textTheme.titleMedium,),
              SizedBox(height: 20,),

              Column(
                children: [
                  //========Total Balance======//
                  ReportSummaryCard(
                    title: 'Total Balance',
                    amount: provider.currentBalance,
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.primary,
                    iconBackgroundColor: AppColors.primary.withOpacity(0.15),
                    backgroundColor:  AppColors.primary.withOpacity(0.1),
                  ),

                  SizedBox(height: 10,),

                  //Total Income
                  Row(
                    children: [
                      Expanded(
                        child: ReportSummaryCard(
                          title: 'Total Income',
                          amount: provider.totalIncome,
                          icon: Icons.arrow_upward,
                          iconColor: Colors.green,
                          iconBackgroundColor: AppColors.primary.withOpacity(0.15),
                          backgroundColor:  AppColors.primary.withOpacity(0.08),
                        ),
                      ),

                      SizedBox(width: 10,),

                      //Total Expense
                      Expanded(
                        child: ReportSummaryCard(
                          title: 'Total Expense',
                          amount: provider.totalExpense,
                          icon: Icons.arrow_downward,
                          iconColor: Colors.red,
                          iconBackgroundColor: AppColors.error.withOpacity(0.15),
                          backgroundColor: AppColors.error.withOpacity(0.08),
                        ),
                      ),
                    ],
                  ),
                ],

              ),
              SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Monthly Report ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              
              const SizedBox(height: 20),

              MonthlyReportChart(report: report),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Spending Categories',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              const SizedBox(height: 20),

              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: topCategories.length,
                  itemBuilder: (context, index) {
                    final categoryId = topCategories.keys.elementAt(index);
                    final amount = topCategories[categoryId]!;

                    final category = context
                        .read<CategoryProvider>()
                        .getCategoryById(categoryId);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: category?.color.withOpacity(0.15),
                        child:Icon(category?.icon ?? Icons.category_outlined,
                        color: category?.color,),
                      ),
                      title: Text(category?.name ?? 'Unknown',),
                      trailing: Text('৳ ${amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                      ),),
                    );
                  })


            ],
          ),
        ),
      ),
    );
  }
}
