import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class BalanceLine extends StatelessWidget {
  final List<TransactionModel> transactions;

  const BalanceLine({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    double runningBalance = 0;
    final spots = <FlSpot>[];

    final sorted = transactions.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    for (int i = 0; i < sorted.length; i++) {
      final tx = sorted[i];
      runningBalance += tx.type == 'income' ? tx.amount : -tx.amount;
      spots.add(FlSpot(i.toDouble(), runningBalance));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
