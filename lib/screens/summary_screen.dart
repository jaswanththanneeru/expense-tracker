import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/expense_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.expenses.isEmpty) {
            return const Center(
              child: Text('No data to show.\nAdd some expenses.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 18)),
            );
          }

          Map<String, double> categoryTotals = {};
          for (var exp in provider.expenses) {
            categoryTotals[exp.category] = (categoryTotals[exp.category] ?? 0) + exp.amount;
          }

          List<PieChartSectionData> pieChartSections = [];
          List<Color> colors = [const Color(0xFF00E676), const Color(0xFF651FFF), Colors.orange, Colors.blue, Colors.pink, Colors.teal];

          int colorIndex = 0;
          categoryTotals.forEach((category, total) {
            pieChartSections.add(
              PieChartSectionData(
                color: colors[colorIndex % colors.length],
                value: total,
                title: '${((total / provider.totalExpense) * 100).toStringAsFixed(0)}%',
                radius: 50,
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            );
            colorIndex++;
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E24),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: pieChartSections,
                            centerSpaceRadius: 60,
                            sectionsSpace: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Total: ₹ ${provider.totalExpense.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00E676))),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Align(alignment: Alignment.centerLeft, child: Text('Category Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoryTotals.length,
                  itemBuilder: (context, index) {
                    String category = categoryTotals.keys.elementAt(index);
                    double amount = categoryTotals[category]!;
                    return Card(
                      color: const Color(0xFF1E1E24),
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colors[index % colors.length].withValues(alpha: 0.2),
                          child: Icon(Icons.pie_chart, color: colors[index % colors.length]),
                        ),
                        title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text('₹ ${amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}