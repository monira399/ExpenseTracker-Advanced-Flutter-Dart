import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/provider/transaction_provider.dart';
import 'package:expense_tracker/screens/profile_screen.dart';
import 'package:expense_tracker/screens/report_screen.dart';
import 'package:expense_tracker/screens/transaction_screen.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:expense_tracker/widgets/main_navigation_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_transaction_screen.dart';
import 'dashboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_currentIndex) {
      0 =>  DashboardScreen(),
      1 => TransactionScreen(),
      2 => ReportScreen(),
      _ => ProfileScreen(),
      },

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final transaction = await showModalBottomSheet<TransactionModel>(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => AddTransactionScreen(),
          );

          print(transaction);

          if (transaction != null) {
            print("Received");

            await context
                .read<TransactionProvider>()
                .addTransaction(transaction);
          }
        },
        child: Icon(Icons.add, color: AppColors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: MainNavigationAppBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
