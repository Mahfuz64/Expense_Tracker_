import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 3)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool darkMode;

  @HiveField(1)
  String currency; // e.g., 'USD', 'EUR', 'INR'

  @HiveField(2)
  String currencySymbol; // e.g., '$', '€', '₹'

  @HiveField(3)
  bool notificationsEnabled;

  @HiveField(4)
  bool appLockEnabled;

  @HiveField(5)
  String? appLockPin;

  @HiveField(6)
  String language; // 'en', 'es', 'fr', etc.

  @HiveField(7)
  DateTime lastBackupDate;

  AppSettings({
    this.darkMode = false,
    this.currency = 'USD',
    this.currencySymbol = '\$',
    this.notificationsEnabled = true,
    this.appLockEnabled = false,
    this.appLockPin,
    this.language = 'en',
    DateTime? lastBackupDate,
  }) : lastBackupDate = lastBackupDate ?? DateTime.now();

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      darkMode: json['darkMode'] ?? false,
      currency: json['currency'] ?? 'USD',
      currencySymbol: json['currencySymbol'] ?? '\$',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      appLockEnabled: json['appLockEnabled'] ?? false,
      appLockPin: json['appLockPin'],
      language: json['language'] ?? 'en',
      lastBackupDate: json['lastBackupDate'] is DateTime 
          ? json['lastBackupDate'] 
          : (json['lastBackupDate'] != null ? DateTime.parse(json['lastBackupDate']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'currency': currency,
      'currencySymbol': currencySymbol,
      'notificationsEnabled': notificationsEnabled,
      'appLockEnabled': appLockEnabled,
      'appLockPin': appLockPin,
      'language': language,
      'lastBackupDate': lastBackupDate.toIso8601String(),
    };
  }

  AppSettings copyWith({
    bool? darkMode,
    String? currency,
    String? currencySymbol,
    bool? notificationsEnabled,
    bool? appLockEnabled,
    String? appLockPin,
    String? language,
    DateTime? lastBackupDate,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      appLockPin: appLockPin ?? this.appLockPin,
      language: language ?? this.language,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }
}
