import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db_service.dart';
import '../models/transaction.dart';

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, List<TransactionModel>>(
      TransactionNotifier.new,
    );

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
