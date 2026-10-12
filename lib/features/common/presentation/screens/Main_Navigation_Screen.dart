
import 'package:expense_tracker_advanced/screens/profile_screen.dart';
import 'package:expense_tracker_advanced/screens/report_screen.dart';
import 'package:expense_tracker_advanced/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../provider/transaction_provider.dart';
import '../utils/app_color.dart';
import '../widgets/main_navigation_app_bar.dart';
import 'add_transaction_screen.dart';
import 'dashboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  static const String name  = '/main-nav';

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_currentIndex) {
      0 => const DashboardScreen(),
      1 => const TransactionScreen(),
      2 => const ReportScreen(),
      _ => const ProfileScreen(),
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

          if (transaction != null) {

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
