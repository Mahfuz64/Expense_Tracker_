import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String type; // 'income' or 'expense'

  @HiveField(3)
  String categoryId;

  @HiveField(4)
  String categoryName;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  String? note;

  @HiveField(7)
  String? receiptImagePath;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  @HiveField(10)
  String? categoryIcon;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.date,
    this.note,
    this.receiptImagePath,
    required this.createdAt,
    required this.updatedAt,
    this.categoryIcon,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? 'expense',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      date: json['date'] is DateTime ? json['date'] : DateTime.parse(json['date'] ?? ''),
      note: json['note'],
      receiptImagePath: json['receiptImagePath'],
      createdAt: json['createdAt'] is DateTime ? json['createdAt'] : DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: json['updatedAt'] is DateTime ? json['updatedAt'] : DateTime.parse(json['updatedAt'] ?? ''),
      categoryIcon: json['categoryIcon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'date': date.toIso8601String(),
      'note': note,
      'receiptImagePath': receiptImagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'categoryIcon': categoryIcon,
    };
  }

  Transaction copyWith({
    String? id,
    double? amount,
    String? type,
    String? categoryId,
    String? categoryName,
    DateTime? date,
    String? note,
    String? receiptImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? categoryIcon,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      date: date ?? this.date,
      note: note ?? this.note,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryIcon: categoryIcon ?? this.categoryIcon,
    );
  }
}
