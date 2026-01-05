import 'package:cloud_user/core/network/api_client.dart';
import 'package:cloud_user/features/home/data/sub_category_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sub_categories_provider.g.dart';

@riverpod
Future<List<SubCategoryModel>> subCategoriesByCategory(
  SubCategoriesByCategoryRef ref,
  String categoryId,
) async {
  final dio = ref.watch(apiClientProvider);
  try {
    final response = await dio.get(
      '/sub-categories',
      queryParameters: {'categoryId': categoryId},
    );
    final List data = response.data;
    // Filter out inactive items if needed, though backend often sends all unless filtered there
    // We assume backend sends active ones or we filter here.
    // Actually backend sends all. We should show only active on user side.
    return data
        .map((e) => SubCategoryModel.fromJson(e))
        .where((item) => item.isActive)
        .toList();
  } catch (e) {
    return [];
  }
}
