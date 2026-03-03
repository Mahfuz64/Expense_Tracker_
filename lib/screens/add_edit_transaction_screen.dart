import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common_widgets.dart';
import '../utils/format_util.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final Transaction? transaction;

  const AddEditTransactionScreen({Key? key, this.transaction})
      : super(key: key);

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late String _selectedType;
  late String _selectedCategoryId;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _amountController =
          TextEditingController(text: widget.transaction!.amount.toString());
      _noteController = TextEditingController(text: widget.transaction!.note);
      _selectedType = widget.transaction!.type;
      _selectedCategoryId = widget.transaction!.categoryId;
      _selectedDate = widget.transaction!.date;
      _selectedTime = TimeOfDay.fromDateTime(widget.transaction!.date);
    } else {
      _amountController = TextEditingController();
      _noteController = TextEditingController();
      _selectedType = 'expense';
      _selectedCategoryId = '';
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.transaction == null
              ? 'Add Transaction'
              : 'Edit Transaction'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Consumer3<TransactionProvider, CategoryProvider, SettingsProvider>(
          builder: (context, transactionProvider, categoryProvider,
              settingsProvider, child) {
            final categories = _selectedType == 'income'
                ? categoryProvider.incomeCategories
                : categoryProvider.expenseCategories;

            if (_selectedCategoryId.isEmpty && categories.isNotEmpty) {
              _selectedCategoryId = categories.first.id;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type selector
                  Text(
                    'Type',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'expense',
                              label: Text('Expense'),
                            ),
                            ButtonSegment(
                              value: 'income',
                              label: Text('Income'),
                            ),
                          ],
                          selected: {_selectedType},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              _selectedType = newSelection.first;
                              _selectedCategoryId = '';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Amount
                  Text(
                    'Amount',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: '${settingsProvider.currencySymbol} ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Category
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  categories.isEmpty
                      ? const Center(
                          child: Text('No categories available'),
                        )
                      : DropdownButton<String>(
                          value: _selectedCategoryId,
                          isExpanded: true,
                          items: categories
                              .map((category) => DropdownMenuItem(
                                    value: category.id,
                                    child: Row(
                                      children: [
                                        Text(
                                          category.icon,
                                          style:
                                              const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(category.name),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategoryId = value;
                              });
                            }
                          },
                        ),
                  const SizedBox(height: 24),

                  // Date
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormatUtil.formatDate(_selectedDate)),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Time
                  Text(
                    'Time',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedTime.format(context)),
                          const Icon(Icons.schedule),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Note
                  Text(
                    'Note (Optional)',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Enter note',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  PrimaryButton(
                    text: widget.transaction == null
                        ? 'Add Transaction'
                        : 'Update Transaction',
                    isLoading: _isLoading,
                    onPressed: () async {
                      if (_amountController.text.isEmpty ||
                          _selectedCategoryId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        final amount = double.parse(_amountController.text);
                        final category = categoryProvider
                            .getCategoryById(_selectedCategoryId);
                        final dateTime = DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          _selectedTime.hour,
                          _selectedTime.minute,
                        );

                        final transaction = Transaction(
                          id: widget.transaction?.id ?? '',
                          amount: amount,
                          type: _selectedType,
                          categoryId: _selectedCategoryId,
                          categoryName: category?.name ?? '',
                          date: dateTime,
                          note: _noteController.text.isEmpty
                              ? null
                              : _noteController.text,
                          receiptImagePath: null,
                          createdAt: widget.transaction?.createdAt ??
                              DateTime.now(),
                          updatedAt: DateTime.now(),
                          categoryIcon: category?.icon,
                        );

                        if (widget.transaction == null) {
                          await transactionProvider.addTransaction(transaction);
                        } else {
                          await transactionProvider.updateTransaction(transaction);
                        }

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  if (widget.transaction != null)
                    SecondaryButton(
                      text: 'Delete',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Transaction'),
                            content: const Text(
                              'Are you sure you want to delete this transaction?',
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
                                  Navigator.pop(context);
                                  await transactionProvider
                                      .deleteTransaction(widget.transaction!.id);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
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
}
