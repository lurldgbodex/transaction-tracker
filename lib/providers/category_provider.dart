import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db_service.dart';
import '../models/category.dart';

final categoryProvider = NotifierProvider<CategoryNotifier, List<Category>>(
  CategoryNotifier.new,
);

class CategoryNotifier extends Notifier<List<Category>> {
  final DbService _dbService = DbService();

  @override
  List<Category> build() {
    _fetchCategory();
    return [];
  }

  Future<void> _fetchCategory() async {
    final categories = await _dbService.getCategories();
    state = categories;
  }

  Future<Category> addCategory(Category category) async {
    final id = await _dbService.insertCategory(category);
    final newCategory = category.copyWith(id: id);
    await _fetchCategory();

    return newCategory;
  }

  Future<void> deleteCategories(int id) async {
    await _dbService.deleteCategory(id);
    await _fetchCategory();
  }
}
