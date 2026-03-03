import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/common_widgets.dart';
import '../constants/app_constants.dart';

class BudgetManagementScreen extends StatefulWidget {
  const BudgetManagementScreen({Key? key}) : super(key: key);

  @override
  State<BudgetManagementScreen> createState() =>
      _BudgetManagementScreenState();
}

class _BudgetManagementScreenState extends State<BudgetManagementScreen> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Budget Management'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Consumer3<BudgetProvider, CategoryProvider, TransactionProvider>(
          builder: (context, budgetProvider, categoryProvider,
              transactionProvider, child) {
            final budgets = budgetProvider.getBudgetsForMonth(
              _currentMonth.month,
              _currentMonth.year,
            );
            final expenseCategories = categoryProvider.expenseCategories;
            final monthTransactions = transactionProvider.getByDateRange(
              DateTime(_currentMonth.year, _currentMonth.month, 1),
              DateTime(_currentMonth.year, _currentMonth.month + 1, 0),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month - 1,
                            );
                          });
                        },
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month + 1,
                            );
                          });
                        },
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),


                  PrimaryButton(
                    text: 'Add Budget',
                    onPressed: () {
                      _showAddBudgetDialog(
                        context,
                        budgetProvider,
                        categoryProvider,
                      );
                    },
                  ),
                  const SizedBox(height: 24),


                  if (budgets.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          const Text('No budgets set for this month'),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: budgets.length,
                      itemBuilder: (context, index) {
                        final budget = budgets[index];
                        final categoryExpenses = monthTransactions
                            .where((t) => t.categoryId == budget.categoryId && t.type == 'expense')
                            .fold(0.0, (sum, t) => sum + t.amount);

                        final percentage = budget.amount > 0
                            ? (categoryExpenses / budget.amount * 100)
                            : 0.0;
                        final isExceeded = categoryExpenses > budget.amount;
                        final isWarning = categoryExpenses > budget.amount * 0.8;

                        Color statusColor = Colors.green;
                        String statusText = 'On Track';
                        if (isExceeded) {
                          statusColor = Colors.red;
                          statusText = 'Exceeded';
                        } else if (isWarning) {
                          statusColor = Colors.orange;
                          statusText = 'Warning';
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          budget.categoryName.isNotEmpty
                                              ? '${budget.categoryName}'
                                              : 'Monthly Budget',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      statusText,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Spent: \$${categoryExpenses.toStringAsFixed(2)}',
                                    ),
                                    Text(
                                      'Budget: \$${budget.amount.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: percentage > 1 ? 1 : percentage / 100,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      statusColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${percentage.toStringAsFixed(1)}% spent',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddBudgetDialog(
    BuildContext context,
    BudgetProvider budgetProvider,
    CategoryProvider categoryProvider,
  ) {
    String selectedCategoryId = '';
    double budgetAmount = 0;
    final categories = categoryProvider.expenseCategories;

    if (categories.isNotEmpty) {
      selectedCategoryId = categories.first.id;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Set Budget'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Category:'),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedCategoryId,
                    isExpanded: true,
                    items: categories
                        .map((category) => DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategoryId = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Budget Amount:'),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      budgetAmount = double.tryParse(value) ?? 0;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedCategoryId.isEmpty || budgetAmount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields correctly'),
                      ),
                    );
                    return;
                  }

                  final category =
                      categoryProvider.getCategoryById(selectedCategoryId);

                  await budgetProvider.addBudget(
                    selectedCategoryId,
                    category?.name ?? '',
                    budgetAmount,
                    _currentMonth.month,
                    _currentMonth.year,
                    false,
                  );

                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}
