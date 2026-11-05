import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _expenses = [];
  final String _storageKey = 'expense_data_list';

  List<Expense> get expenses => _expenses;
  double get totalExpense => _expenses.fold(0, (sum, item) => sum + item.amount);

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      final List<dynamic> decodedData = jsonDecode(data);
      _expenses.clear();
      for (var item in decodedData) {
        _expenses.add(Expense.fromMap(item));
      }
      notifyListeners();
    }
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_expenses.map((e) => e.toMap()).toList());
    await prefs.setString(_storageKey, encodedData);
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpenses();
    notifyListeners();
  }
}