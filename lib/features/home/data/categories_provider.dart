import 'package:cloud_user/core/models/category_model.dart';
import 'package:cloud_user/core/network/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

@riverpod
Future<List<CategoryModel>> categories(CategoriesRef ref) async {
  final dio = ref.watch(apiClientProvider);

  try {
    final response = await dio.get('/categories');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      final categories = data
          .map((json) => CategoryModel.fromJson(json))
          .toList();
      // Return only first 6 categories for home page
      return categories.take(6).toList();
    }

    return [];
  } catch (e) {
    print('❌ Error fetching categories: $e');
    return [];
  }
}
