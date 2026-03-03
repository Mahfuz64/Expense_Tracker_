# Expense Tracker - Quick Reference Guide

## 🚀 Quick Start (3 steps)

```bash
# Step 1: Get dependencies
flutter pub get

# Step 2: Generate database adapters
flutter pub run build_runner build

# Step 3: Run the app
flutter run
```

## 📱 App Navigation

```
Dashboard (Home)
├── + Add Transaction
└── 4 Tab Navigation:
    ├── Dashboard
    ├── Transactions
    ├── Analytics
    └── Settings
```

## 📊 Features Checklist

### Transaction Management ✅
- [x] Add transactions (income/expense)
- [x] Edit existing transactions
- [x] Delete transactions with confirmation
- [x] View transaction history
- [x] Filter by type and date
- [x] Add notes to transactions

### Category Management ✅
- [x] 11 default categories
- [x] Add custom categories
- [x] Edit category name and color
- [x] Delete custom categories
- [x] Pick emoji icons for categories
- [x] Separate income/expense categories

### Analytics & Insights ✅
- [x] Daily spending summary
- [x] Weekly/Monthly/Yearly analysis
- [x] Category-wise breakdown
- [x] Spending trends (multi-month)
- [x] Unusual spending alerts
- [x] Next month prediction
- [x] Visual progress indicators

### Budget Management ✅
- [x] Set category budgets
- [x] Monthly budget tracking
- [x] 80% warning threshold
- [x] 100% exceeded alert
- [x] Visual progress bars
- [x] Month navigation

### Backup & Restore ✅
- [x] Create local backups
- [x] Restore from backup
- [x] List all backups
- [x] Delete old backups
- [x] Export to CSV
- [x] Generate text reports

### Settings & Customization ✅
- [x] Dark/Light mode
- [x] Currency selection (7 options)
- [x] Notification toggle
- [x] Language selection
- [x] Data reset option
- [x] Backup management
- [x] Version info

## 📂 File Organization

```
lib/
├── main.dart (65 lines)
├── constants/
│   └── app_constants.dart (95 lines)
├── models/ (4 models)
│   ├── category.dart
│   ├── transaction.dart
│   ├── budget.dart
│   └── app_settings.dart
├── providers/ (4 providers)
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   ├── budget_provider.dart
│   └── settings_provider.dart
├── services/ (4 services)
│   ├── database_service.dart
│   ├── analytics_service.dart
│   ├── export_service.dart
│   └── backup_service.dart
├── screens/ (7 screens)
│   ├── dashboard_screen.dart
│   ├── transaction_list_screen.dart
│   ├── add_edit_transaction_screen.dart
│   ├── analytics_screen.dart
│   ├── category_management_screen.dart
│   ├── budget_management_screen.dart
│   └── settings_screen.dart
├── widgets/
│   └── common_widgets.dart (5 widgets)
└── utils/
    └── format_util.dart
```

## 🎨 Color Scheme

```
Primary:   #6366F1 (Indigo)
Secondary: #10B981 (Green)
Accent:    #F59E0B (Yellow)
Danger:    #EF4444 (Red)
Success:   #10B981 (Green)
```

## 💱 Supported Currencies

USD, EUR, GBP, JPY, INR, AUD, CAD

## 🗂️ Default Categories

**Expenses (7):**
- 🍔 Food & Dining
- 🚗 Transport
- 📄 Bills & Utilities
- 🛍️ Shopping
- 🎬 Entertainment
- 🏥 Health
- 📚 Education

**Income (4):**
- 💰 Salary
- 💼 Freelance
- 📈 Investment
- 🎁 Bonus

## 🔧 Key Classes & Methods

### DatabaseService
```dart
// Transactions
addTransaction(Transaction)
updateTransaction(Transaction)
deleteTransaction(String)
getAllTransactions()
getTransactionsByDateRange(DateTime, DateTime)
getTransactionsByCategory(String)
getTransactionsByType(String)

// Categories
addCategory(Category)
updateCategory(Category)
deleteCategory(String)
getAllCategories()
getCategoriesByType(String)
getCategoryById(String)

// Budgets
addBudget(Budget)
updateBudget(Budget)
deleteBudget(String)
getBudgetsForMonth(int, int)
getGlobalBudget(int, int)

// Backup
exportData() → Map<String, dynamic>
importData(Map<String, dynamic>)
clearAllData()
```

### TransactionProvider
```dart
addTransaction(Transaction)
updateTransaction(Transaction)
deleteTransaction(String)
getByType(String) → List<Transaction>
getByDateRange(DateTime, DateTime) → List<Transaction>
getByCategory(String) → List<Transaction>
getTotalIncome() → double
getTotalExpense() → double
getTotalBalance() → double
getRecentTransactions({int limit}) → List<Transaction>
getTodaysTransactions() → List<Transaction>
```

### AnalyticsService
```dart
getCategoryWiseSpending(List<Transaction>, String)
getMonthlySummary(List<Transaction>)
getWeeklySummary(List<Transaction>)
getSpendingTrend(List<Transaction>, int)
getSpendingInsight(List<Transaction>, List<Category>)
getUnusualSpendingAlert(List<Transaction>, List<Category>)
predictNextMonthSpending(List<Transaction>) → double
```

## 📋 Data Models

### Transaction
```dart
String id
double amount
String type (income/expense)
String categoryId
String categoryName
DateTime date
String? note
String? receiptImagePath
DateTime createdAt
DateTime updatedAt
String? categoryIcon
```

### Category
```dart
String id
String name
String icon (emoji)
int colorValue
bool isDefault
String type (income/expense)
```

### Budget
```dart
String id
String categoryId
String categoryName
double amount
String period (monthly/yearly)
int month (1-12)
int year
DateTime createdAt
DateTime updatedAt
bool isGlobal
```

### AppSettings
```dart
bool darkMode
String currency
String currencySymbol
bool notificationsEnabled
bool appLockEnabled
String? appLockPin
String language
DateTime lastBackupDate
```

## 🎯 Screen Routes

```dart
'/' or '/dashboard'      → DashboardScreen
'/add_transaction'       → AddEditTransactionScreen()
'/edit_transaction'      → AddEditTransactionScreen(transaction)
'/categories'            → CategoryManagementScreen
'/budget'                → BudgetManagementScreen
```

## 📊 Database Details

**Type:** Hive (Local NoSQL)
**Boxes:** 4
- transactions
- categories
- budgets
- settings

**Initialization:** Automatic on app start

**Persistence:** All data survives app restart

## 🔐 Security

- [x] Local-only storage
- [x] No cloud transmission
- [x] No internet required
- [x] Privacy-first approach
- [ ] Encryption (future)
- [ ] Biometric lock (future)

## ⚡ Performance

- Dashboard: < 2 seconds load time
- Transaction list: Lazy loading
- Database: Optimized queries
- Charts: Cached calculations
- Animations: Smooth 60 FPS

## 🔧 Common Tasks

### Add New Category
1. Go to Settings → Categories
2. Tap + button
3. Enter name
4. Pick icon and color
5. Tap Add

### Set Budget
1. Go to Settings → Budget
2. Tap Add Budget
3. Select category
4. Enter amount
5. Tap Add

### Export Data
1. Go to Settings → Backup
2. Choose: CSV or PDF
3. Share the file

### Reset App
1. Go to Settings
2. Scroll to Data section
3. Tap Clear All Data
4. Confirm deletion

## 📦 Dependencies

- flutter: SDK
- provider: ^6.4.0
- hive: ^2.2.3
- hive_flutter: ^1.1.0
- fl_chart: ^0.66.0
- pdf: ^3.11.0
- printing: ^5.11.0
- csv: ^5.1.3
- path_provider: ^2.1.0
- intl: ^0.19.0
- uuid: ^4.0.0
- image_picker: ^1.0.0
- permission_handler: ^11.4.4

## 🚨 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Cannot find adapter" | Run `flutter pub run build_runner build` |
| "Gray screen" | Wait for database initialization |
| "No data visible" | Check Settings → Clear All Data → Add transaction |
| "Build fails" | Run `flutter clean && flutter pub get` |
| "Chart errors" | Verify fl_chart is installed |

## 📱 Testing the App

1. **Add Transaction**: Dashboard → +
2. **View Transactions**: Transactions tab
3. **Edit**: Tap transaction in list
4. **Delete**: Swipe left on transaction
5. **View Analytics**: Analytics tab
6. **Set Budget**: Go to Budget (from menu)
7. **Change Settings**: Settings tab

## 🎓 Learning Resources

- Flutter: https://docs.flutter.dev
- Provider: https://pub.dev/packages/provider
- Hive: https://docs.hivedb.dev
- Material Design: https://material.io/design

---

**Everything is ready! Start building with: `flutter run`**
