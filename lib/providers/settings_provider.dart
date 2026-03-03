import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '../services/database_service.dart';

class SettingsProvider extends ChangeNotifier {
  final DatabaseService _db;
  late AppSettings _settings;

  SettingsProvider(this._db) {
    _loadSettings();
  }

  AppSettings get settings => _settings;
  bool get darkMode => _settings.darkMode;
  String get currency => _settings.currency;
  String get currencySymbol => _settings.currencySymbol;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  bool get appLockEnabled => _settings.appLockEnabled;
  String get language => _settings.language;

  void _loadSettings() {
    _settings = _db.getSettings();
  }

  Future<void> setDarkMode(bool value) async {
    _settings = _settings.copyWith(darkMode: value);
    await _db.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> setCurrency(String currency, String symbol) async {
    _settings = _settings.copyWith(currency: currency, currencySymbol: symbol);
    await _db.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    _settings = _settings.copyWith(notificationsEnabled: value);
    await _db.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> setAppLock(bool enabled, String? pin) async {
    _settings = _settings.copyWith(appLockEnabled: enabled, appLockPin: pin);
    await _db.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _settings = _settings.copyWith(language: language);
    await _db.updateSettings(_settings);
    notifyListeners();
  }

  Future<void> updateLastBackupDate() async {
    _settings = _settings.copyWith(lastBackupDate: DateTime.now());
    await _db.updateSettings(_settings);
    notifyListeners();
  }

  void refresh() {
    _loadSettings();
    notifyListeners();
  }
}
