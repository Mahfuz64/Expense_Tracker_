import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../services/database_service.dart';

class BackupService {
  static Future<String> createBackup() async {
    final db = DatabaseService();
    final data = await db.exportData();
    
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${dir.path}/backups');
    
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${backupDir.path}/backup_$timestamp.json');

    final jsonString = jsonEncode(data);
    await file.writeAsString(jsonString);

    return file.path;
  }

  static Future<void> restoreBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Backup file not found');
      }

      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString);

      final db = DatabaseService();
      await db.importData(data);
    } catch (e) {
      throw Exception('Failed to restore backup: $e');
    }
  }

  static Future<List<FileSystemEntity>> getBackupList() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${dir.path}/backups');

      if (!await backupDir.exists()) {
        return [];
      }

      return backupDir.listSync();
    } catch (e) {
      return [];
    }
  }

  static Future<void> deleteBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete backup: $e');
    }
  }

  static Future<String> getBackupFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return '0 KB';
      }

      final sizeInBytes = await file.length();
      return _formatFileSize(sizeInBytes);
    } catch (e) {
      return 'Unknown';
    }
  }

  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
