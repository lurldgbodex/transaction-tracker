import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_tracker/providers/category_provider.dart';
import 'package:project_tracker/providers/filter_provider.dart';

class TransactionFilterSheet extends ConsumerWidget {
  const TransactionFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final categories = ref.watch(categoryProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        runSpacing: 20,
        children: [
          Center(
            child: Text(
              "Filter Transactions",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Type"),
              DropdownButton(
                value: filter.type,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(filterProvider.notifier).setType(value);
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Category"),
              DropdownButton(
                value: filter.categoryId,
                hint: const Text('All'),
                items: [
                  DropdownMenuItem(value: null, child: Text('All')),
                  ...categories.map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ),
                ],
                onChanged: (value) {
                  ref.read(filterProvider.notifier).setCategory(value);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Date"),
              TextButton(
                onPressed: () async {
                  final dateRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now(),
                  );
                  ref.read(filterProvider.notifier).setDateRange(dateRange);
                },
                child: const Text("Select Date"),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                ref.read(filterProvider.notifier).reset();
              },
              icon: const Icon(Icons.clear),
              label: const Text("Reset"),
            ),
          ),
        ],
      ),
    );
  }
}
