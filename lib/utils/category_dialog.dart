import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';
import '../providers/category_provider.dart';

Future<Category?> showAddCategoryDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final nameController = TextEditingController();
  final navigator = Navigator.of(context);
  String type = "expense";

  final notifier = ref.read(categoryProvider.notifier);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Category name"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              initialValue: type,
              items: const [
                DropdownMenuItem(value: "expense", child: Text("Expense")),
                DropdownMenuItem(value: "income", child: Text("Income")),
              ],
              onChanged: (value) {
                type = value ?? "expense";
              },
              decoration: const InputDecoration(labelText: "Type"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final category = Category(
                name: nameController.text.trim(),
                type: type,
              );
              Category newCategory = await notifier.addCategory(category);
              navigator.pop(newCategory);
            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );
}
