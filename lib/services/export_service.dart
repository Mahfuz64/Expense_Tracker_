import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class ExportService {
  static String generateCSV(List<Transaction> transactions, List<Category> categories) {
    final List<List<String>> data = [
      ['Date', 'Category', 'Type', 'Amount', 'Note'],
    ];

    for (final tx in transactions) {
      final category = categories.firstWhere(
        (c) => c.id == tx.categoryId,
        orElse: () => Category(
          id: '',
          name: 'Unknown',
          icon: '📁',
          colorValue: 0,
          type: 'expense',
        ),
      );

      data.add([
        DateFormat('dd/MM/yyyy').format(tx.date),
        category.name,
        tx.type,
        tx.amount.toString(),
        tx.note ?? '',
      ]);
    }

    final csv = data
        .map((row) => row
            .map((cell) => cell.contains(',') ? '"$cell"' : cell)
            .join(','))
        .join('\n');

    return csv;
  }

  static String generateSummaryReport(
    List<Transaction> transactions,
    List<Category> categories,
    DateTime startDate,
    DateTime endDate,
  ) {
    final buffer = StringBuffer();
    buffer.writeln('Expense Report');
    buffer.writeln('${DateFormat('dd/MM/yyyy').format(startDate)} to ${DateFormat('dd/MM/yyyy').format(endDate)}');
    buffer.writeln('');

    final filtered = transactions
        .where((t) => t.date.isAfter(startDate) && t.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    final totalIncome = filtered
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpense = filtered
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    buffer.writeln('Total Income: \$${totalIncome.toStringAsFixed(2)}');
    buffer.writeln('Total Expense: \$${totalExpense.toStringAsFixed(2)}');
    buffer.writeln('Net Balance: \$${(totalIncome - totalExpense).toStringAsFixed(2)}');
    buffer.writeln('');


    buffer.writeln('Category Breakdown:');
    final categoryWise = <String, double>{};
    for (final tx in filtered) {
      categoryWise[tx.categoryId] = (categoryWise[tx.categoryId] ?? 0) + tx.amount;
    }

    for (final entry in categoryWise.entries) {
      final category = categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => Category(
          id: '',
          name: 'Unknown',
          icon: '📁',
          colorValue: 0,
          type: 'expense',
        ),
      );
      buffer.writeln('${category.name}: \$${entry.value.toStringAsFixed(2)}');
    }

    return buffer.toString();
  }
}
