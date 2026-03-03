import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/category_provider.dart';
import '../services/analytics_service.dart';
import '../utils/format_util.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'month'; // 'week', 'month', 'year'
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _updateDateRange();
  }

  void _updateDateRange() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'week':
        _startDate = now.subtract(Duration(days: now.weekday - 1));
        _endDate = _startDate.add(const Duration(days: 6));
        break;
      case 'month':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 'year':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = DateTime(now.year + 1, 1, 0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics & Reports'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Consumer3<TransactionProvider, SettingsProvider, CategoryProvider>(
          builder: (context, transactionProvider, settingsProvider, categoryProvider, child) {
            final transactions = transactionProvider.getByDateRange(_startDate, _endDate);
            final currencySymbol = settingsProvider.currencySymbol;

            final totalIncome = transactions
                .where((t) => t.type == 'income')
                .fold(0.0, (sum, t) => sum + t.amount);
            final totalExpense = transactions
                .where((t) => t.type == 'expense')
                .fold(0.0, (sum, t) => sum + t.amount);

            final categoryWise = AnalyticsService.getCategoryWiseSpending(transactions, 'expense');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period selector
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'week',
                              label: Text('Week'),
                            ),
                            ButtonSegment(
                              value: 'month',
                              label: Text('Month'),
                            ),
                            ButtonSegment(
                              value: 'year',
                              label: Text('Year'),
                            ),
                          ],
                          selected: {_selectedPeriod},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              _selectedPeriod = newSelection.first;
                              _updateDateRange();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Summary
                  Text(
                    'Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Income:'),
                            Text(
                              '$currencySymbol${totalIncome.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Expense:'),
                            Text(
                              '$currencySymbol${totalExpense.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Net Balance:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$currencySymbol${(totalIncome - totalExpense).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: totalIncome >= totalExpense ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category-wise breakdown
                  if (categoryWise.isNotEmpty) ...[
                    Text(
                      'Category-wise Spending',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: categoryWise.entries
                            .map((entry) {
                              final categoryId = entry.key;
                              final amount = entry.value;
                              final percentage =
                                  (amount / totalExpense * 100).toStringAsFixed(1);
                              final category =
                                  categoryProvider.getCategoryById(categoryId);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Text(
                                      category?.icon ?? '📁',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            category?.name ?? 'Unknown',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: amount / totalExpense,
                                              minHeight: 6,
                                              backgroundColor: Colors.grey[300],
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color(category?.colorValue ??
                                                    Colors.blue.value),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '$currencySymbol${amount.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '$percentage%',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Unusual spending alert
                  if (AnalyticsService.getUnusualSpendingAlert(
                        transactionProvider.transactions,
                        categoryProvider.categories,
                      ).isNotEmpty) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange[200]!,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        AnalyticsService.getUnusualSpendingAlert(
                          transactionProvider.transactions,
                          categoryProvider.categories,
                        ),
                        style: TextStyle(color: Colors.orange[900]),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Prediction
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Predicted Next Month Spending',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$currencySymbol${AnalyticsService.predictNextMonthSpending(transactionProvider.transactions).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
