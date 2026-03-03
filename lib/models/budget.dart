import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 2)
class Budget extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String categoryId;

  @HiveField(2)
  String categoryName;

  @HiveField(3)
  double amount;

  @HiveField(4)
  String period; // 'monthly' or 'yearly'

  @HiveField(5)
  int month; // 1-12 for monthly budgets

  @HiveField(6)
  int year;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  @HiveField(9)
  bool isGlobal; // true for total monthly budget, false for category-wise

  Budget({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.period,
    required this.month,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
    this.isGlobal = false,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      period: json['period'] ?? 'monthly',
      month: json['month'] ?? 1,
      year: json['year'] ?? 2024,
      createdAt: json['createdAt'] is DateTime 
          ? json['createdAt'] 
          : DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: json['updatedAt'] is DateTime 
          ? json['updatedAt'] 
          : DateTime.parse(json['updatedAt'] ?? ''),
      isGlobal: json['isGlobal'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'period': period,
      'month': month,
      'year': year,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isGlobal': isGlobal,
    };
  }

  Budget copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    double? amount,
    String? period,
    int? month,
    int? year,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isGlobal,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      month: month ?? this.month,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isGlobal: isGlobal ?? this.isGlobal,
    );
  }
}
