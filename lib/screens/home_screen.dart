import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import '../screens/add_transaction_screen.dart';
import '../widgets/transaction_summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(transactionProvider);
    final notifier = ref.read(transactionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: asyncTransactions.when(
          error: (err, stack) {
            return Center(child: Text("Error: An unexpected error occurred"));
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Center(child: Text("No transactions yet"));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TransactionSummaryCard(
                  title: "Balance",
                  value: notifier.balance,
                  valueColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TransactionSummaryCard(
                        title: "Income",
                        value: notifier.totalIncome,
                        valueColor: Colors.green.shade400,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TransactionSummaryCard(
                        title: "Expense",
                        value: notifier.totalExpense,
                        valueColor: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
