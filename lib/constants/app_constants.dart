import 'package:flutter/material.dart';
import '../models/category.dart';

class AppConstants {

  static const List<String> currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'INR',
    'AUD',
    'CAD',
    'BDT',
  ];

  static const Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'INR': '₹',
    'AUD': 'A\$',
    'CAD': 'C\$',
    'BDT': '৳',
  };


  static const List<String> languages = ['en', 'es', 'fr', 'de', 'it', 'pt'];


  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF10B981);
  static const Color accentColor = Color(0xFFF59E0B);
  static const Color dangerColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);


  static const double budgetWarningThreshold = 0.8; // 80%
  static const double budgetCriticalThreshold = 1.0; // 100%


  static List<Category> getDefaultCategories() {
    return [

      Category(
        id: 'food',
        name: 'Food & Dining',
        icon: '🍔',
        colorValue: Colors.orange.value,
        isDefault: true,
        type: 'expense',
      ),
      Category(
        id: 'transport',
        name: 'Transport',
        icon: '🚗',
        colorValue: Colors.blue.value,
        isDefault: true,
        type: 'expense',
      ),
      Category(
        id: 'bills',
        name: 'Bills & Utilities',
        icon: '📄',
        colorValue: Colors.red.value,
        isDefault: true,
        type: 'expense',
      ),
      Category(
        id: 'shopping',
        name: 'Shopping',
        icon: '🛍️',
        colorValue: Colors.pink.value,
        isDefault: true,
        type: 'expense',
      ),
      Category(
        id: 'entertainment',
        name: 'Entertainment',
        icon: '🎬',
        colorValue: Colors.purple.value,
        isDefault: true,
        type: 'expense',
      ),
      Category(
        id: 'health',
        name: 'Health',
        icon: '🏥',
        colorValue: Colors.green.value,
        isDefault: true,
        type: 'expense',
      ),
      Category(
        id: 'education',
        name: 'Education',
        icon: '📚',
        colorValue: Colors.indigo.value,
        isDefault: true,
        type: 'expense',
      ),

      Category(
        id: 'salary',
        name: 'Salary',
        icon: '💰',
        colorValue: Colors.green.value,
        isDefault: true,
        type: 'income',
      ),
      Category(
        id: 'freelance',
        name: 'Freelance',
        icon: '💼',
        colorValue: Colors.cyan.value,
        isDefault: true,
        type: 'income',
      ),
      Category(
        id: 'investment',
        name: 'Investment',
        icon: '📈',
        colorValue: Colors.deepOrange.value,
        isDefault: true,
        type: 'income',
      ),
      Category(
        id: 'bonus',
        name: 'Bonus',
        icon: '🎁',
        colorValue: Colors.yellow.value,
        isDefault: true,
        type: 'income',
      ),
    ];
  }
}
