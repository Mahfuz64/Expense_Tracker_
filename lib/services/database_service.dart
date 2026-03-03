import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/budget.dart';
import '../models/app_settings.dart';
import '../constants/app_constants.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static const String _transactionsBoxName = 'transactions';
  static const String _categoriesBoxName = 'categories';
  static const String _budgetsBoxName = 'budgets';
  static const String _settingsBoxName = 'settings';
  
  late Box<Transaction> _transactionsBox;
  late Box<Category> _categoriesBox;
  late Box<Budget> _budgetsBox;
  late Box<AppSettings> _settingsBox;

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(BudgetAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }

    // Open boxes
    _transactionsBox = await Hive.openBox<Transaction>(_transactionsBoxName);
    _categoriesBox = await Hive.openBox<Category>(_categoriesBoxName);
    _budgetsBox = await Hive.openBox<Budget>(_budgetsBoxName);
    _settingsBox = await Hive.openBox<AppSettings>(_settingsBoxName);

    // Initialize default data if empty
    await _initializeDefaults();
  }

  Future<void> _initializeDefaults() async {
    // Initialize settings if first time
    if (_settingsBox.isEmpty) {
      final settings = AppSettings();
      await _settingsBox.put('app_settings', settings);
    }

    // Initialize default categories if empty
    if (_categoriesBox.isEmpty) {
      final defaultCategories = AppConstants.getDefaultCategories();
      for (final category in defaultCategories) {
        await _categoriesBox.put(category.id, category);
      }
    }
  }

  // Transaction operations
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionsBox.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _transactionsBox.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _transactionsBox.delete(transactionId);
  }

  List<Transaction> getAllTransactions() {
    return _transactionsBox.values.toList();
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactionsBox.values
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  List<Transaction> getTransactionsByCategory(String categoryId) {
    return _transactionsBox.values
        .where((t) => t.categoryId == categoryId)
        .toList();
  }

  List<Transaction> getTransactionsByType(String type) {
    return _transactionsBox.values
        .where((t) => t.type == type)
        .toList();
  }

  // Category operations
  Future<void> addCategory(Category category) async {
    await _categoriesBox.put(category.id, category);
  }

  Future<void> updateCategory(Category category) async {
    await _categoriesBox.put(category.id, category);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoriesBox.delete(categoryId);
  }

  List<Category> getAllCategories() {
    return _categoriesBox.values.toList();
  }

  List<Category> getDefaultCategories() {
    return _categoriesBox.values.where((c) => c.isDefault).toList();
  }

  List<Category> getCategoriesByType(String type) {
    return _categoriesBox.values.where((c) => c.type == type).toList();
  }

  Category? getCategoryById(String categoryId) {
    return _categoriesBox.get(categoryId);
  }

  // Budget operations
  Future<void> addBudget(Budget budget) async {
    await _budgetsBox.put(budget.id, budget);
  }

  Future<void> updateBudget(Budget budget) async {
    await _budgetsBox.put(budget.id, budget);
  }

  Future<void> deleteBudget(String budgetId) async {
    await _budgetsBox.delete(budgetId);
  }

  List<Budget> getAllBudgets() {
    return _budgetsBox.values.toList();
  }

  List<Budget> getBudgetsForMonth(int month, int year) {
    return _budgetsBox.values
        .where((b) => b.month == month && b.year == year)
        .toList();
  }

  Budget? getGlobalBudget(int month, int year) {
    return _budgetsBox.values.firstWhere(
      (b) => b.isGlobal && b.month == month && b.year == year,
      orElse: () => null as Budget,
    );
  }

  // Settings operations
  AppSettings getSettings() {
    return _settingsBox.get('app_settings') ?? AppSettings();
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _settingsBox.put('app_settings', settings);
  }

  // Backup and restore
  Future<Map<String, dynamic>> exportData() async {
    return {
      'transactions': _transactionsBox.values.map((t) => t.toJson()).toList(),
      'categories': _categoriesBox.values.map((c) => c.toJson()).toList(),
      'budgets': _budgetsBox.values.map((b) => b.toJson()).toList(),
      'settings': getSettings().toJson(),
    };
  }

  Future<void> importData(Map<String, dynamic> data) async {
    // Import transactions
    if (data['transactions'] is List) {
      for (final txJson in data['transactions']) {
        final transaction = Transaction.fromJson(txJson);
        await addTransaction(transaction);
      }
    }

    // Import categories (skip default ones)
    if (data['categories'] is List) {
      for (final catJson in data['categories']) {
        final category = Category.fromJson(catJson);
        if (!category.isDefault) {
          await addCategory(category);
        }
      }
    }

    // Import budgets
    if (data['budgets'] is List) {
      for (final budgetJson in data['budgets']) {
        final budget = Budget.fromJson(budgetJson);
        await addBudget(budget);
      }
    }

    // Import settings
    if (data['settings'] is Map) {
      final settings = AppSettings.fromJson(data['settings'] as Map<String, dynamic>);
      await updateSettings(settings);
    }
  }

  Future<void> clearAllData() async {
    await _transactionsBox.clear();
    await _categoriesBox.clear();
    await _budgetsBox.clear();
    await _settingsBox.clear();
    await _initializeDefaults();
  }
}
