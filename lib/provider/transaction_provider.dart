import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/services/transaction_service.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ============ Get Transaction ============

  Future<void> getTransaction() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _transactionService.getTransaction();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============ Add Transaction ============

  Future<bool> addTransaction(TransactionModel transaction) async {
    try {
      _isLoading = true;
      notifyListeners();

      final id = await _transactionService.addTransaction(transaction);

      final newTransaction = TransactionModel(
        id: id,
        title: transaction.title,
        date: transaction.date,
        amount: transaction.amount,
        isIncome: transaction.isIncome,
        categoryId: transaction.categoryId,
        note: transaction.note,
      );

      _transactions.insert(0, newTransaction);
      await getTransaction();

      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============ Update Transaction ============

  Future<bool> updateTransaction(TransactionModel transaction) async {

    try {
      _isLoading = true;
      notifyListeners();

      await _transactionService.updateTransaction(transaction);

      await getTransaction();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============ Delete Transaction ============

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _transactionService.deleteTransaction(transactionId);

      _transactions.removeWhere(
            (transaction) => transaction.id == transactionId,
      );
      await getTransaction();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ============ Recent Transactions ============

  List<TransactionModel> get recentTransactions {
    return _transactions.take(5).toList();
  }

  // ============ Today Transactions ============

  List<TransactionModel> get todayTransactions {
    final now = DateTime.now();

    return _transactions.where((transaction) {
      return transaction.date.year == now.year &&
          transaction.date.month == now.month &&
          transaction.date.day == now.day;
    }).toList();
  }

  // ============ Yesterday Transactions ============

  List<TransactionModel> get yesterdayTransactions {
    final yesterday = DateTime.now().subtract(
      const Duration(days: 1),
    );

    return _transactions.where((transaction) {
      return transaction.date.year == yesterday.year &&
          transaction.date.month == yesterday.month &&
          transaction.date.day == yesterday.day;
    }).toList();
  }

  // ============ Older Transactions ============

  List<TransactionModel> get olderTransactions {
    final now = DateTime.now();

    return _transactions.where((transaction) {
      final transactionDate = transaction.date;

      final isToday =
          transactionDate.year == now.year &&
              transactionDate.month == now.month &&
              transactionDate.day == now.day;

      final yesterday = now.subtract(
        const Duration(days: 1),
      );

      final isYesterday =
          transactionDate.year == yesterday.year &&
              transactionDate.month == yesterday.month &&
              transactionDate.day == yesterday.day;

      return !isToday && !isYesterday;
    }).toList();
  }

  // ============ Date + Type Filter ============

  List<TransactionModel> getTransactionsByDateAndType(
      String dateType,
      int selected, {
        List<TransactionModel>? searchResult,
      }) {
    List<TransactionModel> result;


    final data = searchResult ?? transactions;

    // Date Filter
    if (dateType == 'today') {
      result = data.where((transaction) {
        return DateUtils.isSameDay(
          transaction.date,
          DateTime.now(),
        );
      }).toList();
    } else if (dateType == 'yesterday') {
      final yesterday = DateTime.now().subtract(
        const Duration(days: 1),
      );

      result = data.where((transaction) {
        return DateUtils.isSameDay(
          transaction.date,
          yesterday,
        );
      }).toList();
    } else {
      result = data.where((transaction) {
        final today = DateTime.now();
        final yesterday = today.subtract(
          const Duration(days: 1),
        );

        return !DateUtils.isSameDay(transaction.date, today) &&
            !DateUtils.isSameDay(transaction.date, yesterday);
      }).toList();
    }

    // All / Income / Expense
    if (selected == 0) {
      return result;
    } else if (selected == 1) {
      return result
          .where((transaction) => transaction.isIncome)
          .toList();
    } else {
      return result
          .where((transaction) => !transaction.isIncome)
          .toList();
    }
  }

  // ============ Total Income ============

  double get totalIncome {
    return _transactions
        .where((transaction) => transaction.isIncome)
        .fold(
      0.0,
          (sum, transaction) => sum + transaction.amount,
    );
  }

  // ============ Total Expense ============

  double get totalExpense {
    return _transactions
        .where((transaction) => !transaction.isIncome)
        .fold(
      0.0,
          (sum, transaction) => sum + transaction.amount,
    );
  }

  // ============ Current Balance ============

  double get currentBalance {
    return totalIncome - totalExpense;
  }

  // ============ Today Income ============

  double get todayIncome {
    final now = DateTime.now();

    return _transactions
        .where((transaction) {
      final date = transaction.date;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day &&
          transaction.isIncome;
    })
        .fold(
      0.0,
          (sum, transaction) => sum + transaction.amount,
    );
  }

  // ============ Today Expense ============

  double get todayExpense {
    final now = DateTime.now();

    return _transactions
        .where((transaction) {
      final date = transaction.date;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day &&
          !transaction.isIncome;
    })
        .fold(
      0.0,
          (sum, transaction) => sum + transaction.amount,
    );
  }

  // ============ This Month Income ============

  double get thisMonthIncome {
    final now = DateTime.now();

    return _transactions
        .where((transaction) {
      final date = transaction.date;

      return date.year == now.year &&
          date.month == now.month &&
          transaction.isIncome;
    })
        .fold(
      0.0,
          (sum, transaction) => sum + transaction.amount,
    );
  }

  // ============ This Month Expense ============

  double get thisMonthExpense {
    final now = DateTime.now();

    return _transactions
        .where((transaction) {
      final date = transaction.date;

      return date.year == now.year &&
          date.month == now.month &&
          !transaction.isIncome;
    })
        .fold(
      0.0,
          (sum, transaction) => sum + transaction.amount,
    );
  }

  // ============ Monthly Report ============

  Map<String, Map<String, double>> getMonthlyReport() {
    final now = DateTime.now();

    final Map<String, Map<String, double>> report = {};

    for (int i = 5; i >= 0; i--) {
      final date = DateTime(
        now.year,
        now.month - i,
        1,
      );

      final monthKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}';

      double income = 0;
      double expense = 0;

      for (final transaction in _transactions) {
        if (transaction.date.year == date.year &&
            transaction.date.month == date.month) {
          if (transaction.isIncome) {
            income += transaction.amount;
          } else {
            expense += transaction.amount;
          }
        }
      }

      report[monthKey] = {
        'income': income,
        'expense': expense,
      };
    }

    return report;
  }

  // ============ Top Spending Categories ============

  Map<String, double> getTopSpendingCategories() {
    final Map<String, double> categoryTotal = {};

    for (final transaction in _transactions) {
      if (!transaction.isIncome) {
        categoryTotal[transaction.categoryId] =
            (categoryTotal[transaction.categoryId] ?? 0) +
                transaction.amount;
      }
    }
    
    final sortedCategories = categoryTotal.entries.toList();
    
    sortedCategories.sort(
        (a, b) => b.value.compareTo(a.value),
    );

    return Map.fromEntries(sortedCategories);
  }

  List<TransactionModel> searchTransactions(String query) {
    if(query.trim().isEmpty) {
      return _transactions;
    }

    return _transactions.where((transaction) {
      return transaction.title
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();
  }

  void clearData() {
    _transactions.clear();
    _errorMessage = null;
    notifyListeners();
  }
}