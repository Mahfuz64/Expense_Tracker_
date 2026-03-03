import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService _db;
  List<Transaction> _transactions = [];

  TransactionProvider(this._db) {
    _loadTransactions();
  }

  List<Transaction> get transactions => _transactions;

  void _loadTransactions() {
    _transactions = _db.getAllTransactions();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final tx = transaction.copyWith(
      id: transaction.id.isEmpty ? const Uuid().v4() : transaction.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _db.addTransaction(tx);
    _loadTransactions();
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final updatedTx = transaction.copyWith(updatedAt: DateTime.now());
    await _db.updateTransaction(updatedTx);
    _loadTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _db.deleteTransaction(transactionId);
    _loadTransactions();
    notifyListeners();
  }

  void refresh() {
    _loadTransactions();
    notifyListeners();
  }

  List<Transaction> getByType(String type) {
    return _db.getTransactionsByType(type);
  }

  List<Transaction> getByDateRange(DateTime start, DateTime end) {
    return _db.getTransactionsByDateRange(start, end);
  }

  List<Transaction> getByCategory(String categoryId) {
    return _db.getTransactionsByCategory(categoryId);
  }

  double getTotalByType(String type) {
    return _db.getTransactionsByType(type)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double getTotalIncome() {
    return getTotalByType('income');
  }

  double getTotalExpense() {
    return getTotalByType('expense');
  }

  double getTotalBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  List<Transaction> getTodaysTransactions() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return _db.getTransactionsByDateRange(startOfDay, endOfDay);
  }

  List<Transaction> getRecentTransactions({int limit = 10}) {
    final sorted = List<Transaction>.from(_transactions)
        ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }
}

extension on String {
  bool get isEmpty => this == '';
}
