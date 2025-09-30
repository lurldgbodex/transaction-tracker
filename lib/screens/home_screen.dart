import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/filter_provider.dart';
import '../providers/transaction_provider.dart';
import '../screens/add_transaction_screen.dart';
import '../utils/filter_transaction_utils.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/transaction_summary_card.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(transactionProvider);
    final allTransactions = ref.watch(allTransactionsProvider);
    final incomeTransactions = ref.watch(incomeTransactionProvider);
    final expenseTransactions = ref.watch(expenseTransactionProvider);
    final activeFilters = ref.watch(activeFilterProvider);

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
                  if (activeFilters.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final filter in activeFilters)
                          Chip(
                            shape: LinearBorder.none,
                            label: Text(
                              filter.displayName,
                              style: TextStyle(color: Colors.grey),
                            ),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () {
                              ref
                                  .read(filterProvider.notifier)
                                  .clearFilter(filter.type);
                            },
                          ),
                        ActionChip(
                          shape: LinearBorder.none,
                          label: const Text(
                            'Clear all',
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () {
                            ref.read(filterProvider.notifier).reset();
                          },
                        ),
                      ],
                    ),
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
                        FilterTransactionUtil.getDisplayTransaction(
                          allTransactions,
                          "No transactions yet",
                          ref,
                        ),
                        FilterTransactionUtil.getDisplayTransaction(
                          incomeTransactions,
                          "No income transactions yet",
                          ref,
                        ),
                        FilterTransactionUtil.getDisplayTransaction(
                          expenseTransactions,
                          "No expense transactions yet",
                          ref,
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
}
