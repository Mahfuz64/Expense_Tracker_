import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/transaction.dart';
import 'services/database_service.dart';
import 'providers/transaction_provider.dart';
import 'providers/category_provider.dart';
import 'providers/budget_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_edit_transaction_screen.dart';
import 'screens/category_management_screen.dart';
import 'screens/budget_management_screen.dart';
import 'constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final db = DatabaseService();
  await db.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => db),
        ChangeNotifierProvider(create: (_) => TransactionProvider(db)),
        ChangeNotifierProvider(create: (_) => CategoryProvider(db)),
        ChangeNotifierProvider(create: (_) => BudgetProvider(db)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(db)),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: 'Expense Tracker',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppConstants.primaryColor,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppConstants.primaryColor,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            themeMode: settingsProvider.darkMode 
                ? ThemeMode.dark 
                : ThemeMode.light,
            home: const DashboardScreen(),
            routes: {
              '/dashboard': (context) => const DashboardScreen(),
              '/add_transaction': (context) => const AddEditTransactionScreen(),
              '/edit_transaction': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                final transaction = args is Transaction ? args : null;
                return AddEditTransactionScreen(transaction: transaction);
              },
              '/categories': (context) => const CategoryManagementScreen(),
              '/budget': (context) => const BudgetManagementScreen(),
            },
          );
        },
      ),
    );
  }
}
