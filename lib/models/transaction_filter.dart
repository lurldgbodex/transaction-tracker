import 'package:flutter/material.dart';

import '../utils/filter_util.dart';

class TransactionFilter {
  final String type;
  final int? categoryId;
  final DateTimeRange? dateRange;

  const TransactionFilter({this.type = "all", this.categoryId, this.dateRange});

  TransactionFilter copyWith({
    String? type,
    Optional<int>? categoryId,
    Optional<DateTimeRange>? dateRange,
  }) {
    return TransactionFilter(
      type: type ?? this.type,
      categoryId: categoryId != null ? categoryId.value : this.categoryId,
      dateRange: dateRange != null ? dateRange.value : this.dateRange,
    );
  }
}
