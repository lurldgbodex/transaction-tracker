import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db_service.dart';
import '../models/transaction.dart';

class TransactionNotifier extends AsyncNotifier<List<TransactionModel>> {
  final DbService _dbService = DbService();

  @override
  Future<List<TransactionModel>> build() async {
    return await _dbService.getTransactions();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    state = const AsyncValue.loading();
    await _dbService.insertTransaction(tx);

    await refreshTransactions();
  }

  Future<void> refreshTransactions() async {
    state = const AsyncValue.loading();
    final transactions = await _dbService.getTransactions();
    state = AsyncValue.data(transactions);
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
