import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';
import '../providers/category_provider.dart';
import '../utils/category_dialog.dart';

class CategoryDropDown extends ConsumerWidget {
  final Category? selectedCategory;
  final ValueChanged<Category> onCategoryChanged;

  const CategoryDropDown({
    super.key,
    this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField(
          initialValue: selectedCategory?.id,
          hint: const Text("Select category"),
          items: categories
              .map(
                (cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name)),
              )
              .toList(),
          onChanged: (value) async {
            if (value != null) {
              final selected = categories.firstWhere(
                (cat) => cat.id == value,
                orElse: () => categories.first,
              );
              onCategoryChanged(selected);
            }
          },
          decoration: const InputDecoration(
            labelText: "Category",
            prefixIcon: Icon(Icons.category_outlined),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () async {
            final newCategory = await showAddCategoryDialog(context, ref);

            if (newCategory != null) {
              onCategoryChanged(newCategory);
            }
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text("Add New Category"),
        ),
      ],
    );
  }
}
