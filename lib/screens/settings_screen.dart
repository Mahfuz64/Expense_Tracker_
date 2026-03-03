import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/transaction_provider.dart';
import '../services/backup_service.dart';
import '../constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isBackingUp = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Consumer2<SettingsProvider, TransactionProvider>(
          builder: (context, settingsProvider, transactionProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildSectionTitle('Appearance'),
                  const SizedBox(height: 12),
                  Card(
                    child: SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: settingsProvider.darkMode,
                      onChanged: (value) {
                        settingsProvider.setDarkMode(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),


                  _buildSectionTitle('Currency'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Currency',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 12),
                          DropdownButton<String>(
                            value: settingsProvider.currency,
                            isExpanded: true,
                            items: AppConstants.currencies
                                .map((currency) => DropdownMenuItem(
                                      value: currency,
                                      child: Text(
                                        '$currency (${AppConstants.currencySymbols[currency]})',
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                final symbol =
                                    AppConstants.currencySymbols[value] ?? '\$';
                                settingsProvider.setCurrency(value, symbol);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),


                  _buildSectionTitle('Notifications'),
                  const SizedBox(height: 12),
                  Card(
                    child: SwitchListTile(
                      title: const Text('Enable Notifications'),
                      value: settingsProvider.notificationsEnabled,
                      onChanged: (value) {
                        settingsProvider.setNotifications(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),


                  _buildSectionTitle('Data'),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.backup),
                          title: const Text('Create Backup'),
                          subtitle: const Text('Backup all your data'),
                          trailing: _isBackingUp
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: _isBackingUp
                              ? null
                              : () async {
                                  setState(() {
                                    _isBackingUp = true;
                                  });
                                  try {
                                    await BackupService.createBackup();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Backup created successfully'),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text('Backup failed: $e'),
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      _isBackingUp = false;
                                    });
                                  }
                                },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.restore),
                          title: const Text('Restore from Backup'),
                          subtitle: const Text('Restore your data'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () async {
                            final backups =
                                await BackupService.getBackupList();
                            if (!mounted) return;

                            if (backups.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No backups found'),
                                ),
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Select Backup'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    itemCount: backups.length,
                                    itemBuilder: (context, index) {
                                      final backup = backups[index];
                                      return ListTile(
                                        title: Text(backup.path.split('/').last),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          try {
                                            await BackupService.restoreBackup(
                                              backup.path,
                                            );
                                            transactionProvider.refresh();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Backup restored successfully',
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('Restore failed: $e'),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text(
                            'Clear All Data',
                            style: TextStyle(color: Colors.red),
                          ),
                          subtitle: const Text('Delete all transactions and settings'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Clear All Data'),
                                content: const Text(
                                  'Are you sure? This action cannot be undone.',
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
                                      try {
                                        final db = await transactionProvider;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'All data has been cleared',
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                          ),
                                        );
                                      }
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
                  ),
                  const SizedBox(height: 24),


                  _buildSectionTitle('About'),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Version'),
                          trailing: const Text('1.0.0'),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('App Name'),
                          trailing: const Text('Expense Tracker'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
