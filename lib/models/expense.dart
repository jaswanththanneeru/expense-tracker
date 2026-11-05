import 'package:flutter/material.dart';

class Expense {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  // Provider lo save cheyataniki
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  // Provider nunchi load cheyataniki
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(), // Safe conversion
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      note: (map['note'] as String?) ?? '',
    );
  }

  // Category batti manchi icons chupinchadaniki (Premium Touch)
  static IconData iconForCategory(String category) {
    switch (category) {
      case 'Food': return Icons.restaurant_rounded;
      case 'Travel': return Icons.flight_rounded;
      case 'Shopping': return Icons.shopping_bag_rounded;
      case 'Bills': return Icons.receipt_long_rounded;
      case 'Entertainment': return Icons.movie_rounded;
      case 'Other': return Icons.more_horiz_rounded;
      default: return Icons.attach_money_rounded;
    }
  }

  static const List<String> categories = [
    'Food', 
    'Travel', 
    'Shopping', 
    'Bills', 
    'Entertainment', 
    'Other'
  ];
}