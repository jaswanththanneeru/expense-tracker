import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseStorageService {
  static const String _storageKey = 'fintrack_expense_data';

  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data == null || data.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(data) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => Expense.fromJson(item))
          .toList();
    } catch (_) {
      // Malformed JSON — return empty list rather than crash
      return [];
    }
  }

  Future<bool> saveExpenses(List<Expense> expenses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(
        expenses.map((e) => e.toJson()).toList(),
      );
      return await prefs.setString(_storageKey, encoded);
    } catch (_) {
      return false;
    }
  }
}
