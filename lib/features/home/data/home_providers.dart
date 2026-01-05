import 'package:cloud_user/core/models/category_model.dart';
import 'package:cloud_user/features/home/data/categories_provider.dart';
import 'package:cloud_user/features/home/data/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
Future<List<CategoryModel>> categories(CategoriesRef ref) {
  return ref.watch(homeRepositoryProvider).getCategories();
}

// TODO: Services Provider
