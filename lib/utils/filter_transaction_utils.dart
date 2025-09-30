import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
import '../providers/filter_provider.dart';
import '../widgets/transaction_list.dart';

class FilterTransactionUtil {
  static Widget getDisplayTransaction(
    List<TransactionModel> transactions,
    String message,
    WidgetRef ref,
  ) {
    if (transactions.isEmpty) {
      return Center(child: Text(message));
    }
    return TransactionList(transactions: _buildTransactions(transactions, ref));
  }

  static List<TransactionModel> _buildTransactions(
    List<TransactionModel> baseTransactions,
    WidgetRef ref,
  ) {
    final filter = ref.watch(filterProvider);

    if (filter.categoryId == null && filter.dateRange == null) {
      return baseTransactions;
    }

    return baseTransactions.where((tx) {
      if (filter.categoryId != null && tx.categoryId != filter.categoryId) {
        return false;
      }
      if (filter.dateRange != null &&
          tx.date.isBefore(filter.dateRange!.start)) {
        return false;
      }
      return true;
    }).toList();
  }
}
