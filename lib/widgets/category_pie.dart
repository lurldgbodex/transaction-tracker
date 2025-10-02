import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../utils/currency_utils.dart';

class CategoryPie extends StatelessWidget {
  final List<TransactionModel> transactions;

  const CategoryPie({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final expenses = transactions.where((tx) => tx.type == 'expense');
    final categoryTotals = <String, double>{};

    for (final tx in expenses) {
      categoryTotals[tx.categoryName ?? 'Other'] =
          (categoryTotals[tx.categoryName ?? 'Other'] ?? 0) + tx.amount;
    }

    if (categoryTotals.isEmpty) {
      return const Center(child: Text("No expense data available"));
    }

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    final sections = categoryTotals.entries.toList().asMap().entries.map((
      entry,
    ) {
      final index = entry.key;
      final data = entry.value;

      return PieChartSectionData(
        value: data.value,
        title: "${data.key}\n${CurrencyUtils.formatAmount(data.value)}",
        radius: 70,
        color: colors[index % colors.length],
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(PieChartData(sections: sections, sectionsSpace: 2)),
    );
  }
}
