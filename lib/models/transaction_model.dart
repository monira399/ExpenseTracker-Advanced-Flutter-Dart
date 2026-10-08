
class TransactionModel {
  final String id;
  final String title;
  final DateTime date;
  final double amount;
  final bool isIncome;
  final String categoryId;
  final String note;

  TransactionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.categoryId,
    required this.note,
  });
}

