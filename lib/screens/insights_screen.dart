import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import '../widgets/balance_line.dart';
import '../widgets/category_pie.dart';
import '../widgets/monthly_bar.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Insights'), centerTitle: true),
      body: asyncTransactions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            const Center(child: Text("Error loading Insights")),
        data: (transactions) {
          return transactions.isEmpty
              ? const Center(child: Text("No data for insights"))
              : DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(text: "By Category"),
                          Tab(text: "Monthly"),
                          Tab(text: "Balance"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            CategoryPie(transactions: transactions),
                            MonthlyBar(transactions: transactions),
                            BalanceLine(transactions: transactions),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
