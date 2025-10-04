import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_provider.dart';
import '../utils/category_dialog.dart';
import '../widgets/navigate_back.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final notifier = ref.read(categoryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Categories"),
        centerTitle: true,
        leading: const NavigateBack(),
      ),
      body: categories.isEmpty
          ? const Center(child: Text("No categories yet"))
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return ListTile(
                  title: Text(category.name),
                  subtitle: Text(category.type),
                  trailing: IconButton(
                    onPressed: () => notifier.deleteCategories(category.id!),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showAddCategoryDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
