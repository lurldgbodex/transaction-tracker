import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/active_filter.dart';
import '../models/transaction_filter.dart';
import '../utils/filter_util.dart';
import 'category_provider.dart';

class FilterNotifier extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() => const TransactionFilter();

  void setType(String type) {
    state = state.copyWith(type: type);
  }

  void setCategory(int? categoryId) {
    state = state.copyWith(categoryId: Optional.value(categoryId!));
  }

  void setDateRange(DateTimeRange? dateRange) {
    state = state.copyWith(dateRange: Optional.value(dateRange!));
  }

  void clearFilter(String filterLabel) {
    if (filterLabel == "Type") {
      state = state.copyWith(type: "all");
    } else if (filterLabel == "Category") {
      state = state.copyWith(categoryId: const Optional.absent());
    } else if (filterLabel == "Date") {
      state = state.copyWith(dateRange: const Optional.absent());
    }
  }

  void reset() {
    state = const TransactionFilter();
  }
}

final filterProvider = NotifierProvider<FilterNotifier, TransactionFilter>(
  FilterNotifier.new,
);

final activeFilterProvider = Provider<List<ActiveFilter>>((ref) {
  final filter = ref.watch(filterProvider);
  final categories = ref.watch(categoryProvider);

  final activeFilters = <ActiveFilter>[];

  if (filter.type != "all") {
    activeFilters.add(
      ActiveFilter(type: "Type", displayName: filter.type, value: filter.type),
    );
  }

  if (filter.categoryId != null) {
    try {
      final category = categories.firstWhere(
        (cat) => cat.id == filter.categoryId,
      );
      activeFilters.add(
        ActiveFilter(
          type: "Category",
          displayName: category.name,
          value: category.id,
        ),
      );
    } catch (e) {
      activeFilters.add(
        ActiveFilter(
          type: "Category",
          displayName: 'Category: Unknown',
          value: filter.categoryId.toString(),
        ),
      );
    }
  }

  if (filter.dateRange != null) {
    final dateRange = filter.dateRange!;
    activeFilters.add(
      ActiveFilter(
        type: 'Date',
        displayName:
            "Date: ${_formatDate(dateRange.start)} - ${_formatDate(dateRange.end)}",
        value: filter.dateRange,
      ),
    );
  }

  return activeFilters;
});

String _formatDate(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}
