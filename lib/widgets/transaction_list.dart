import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_tracker/providers/transaction_provider.dart';

import '../models/transaction.dart';
import '../providers/currency_provider.dart';
import '../utils/currency_utils.dart';
import 'edit_transaction_dialog.dart';

class TransactionList extends ConsumerWidget {
  final List<TransactionModel> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(transactionProvider.notifier);

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isIncome = tx.type == 'income';

        return GestureDetector(
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (ctx) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text("Edit"),
                      onTap: () {
                        Navigator.pop(ctx);
                        showDialog(
                          context: context,
                          builder: (_) => EditTransactionDialog(
                            transaction: tx,
                            onSave: (updatedTx) async {
                              await notifier.updateTransaction(updatedTx);
                            },
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text('Delete'),
                      onTap: () async {
                        Navigator.pop(ctx);
                        await notifier.deleteTransaction(tx.id!);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Dismissible(
            key: ValueKey(tx.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Delete Transaction"),
                  content: const Text(
                    "Are you sure you want to delete this transaction?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) async {
              final messenger = ScaffoldMessenger.of(context);
              final deletedTx = tx;

              await notifier.deleteTransaction(tx.id!);
              messenger.showSnackBar(
                SnackBar(
                  content: Text("Deleted ${tx.type} - \$${tx.amount}"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () async {
                      await notifier.restoreTransaction(deletedTx);
                    },
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isIncome
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(
                  tx.note.isNotEmpty
                      ? tx.note
                      : tx.categoryName ?? "No Category",
                ),
                subtitle: Text(
                  "${tx.type}  •  ${tx.date.toLocal().toString().split(' ')[0]}",
                ),
                trailing: Consumer(
                  builder: (context, ref, _) {
                    final currencyCode = ref.watch(currencyProvider);
                    return Text(
                      CurrencyUtils.formatAmount(
                        tx.amount,
                        currencyCode: currencyCode,
                      ),
                      style: TextStyle(
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
