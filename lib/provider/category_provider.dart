import 'package:expense_tracker/models/category_model.dart';
import 'package:expense_tracker/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  //Get Categories

  Future<void> getCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.getCategories();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Add Category

 Future<bool> addCategory(CategoryModel category) async {
    try {
      _isLoading =true;
      notifyListeners();

      await _categoryService.addCategory(category);
      await getCategories();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
 }

 //Update Category

 Future<void> updateCategory (CategoryModel category)  async {
   try {
     await _categoryService.updateCategory(category);

     await getCategories();
   } catch (e) {
     _errorMessage = e.toString();
     notifyListeners();
   }
}

 //Delete category

Future<void> deleteCategory (String categoryId) async {
    try {
      await _categoryService.deleteCategory(categoryId);

      await getCategories();
    } catch(e) {
      _errorMessage = e.toString();
      notifyListeners();

      rethrow;
    }
}

  CategoryModel? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere(
            (category) => category.id == categoryId,
      );
    } catch (e) {
      return null;
    }
  }
  void clearData() {
    _categories.clear();
    _errorMessage = null;
    notifyListeners();
  }

}
