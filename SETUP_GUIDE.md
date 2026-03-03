# Expense Tracker - Setup & Build Guide

## Quick Start

### 1. Install Dependencies
```bash
cd d:\Flutter_Project\expense_tracker
flutter pub get
```

### 2. Generate Hive Adapters
This is crucial for the database to work properly:
```bash
flutter pub run build_runner build
```

If you encounter issues, clean and rebuild:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

### 3. Run the App
```bash
flutter run
```

For a specific device:
```bash
flutter run -d <device-id>
```

### 4. Build Release APK (Android)
```bash
flutter build apk --release
```

### 5. Build iOS App
```bash
flutter build ios --release
```

## Project Overview

This is a **fully functional expense tracking application** built with Flutter and Provider state management. 

## What's Included

### ✅ Core Features
- [x] Transaction management (Add, Edit, Delete)
- [x] Category management with custom icons and colors
- [x] Budget tracking with visual indicators
- [x] Comprehensive analytics and reports
- [x] Smart spending insights
- [x] Dark/Light theme support
- [x] Multi-currency support
- [x] Backup and restore functionality
- [x] Local data persistence with Hive

### ✅ Screens
1. **Dashboard** - Overview of finances with recent transactions
2. **Transaction List** - View and manage all transactions
3. **Analytics** - Detailed spending analysis and trends
4. **Settings** - Customize app preferences
5. **Add/Edit Transaction** - Create and modify transactions
6. **Category Management** - Manage income and expense categories
7. **Budget Management** - Set and track budgets

### ✅ Utilities & Services
- Database Service (Hive integration)
- Transaction Provider (State management)
- Category Provider (State management)
- Budget Provider (State management)
- Settings Provider (State management)
- Analytics Service (Spending calculations)
- Export Service (CSV/PDF export)
- Backup Service (Data backup/restore)
- Format Utility (Date and currency formatting)

### ✅ Widgets & Components
- PrimaryButton - Custom styled button
- SecondaryButton - Alternative button style
- TransactionCard - Transaction display card
- SummaryCard - Summary statistics card
- CategoryIconPicker - Icon selection widget

## Key Technologies

- **Flutter 3.10.8+** - UI Framework
- **Provider 6.4.0** - State Management
- **Hive 2.2.3** - Local Database
- **fl_chart 0.66.0** - Charts and graphs
- **pdf 3.11.0** - PDF export
- **csv 5.1.3** - CSV export
- **intl 0.19.0** - Date/Time formatting
- **uuid 4.0.0** - Unique ID generation

## File Structure

```
expense_tracker/
├── android/              # Android native code
├── ios/                  # iOS native code
├── lib/
│   ├── constants/        # App constants and colors
│   ├── models/           # Data models (Hive entities)
│   ├── providers/        # State management
│   ├── screens/          # UI screens
│   ├── services/         # Business logic
│   ├── utils/            # Helper functions
│   ├── widgets/          # Reusable widgets
│   └── main.dart         # App entry point
├── test/                 # Unit tests
├── pubspec.yaml          # Dependencies
└── README.md             # Documentation
```

## Database Schema

### Transaction
- id (String)
- amount (double)
- type (income/expense)
- categoryId (String)
- categoryName (String)
- date (DateTime)
- note (String?)
- receiptImagePath (String?)
- createdAt (DateTime)
- updatedAt (DateTime)

### Category
- id (String)
- name (String)
- icon (String - emoji)
- colorValue (int)
- isDefault (bool)
- type (income/expense)

### Budget
- id (String)
- categoryId (String)
- categoryName (String)
- amount (double)
- period (monthly/yearly)
- month (int)
- year (int)
- isGlobal (bool)

### AppSettings
- darkMode (bool)
- currency (String)
- currencySymbol (String)
- notificationsEnabled (bool)
- appLockEnabled (bool)
- appLockPin (String?)
- language (String)
- lastBackupDate (DateTime)

## Common Issues & Solutions

### Issue: "Cannot find default constructor"
**Solution:** Run `flutter pub run build_runner build` to generate Hive adapters

### Issue: "RenderFlex overflowed"
**Solution:** Ensure all SingleChildScrollView containers are used in Column layouts

### Issue: "Gray screen on startup"
**Solution:** This is normal during the first build. Wait for Hive initialization to complete.

### Issue: Backup not working
**Solution:** Ensure path_provider is properly set up and app has document directory access

## Development Tips

1. **Hot Reload**: Use `R` in terminal during `flutter run` for instant updates
2. **Hot Restart**: Use `Shift+R` to fully rebuild the app state
3. **Debugging**: Use `flutter logs` to view console output
4. **Database Reset**: Delete app data in Settings → Clear All Data
5. **Testing**: Run unit tests with `flutter test`

## Performance Notes

- Dashboard loads in < 2 seconds on modern devices
- Transactions list uses lazy loading for better performance
- All database queries are optimized
- Charts are cached and only recomputed when data changes

## Next Steps

1. **Customization**: Modify colors in `constants/app_constants.dart`
2. **Features**: Add new screens and providers following the existing pattern
3. **Testing**: Implement unit and widget tests in the `test/` folder
4. **Distribution**: Prepare the app for App Store and Google Play

## Troubleshooting

If you encounter any issues:

1. **Clean build**: `flutter clean && flutter pub get`
2. **Regenerate files**: `flutter pub run build_runner build --delete-conflicting-outputs`
3. **Check Flutter version**: `flutter --version`
4. **Update packages**: `flutter pub upgrade`

## Support & Documentation

- Flutter Documentation: https://docs.flutter.dev
- Provider Documentation: https://pub.dev/packages/provider
- Hive Documentation: https://docs.hivedb.dev

---

**Ready to build? Start with: `flutter pub get && flutter pub run build_runner build && flutter run`**
