import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/category_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Category

Future<void> addCategory(CategoryModel category) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await _firestore.collection('users').doc(uid).collection('categories').add({
    'name':category.name,
    'iconCode': category.icon.codePoint,
    'fontFamily': category.icon.fontFamily,
    'colorValue': category.color.toARGB32(),
    'isIncome': category.isIncome
  });
}

//Read/Get Categories

Future<List<CategoryModel>> getCategories() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final snapShot = await _firestore.collection('users').doc(uid).collection('categories').get();

  return snapShot.docs.map((doc){
    final data = doc.data();

    return CategoryModel(
        id: doc.id,
        name: data['name'] as String,
        icon: IconData(
          data['iconCode'] as int,
          fontFamily: data['fontFamily'] as String?,
        ),
        color: Color(data['colorValue'] as int),
        isIncome: data['isIncome'] as bool,
    );
  }).toList();
}

//Update Category

Future<void> updateCategory(CategoryModel category) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await _firestore
      .collection('users')
      .doc(uid)
      .collection('categories')
      .doc(category.id)
      .update({
    'name': category.name,
    'iconCode': category.icon.codePoint,
    'fontFamily': category.icon.fontFamily,
    'colorValue': category.color.toARGB32(),
    'isIncome': category.isIncome
  });
}
//Delete Category

Future<void> deleteCategory(String categoryId) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await _firestore
      .collection('users')
      .doc(uid)
      .collection('categories')
      .doc(categoryId)
      .delete();
}
}
