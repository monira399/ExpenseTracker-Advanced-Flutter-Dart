import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //Add Category

Future<String> addTransaction(TransactionModel transaction) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final docRef = await _fireStore
      .collection('users')
      .doc(uid)
      .collection('transactions')
      .add({
    'title': transaction.title,
    'date': transaction.date,
    'amount': transaction.amount,
    'isIncome': transaction.isIncome,
    'categoryId': transaction.categoryId,
    'note': transaction.note
  });

  return docRef.id;

}




  //Get Transactions

  Future<List<TransactionModel>> getTransaction() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapShot = await _fireStore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .get();

    final transactions = snapShot.docs.map((doc) {
      final data = doc.data();

      return TransactionModel(
        id: doc.id,
        title: data['title'],
        date: (data['date'] as Timestamp).toDate(),
        amount: (data['amount'] as num).toDouble(),
        isIncome: data['isIncome'],
        categoryId: data['categoryId'],
        note: data['note'],
      );
    }).toList();

    transactions.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return transactions;
  }

  //Update Category

Future<void> updateTransaction(TransactionModel transaction) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await _fireStore.collection('users').doc(uid).collection('transactions').doc(transaction.id).update({
    'title': transaction.title,
    'date': transaction.date,
    'amount': transaction.amount,
    'isIncome': transaction.isIncome,
    'categoryId': transaction.categoryId,
    'note': transaction.note,
  });
}

  //Delete Category

Future<void> deleteTransaction(String transactionId) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await _fireStore.collection('users').doc(uid).collection('transactions').doc(transactionId).delete();
}
}