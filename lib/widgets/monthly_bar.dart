import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class MonthlyBar extends StatelessWidget {
  final List<TransactionModel> transactions;

  const MonthlyBar({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final monthly = <int, Map<String, double>>{};

    for (var tx in transactions) {
      final month = tx.date.month;
      monthly[month] ??= {"income": 0, "expense": 0};
      monthly[month]![tx.type] = (monthly[month]![tx.type] ?? 0) + tx.amount;
    }

    if (monthly.isEmpty) {
      return const Center(child: Text("No monthly data available"));
    }

    final barGroups = <BarChartGroupData>[];
    final months = monthly.keys.toList()..sort();
    int i = 0;
    for (var entry in monthly.entries) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: entry.value['income'] ?? 0,
              color: Colors.green,
              width: 10,
            ),
            BarChartRodData(
              toY: entry.value['expense'] ?? 0,
              color: Colors.red,
              width: 10,
            ),
          ],
          barsSpace: 6,
        ),
      );
      i++;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value < 0 || value >= months.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    months[value.toInt()].toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
