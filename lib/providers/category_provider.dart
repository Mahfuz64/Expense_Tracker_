import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../services/database_service.dart';
import '../constants/app_constants.dart';
import 'package:uuid/uuid.dart';

class CategoryProvider extends ChangeNotifier {
  final DatabaseService _db;
  List<Category> _categories = [];
  List<Category> _expenseCategories = [];
  List<Category> _incomeCategories = [];

  CategoryProvider(this._db) {
    _loadCategories();
  }

  List<Category> get categories => _categories;
  List<Category> get expenseCategories => _expenseCategories;
  List<Category> get incomeCategories => _incomeCategories;

  void _loadCategories() {
    _categories = _db.getAllCategories();
    _expenseCategories = _db.getCategoriesByType('expense');
    _incomeCategories = _db.getCategoriesByType('income');
  }

  Future<void> addCategory(String name, String icon, Color color, String type) async {
    final category = Category(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      colorValue: color.value,
      type: type,
      isDefault: false,
    );

    await _db.addCategory(category);
    _loadCategories();
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    await _db.updateCategory(category);
    _loadCategories();
    notifyListeners();
  }

  Future<void> deleteCategory(String categoryId) async {
    await _db.deleteCategory(categoryId);
    _loadCategories();
    notifyListeners();
  }

  Category? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  void refresh() {
    _loadCategories();
    notifyListeners();
  }
}
