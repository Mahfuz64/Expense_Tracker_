import '../models/transaction.dart';
import '../models/category.dart';

class AnalyticsService {
  static Map<String, double> getCategoryWiseSpending(List<Transaction> transactions, String type) {
    final Map<String, double> categorySpending = {};

    for (final tx in transactions.where((t) => t.type == type)) {
      categorySpending[tx.categoryId] = (categorySpending[tx.categoryId] ?? 0) + tx.amount;
    }

    return categorySpending;
  }

  static Map<String, double> getMonthlySummary(List<Transaction> transactions) {
    final Map<String, double> monthlySummary = {};

    for (final tx in transactions) {
      final monthKey = '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}';
      if (tx.type == 'expense') {
        monthlySummary[monthKey] = (monthlySummary[monthKey] ?? 0) + tx.amount;
      }
    }

    return monthlySummary;
  }

  static Map<String, double> getWeeklySummary(List<Transaction> transactions) {
    final Map<String, double> weeklySummary = {};

    for (final tx in transactions) {
      final weekStart = tx.date.subtract(Duration(days: tx.date.weekday - 1));
      final weekKey = '${weekStart.year}-W${_getWeekNumber(weekStart)}';
      weeklySummary[weekKey] = (weeklySummary[weekKey] ?? 0) + tx.amount;
    }

    return weeklySummary;
  }

  static int _getWeekNumber(DateTime date) {
    final jan4 = DateTime(date.year, 1, 4);
    final startDate = jan4.subtract(Duration(days: jan4.weekday - 1));
    final days = date.difference(startDate).inDays;
    return (days / 7).ceil();
  }

  static Map<String, dynamic> getSpendingTrend(List<Transaction> transactions, int months) {
    final now = DateTime.now();
    final trend = <String, double>{};

    for (int i = months - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      
      final monthStart = DateTime(date.year, date.month, 1);
      final monthEnd = DateTime(date.year, date.month + 1, 0);

      trend[monthKey] = transactions
          .where((t) => t.type == 'expense' && t.date.isAfter(monthStart) && t.date.isBefore(monthEnd.add(const Duration(days: 1))))
          .fold(0.0, (sum, t) => sum + t.amount);
    }

    return {'trend': trend};
  }

  static String getSpendingInsight(List<Transaction> transactions, List<Category> categories) {
    if (transactions.isEmpty) {
      return 'No transactions yet. Start tracking your expenses!';
    }

    final categoryWise = getCategoryWiseSpending(transactions, 'expense');
    if (categoryWise.isEmpty) {
      return 'No expenses found.';
    }

    final maxCategory = categoryWise.entries.reduce((a, b) => a.value > b.value ? a : b);
    final category = categories.firstWhere(
      (c) => c.id == maxCategory.key,
      orElse: () => Category(
        id: '',
        name: 'Unknown',
        icon: '📁',
        colorValue: 0,
        type: 'expense',
      ),
    );

    final total = categoryWise.values.fold(0.0, (sum, amount) => sum + amount);
    final percentage = ((maxCategory.value / total) * 100).toStringAsFixed(1);

    return 'You spent ${percentage}% of your money on ${category.name}.';
  }

  static String getUnusualSpendingAlert(List<Transaction> transactions, List<Category> categories) {
    if (transactions.length < 2) return '';

    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final thisMonthEnd = DateTime(now.year, now.month + 1, 0);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(now.year, now.month, 0);

    final thisMonthSpending = transactions
        .where((t) => t.type == 'expense' && t.date.isAfter(thisMonthStart) && t.date.isBefore(thisMonthEnd.add(const Duration(days: 1))))
        .fold(0.0, (sum, t) => sum + t.amount);

    final lastMonthSpending = transactions
        .where((t) => t.type == 'expense' && t.date.isAfter(lastMonthStart) && t.date.isBefore(lastMonthEnd.add(const Duration(days: 1))))
        .fold(0.0, (sum, t) => sum + t.amount);

    if (lastMonthSpending == 0) return '';

    final percentageChange = ((thisMonthSpending - lastMonthSpending) / lastMonthSpending * 100);

    if (percentageChange > 30) {
      return '⚠️ Alert! You spent ${percentageChange.toStringAsFixed(1)}% more than last month.';
    } else if (percentageChange < -30) {
      return '✨ Great! You spent ${(-percentageChange).toStringAsFixed(1)}% less than last month.';
    }

    return '';
  }

  static double predictNextMonthSpending(List<Transaction> transactions) {
    if (transactions.isEmpty) return 0;

    final now = DateTime.now();
    final last3Months = <double>[];

    for (int i = 0; i < 3; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthStart = DateTime(date.year, date.month, 1);
      final monthEnd = DateTime(date.year, date.month + 1, 0);

      final monthTotal = transactions
          .where((t) => t.type == 'expense' && t.date.isAfter(monthStart) && t.date.isBefore(monthEnd.add(const Duration(days: 1))))
          .fold(0.0, (sum, t) => sum + t.amount);

      last3Months.add(monthTotal);
    }

    return last3Months.fold(0.0, (sum, amount) => sum + amount) / last3Months.length;
  }
}
