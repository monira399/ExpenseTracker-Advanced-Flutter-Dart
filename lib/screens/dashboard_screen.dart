
import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:expense_tracker/provider/category_provider.dart';
import 'package:expense_tracker/screens/transaction_screen.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/transaction_provider.dart';
import '../widgets/current_balanced_card.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.watch<TransactionProvider>().getTransaction();
      context.read<CategoryProvider>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final recentTransactions = context.watch<TransactionProvider>().recentTransactions;

    final user = context.read<AuthProvider>().getCurrentUser();


    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('👋', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    'Good Morning',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              Text(user?.displayName ?? 'user', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(DateFormat('EEE, dd MMM yyyy').format(DateTime.now()), style: Theme.of(context).textTheme.bodyMedium,),

              SizedBox(height: 15),

              CurrentBalancedCard(
                height: 120,
                width: double.infinity,
                title: 'Current Balance',
                amount: transactionProvider.currentBalance,
                date:DateFormat('EEE, dd MMM yyyy').format(DateTime.now()),
                fontSize: 20,
                fontColor: Colors.white,
                icon: Icons.account_balance_wallet_outlined,
                iconColor: AppColors.secondary,
                iconSize: 60,
                color: AppColors.primary,
              ),

              SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Total Income',
                      amount: transactionProvider.totalIncome,
                      percentage: '8.3%',
                      subTitle: 'from last month',
                      icon: Icons.arrow_upward,
                      iconColor: Colors.green,
                      iconBackgroundColor: AppColors.secondary.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: SummaryCard(
                      title: 'Total Expense',
                      amount: transactionProvider.totalExpense,
                      percentage: '8.3%',
                      subTitle: 'from last month',
                      icon: Icons.arrow_downward,
                      iconColor: Colors.red,
                      iconBackgroundColor: const Color(0xffFDEBEC),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),

              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Income',
                      amount: transactionProvider.thisMonthIncome,
                      percentage: '',
                      subTitle: 'In this month',
                      icon: Icons.calendar_month_outlined,
                      iconColor: Colors.green,
                      iconBackgroundColor: AppColors.secondary.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: SummaryCard(
                      title: 'Expense',
                      amount: transactionProvider.thisMonthExpense,
                      percentage: '',
                      subTitle: 'In this month',
                      icon: Icons.calendar_month_outlined,
                      iconColor: Colors.red,
                      iconBackgroundColor: const Color(0xffFDEBEC),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionScreen()));
                      }, child:Text('View All') ),
                      SizedBox(width: 4,),
                      Icon(Icons.arrow_forward, size: 20, color: Colors.grey,),

                    ],
                  ),
                ],
              ),

              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = recentTransactions[index];

                  final category = context.read<CategoryProvider>().getCategoryById(transaction.categoryId);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: category?.color.withOpacity(0.15) ?? AppColors.secondary.withOpacity(0.15),
                      child: Icon(
                        category?.icon ?? Icons.category_outlined,
                        color: category?.color ?? AppColors.secondary,
                      ),
                    ),
                    title: Text(transaction.title),
                    subtitle: Text(category?.name ?? 'Unknown'),

                    trailing: Text(
                      transaction.isIncome
                          ? "+ ${transaction.amount}"
                          : "- ${transaction.amount}",
                      style: TextStyle(
                        color: transaction.isIncome ? Colors.green : Colors.red,
                        fontSize: 15
                      ),
                    ),
                  );
                },

                separatorBuilder: (context, index) {
                  return Divider(
                      indent: 68,
                      endIndent: 16,
                      height: 16,
                      thickness: 1,
                  color: Colors.green.withOpacity(0.15),);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
