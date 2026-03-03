import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common_widgets.dart';
import '../utils/format_util.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String _filterType = 'all'; // 'all', 'income', 'expense'
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Consumer2<TransactionProvider, SettingsProvider>(
          builder: (context, transactionProvider, settingsProvider, child) {
            var transactions = transactionProvider.transactions;

            // Filter by type
            if (_filterType != 'all') {
              transactions = transactions.where((t) => t.type == _filterType).toList();
            }

            // Sort by date (most recent first)
            transactions.sort((a, b) => b.date.compareTo(a.date));

            // Group by date
            final grouped = <String, List<dynamic>>{};
            for (final tx in transactions) {
              final dateKey = DateFormatUtil.formatDate(tx.date);
              grouped.putIfAbsent(dateKey, () => []).add(tx);
            }

            final currencySymbol = settingsProvider.currencySymbol;

            return Column(
              children: [
                // Filter buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilterChip(
                          label: const Text('All'),
                          selected: _filterType == 'all',
                          onSelected: (selected) {
                            setState(() {
                              _filterType = 'all';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilterChip(
                          label: const Text('Income'),
                          selected: _filterType == 'income',
                          onSelected: (selected) {
                            setState(() {
                              _filterType = 'income';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilterChip(
                          label: const Text('Expense'),
                          selected: _filterType == 'expense',
                          onSelected: (selected) {
                            setState(() {
                              _filterType = 'expense';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Transactions list
                if (grouped.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No transactions found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: grouped.entries.length,
                      itemBuilder: (context, index) {
                        final entry = grouped.entries.elementAt(index);
                        final dateKey = entry.key;
                        final dayTransactions = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                dateKey,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            ...dayTransactions.map((tx) {
                              return Dismissible(
                                key: Key(tx.id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  transactionProvider.deleteTransaction(tx.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Transaction deleted'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      '/edit_transaction',
                                      arguments: tx,
                                    );
                                  },
                                  child: TransactionCard(
                                    categoryName: tx.categoryName,
                                    categoryIcon: tx.categoryIcon ?? '📁',
                                    amount: tx.amount,
                                    date: DateFormatUtil.formatTime(tx.date),
                                    note: tx.note,
                                    type: tx.type,
                                    currencySymbol: currencySymbol,
                                  ),
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
