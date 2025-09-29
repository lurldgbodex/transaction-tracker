import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../screens/add_transaction_screen.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/transaction_summary_card.dart';
import '../widgets/transaction_list.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(transactionProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text("Expense Tracker"),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) => SafeArea(child: TransactionFilterSheet()),
                );
              },
              icon: const Icon(Icons.filter_list),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.15),
            ),
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Income'),
              Tab(text: 'Expense'),
            ],
          ),
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
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildTransactionList(
                          transactions,
                          message: "No transactions yet",
                        ),
                        _buildTransactionList(
                          transactions
                              .where((tx) => tx.type == 'income')
                              .toList(),
                          message: "No income transactions yet",
                        ),
                        _buildTransactionList(
                          transactions
                              .where((tx) => tx.type == 'expense')
                              .toList(),
                          message: "No expense transactions yet",
                        ),
                      ],
                    ),
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
      ),
    );
  }

  Widget _buildTransactionList(
    List<TransactionModel> transactions, {
    required String message,
  }) {
    if (transactions.isEmpty) {
      return Center(child: Text(message));
    }
    return TransactionList(transactions: transactions);
  }
}
