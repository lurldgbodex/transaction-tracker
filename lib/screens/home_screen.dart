import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import '../screens/add_transaction_screen.dart';
import '../widgets/transaction_summary_card.dart';
import '../widgets/transaction_list.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
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

            final totalExpense = transactions
                .where((tx) => tx.type == 'expense')
                .fold(0.0, (sum, tx) => sum + tx.amount);
            final totalIncome = transactions
                .where((tx) => tx.type == 'income')
                .fold(0.0, (sum, tx) => sum + tx.amount);

            final balance = totalIncome - totalExpense;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TransactionSummaryCard(
                  title: "Balance",
                  value: balance,
                  valueColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TransactionSummaryCard(
                        title: "Income",
                        value: totalIncome,
                        valueColor: Colors.green.shade400,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TransactionSummaryCard(
                        title: "Expense",
                        value: totalExpense,
                        valueColor: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(child: TransactionList(transactions: transactions)),
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
