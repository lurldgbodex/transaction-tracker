import 'package:flutter/material.dart';

class TransactionFilter {
  final String type;
  final int? categoryId;
  final DateTimeRange? dateRange;

  const TransactionFilter({this.type = "all", this.categoryId, this.dateRange});

  TransactionFilter copyWith({
    String? type,
    int? categoryId,
    DateTimeRange? dateRange,
  }) {
    return TransactionFilter(
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  List<String> get activeFilters {
    final filters = <String>[];
    if (type != "all") {
      filters.add(type);
    }
    if (categoryId != null) {
      filters.add("Category");
    }
    if (dateRange != null) {
      filters.add(
        "Date: ${dateRange!.start.toLocal()} - ${dateRange!.end.toLocal()}",
      );
    }
    return filters;
  }
}
