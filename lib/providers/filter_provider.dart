import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction_filter.dart';

class FilterNotifier extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() => const TransactionFilter();

  void setType(String type) {
    state = state.copyWith(type: type, categoryId: null);
  }

  void setCategory(int? categoryId) {
    state = state.copyWith(type: "all", categoryId: categoryId);
  }

  void setDateRange(DateTimeRange? dateRange) {
    state = state.copyWith(dateRange: dateRange);
  }

  void clearFilter(String filterLabel) {
    if (filterLabel == "Type") {
      state = state.copyWith(type: "all", categoryId: null);
    } else if (filterLabel == "Category") {
      state = state.copyWith(categoryId: null);
    } else if (filterLabel == "Date") {
      state = state.copyWith(dateRange: null);
    }
  }

  void reset() {
    state = const TransactionFilter();
  }
}

final filterProvider = NotifierProvider<FilterNotifier, TransactionFilter>(
  FilterNotifier.new,
);

final activeFilterProvider = Provider<List<String>>((ref) {
  return ref.watch(filterProvider).activeFilters;
});
