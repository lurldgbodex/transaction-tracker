import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_tracker/models/transaction_filter.dart';

import '../db/db_service.dart';
import '../models/transaction.dart';
import 'filter_provider.dart';

class TransactionNotifier extends AsyncNotifier<List<TransactionModel>> {
  final DbService _dbService = DbService();

  @override
  Future<List<TransactionModel>> build() async {
    return await _fetchTransaction();
  }

  Future<List<TransactionModel>> _fetchTransaction() async {
    final transactions = await _dbService.getTransactionsWithCategory();
    return transactions.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    state = await AsyncValue.guard(() async {
      await _dbService.insertTransaction(tx);
      return await _fetchTransaction();
    });
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    state = await AsyncValue.guard(() async {
      await _dbService.updateTransaction(tx);

      return await _fetchTransaction();
    });
  }

  Future<void> deleteTransaction(int id) async {
    state = await AsyncValue.guard(() async {
      await _dbService.deleteTransaction(id);

      return await _fetchTransaction();
    });
  }

  Future<void> restoreTransaction(TransactionModel tx) async {
    state = await AsyncValue.guard(() async {
      await _dbService.insertTransaction(tx);

      return await _fetchTransaction();
    });
  }

  double get totalExpense => (state.value ?? [])
      .where((tx) => tx.type == "expense")
      .fold(0.0, (sum, tx) => sum + tx.amount);

  double get totalIncome => (state.value ?? [])
      .where((tx) => tx.type == "income")
      .fold(0.0, (sum, tx) => sum + tx.amount);

  double get balance => totalIncome - totalExpense;
}

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, List<TransactionModel>>(
      TransactionNotifier.new,
    );

final filteredTransactionProvider =
    Provider<AsyncValue<List<TransactionModel>>>((ref) {
      final transactions = ref.watch(transactionProvider);
      final filter = ref.watch(filterProvider);

      return transactions.when(
        data: (transactions) {
          final filtered = _applyFilters(transactions, filter);
          return AsyncValue.data(filtered);
        },
        loading: () => const AsyncValue.loading(),
        error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
      );
    });

final allTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(transactionProvider).value ?? [];
  return transactions;
});

final incomeTransactionProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(transactionProvider).value ?? [];
  return transactions.where((tx) => tx.type == 'income').toList();
});

final expenseTransactionProvider = Provider<List<TransactionModel>>((ref) {
  final transactions = ref.watch(transactionProvider).value ?? [];
  return transactions.where((tx) => tx.type == 'expense').toList();
});

List<TransactionModel> _applyFilters(
  List<TransactionModel> transactions,
  TransactionFilter filter,
) {
  return transactions.where((tx) {
    if (filter.type != 'all' && tx.type != filter.type) {
      return false;
    }
    if (filter.categoryId != null && tx.categoryId != filter.categoryId) {
      return false;
    }
    if (filter.dateRange != null && tx.date.isBefore(filter.dateRange!.start)) {
      return false;
    }
    if (filter.dateRange != null && tx.date.isAfter(filter.dateRange!.end)) {
      return false;
    }
    return true;
  }).toList();
}
