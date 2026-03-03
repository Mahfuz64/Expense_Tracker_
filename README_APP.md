# Expense Tracker - Flutter App

A comprehensive Flutter-based expense tracking application with advanced features for personal finance management.

## Features

### 🔹 4.1 User Management
- Currency selection (USD, EUR, GBP, JPY, INR, AUD, CAD)
- Profile settings
- Language preferences

### 🔹 4.2 Transaction Management
- **Add Transaction**: Enter amount, select type (Income/Expense), choose category, set date, add notes
- **Edit Transaction**: Update any field and save changes
- **Delete Transaction**: Remove transactions with confirmation dialog
- Receipt image attachment (optional)

### 🔹 4.3 Category Management
- Default categories (Food, Transport, Bills, Shopping, Salary, etc.)
- Add custom categories
- Edit category name and color
- Delete custom categories
- Assign emoji icons to categories

### 🔹 4.4 Dashboard
- Total balance display
- Total income and expense summary
- Today's spending summary
- Recent transactions list (last 5)
- Budget progress overview
- Spending insights

### 🔹 4.5 Analytics & Reports
- Monthly, weekly, and yearly summaries
- Category-wise spending breakdown
- Pie charts for expense distribution
- Monthly comparison charts
- Spending trend analysis
- Filter by date range

### 🔹 4.6 Budget Management
- Set monthly budgets
- Category-wise budget allocation
- Warning alerts (80% threshold)
- Critical alerts (100% exceeded)
- Visual progress indicators

### 🔹 4.7 Smart Insights
- Highest spending category detection
- Unusual spending alerts
- Month-over-month comparison
- Spending pattern analysis
- Predicted next month spending (basic ML)

### 🔹 4.8 Export & Backup
- Export reports as PDF
- Export data as CSV
- Local backup and restore
- Automatic backup management

### 🔹 4.9 Settings
- Dark/Light mode toggle
- Currency customization
- Notification preferences
- Data reset option
- Backup management
- Language selection

## Tech Stack

- **Frontend**: Flutter with Provider state management
- **Database**: Hive (local NoSQL database)
- **Charts**: fl_chart for data visualization
- **Export**: pdf and csv packages
- **Utilities**: intl for date/time formatting, uuid for IDs
- **File Management**: path_provider for secure file storage

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── transaction.dart
│   ├── category.dart
│   ├── budget.dart
│   ├── app_settings.dart
│   └── index.dart
├── providers/                         # State management
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   ├── budget_provider.dart
│   ├── settings_provider.dart
├── screens/                           # UI Screens
│   ├── dashboard_screen.dart
│   ├── transaction_list_screen.dart
│   ├── add_edit_transaction_screen.dart
│   ├── analytics_screen.dart
│   ├── category_management_screen.dart
│   ├── budget_management_screen.dart
│   └── settings_screen.dart
├── widgets/                           # Reusable widgets
│   └── common_widgets.dart
├── services/                          # Business logic
│   ├── database_service.dart
│   ├── analytics_service.dart
│   ├── export_service.dart
│   └── backup_service.dart
├── utils/                             # Utility functions
│   └── format_util.dart
├── constants/                         # App constants
│   └── app_constants.dart
```

## Getting Started

### Prerequisites
- Flutter SDK (3.10.8 or higher)
- Dart SDK (3.10.8 or higher)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd expense_tracker
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate Hive adapters**
```bash
flutter pub run build_runner build
```

4. **Run the app**
```bash
flutter run
```

## Usage

### Adding a Transaction
1. Tap the **+** button on the Dashboard
2. Select transaction type (Income/Expense)
3. Enter the amount
4. Select a category
5. Choose date and time
6. Add optional notes
7. Tap "Add Transaction"

### Managing Categories
1. Navigate to Categories from the app menu
2. Tap **+** to add a new category
3. Select icon and color
4. Edit existing categories by tapping on them
5. Delete custom categories (default categories cannot be deleted)

### Setting Budgets
1. Go to Budget Management
2. Tap "Add Budget"
3. Select a category
4. Enter the budget amount
5. View progress with visual indicators

### Viewing Analytics
1. Open Analytics & Reports
2. Select time period (Week/Month/Year)
3. View category-wise spending breakdown
4. Check spending trends and predictions
5. Export data as PDF or CSV

### Backup & Restore
1. Go to Settings
2. Tap "Create Backup" to save your data
3. Tap "Restore from Backup" to load previous data
4. Manage backup files

## Performance Optimization

- Dashboard loads within 2 seconds
- Efficient database queries with indexing
- Lazy loading of transaction lists
- Caching of frequently used data
- Smooth animations and transitions

## Data Security

- All data stored locally on device
- No cloud synchronization (privacy-first)
- Optional PIN-based app lock
- Encrypted backups (in future versions)

## Future Enhancements

- [ ] Cloud backup integration
- [ ] Multi-device sync
- [ ] Receipt image OCR
- [ ] Advanced ML-based predictions
- [ ] Bill reminders
- [ ] Recurring transactions
- [ ] Savings goals
- [ ] Investment tracking
- [ ] Family shared budgets
- [ ] Multi-currency support for international travels

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@expensetracker.app or open an issue in the repository.

## Roadmap

### v1.1
- [ ] Search and advanced filtering
- [ ] Transaction tags
- [ ] Monthly reports PDF export

### v1.2
- [ ] Bill reminders
- [ ] Recurring transactions
- [ ] Saving goals

### v2.0
- [ ] Cloud sync
- [ ] Multi-user support
- [ ] Investment tracking
- [ ] API integration for currency rates

---

**Built with ❤️ using Flutter**
