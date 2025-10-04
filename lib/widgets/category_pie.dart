import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_tracker/providers/currency_provider.dart';

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

    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

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
      final percent = (data.value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value,
        title: "${data.key}\n$percent%",
        radius: 55,
        color: colors[index % colors.length],
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      );
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 380,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 100,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: categoryTotals.entries.toList().asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final data = entry.value;

              return Container(
                width: 250,
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: colors[index % colors.length],
                    ),
                    const SizedBox(width: 4),
                    Consumer(
                      builder: (context, ref, _) {
                        final currencyCode = ref.watch(currencyProvider);
                        return Expanded(
                          child: Text(
                            "${data.key}: ${CurrencyUtils.formatAmount(data.value, currencyCode: currencyCode)}",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
