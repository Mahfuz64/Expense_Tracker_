import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon;

  @HiveField(3)
  int colorValue;

  @HiveField(4)
  bool isDefault;

  @HiveField(5)
  String type; 
  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    this.isDefault = false,
    required this.type,
  });

  Color get color => Color(colorValue);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '📁',
      colorValue: json['colorValue'] ?? Colors.blue.value,
      isDefault: json['isDefault'] ?? false,
      type: json['type'] ?? 'expense',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'colorValue': colorValue,
      'isDefault': isDefault,
      'type': type,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    int? colorValue,
    bool? isDefault,
    String? type,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      isDefault: isDefault ?? this.isDefault,
      type: type ?? this.type,
    );
  }
}
