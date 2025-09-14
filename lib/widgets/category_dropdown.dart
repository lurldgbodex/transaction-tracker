import 'package:flutter/material.dart';

class CategoryDropDown extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;

  const CategoryDropDown({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      initialValue: selectedCategory,
      items: categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onCategoryChanged(value);
        }
      },
      decoration: const InputDecoration(
        labelText: "Category",
        prefixIcon: Icon(Icons.category),
      ),
    );
  }
}
