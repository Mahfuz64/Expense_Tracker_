import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';

class BudgetProvider extends ChangeNotifier {
  final DatabaseService _db;
  List<Budget> _budgets = [];

  BudgetProvider(this._db) {
    _loadBudgets();
  }

  List<Budget> get budgets => _budgets;

  void _loadBudgets() {
    _budgets = _db.getAllBudgets();
  }

  Future<void> addBudget(String categoryId, String categoryName, double amount, int month, int year, bool isGlobal) async {
    final budget = Budget(
      id: const Uuid().v4(),
      categoryId: categoryId,
      categoryName: categoryName,
      amount: amount,
      period: 'monthly',
      month: month,
      year: year,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isGlobal: isGlobal,
    );

    await _db.addBudget(budget);
    _loadBudgets();
    notifyListeners();
  }

  Future<void> updateBudget(Budget budget) async {
    final updatedBudget = budget.copyWith(updatedAt: DateTime.now());
    await _db.updateBudget(updatedBudget);
    _loadBudgets();
    notifyListeners();
  }

  Future<void> deleteBudget(String budgetId) async {
    await _db.deleteBudget(budgetId);
    _loadBudgets();
    notifyListeners();
  }

  List<Budget> getBudgetsForMonth(int month, int year) {
    return _db.getBudgetsForMonth(month, year);
  }

  Budget? getGlobalBudget(int month, int year) {
    return _db.getGlobalBudget(month, year);
  }

  Budget? getBudgetForCategory(String categoryId, int month, int year) {
    try {
      return _budgets.firstWhere(
        (b) => b.categoryId == categoryId && b.month == month && b.year == year && !b.isGlobal,
      );
    } catch (e) {
      return null;
    }
  }

  void refresh() {
    _loadBudgets();
    notifyListeners();
  }
}
