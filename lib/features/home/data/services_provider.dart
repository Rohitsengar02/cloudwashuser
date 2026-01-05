import 'package:cloud_user/core/models/service_model.dart';
import 'package:cloud_user/features/home/data/home_repository.dart';
import 'package:cloud_user/core/network/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'services_provider.g.dart';

@riverpod
Future<List<ServiceModel>> services(
  ServicesRef ref, {
  String? categoryId,
  String? subCategoryId,
}) async {
  final dio = ref.watch(apiClientProvider);
  final queryMap = <String, dynamic>{};
  if (categoryId != null) queryMap['categoryId'] = categoryId;
  if (subCategoryId != null) queryMap['subCategoryId'] = subCategoryId;

  try {
    final response = await dio.get('/services', queryParameters: queryMap);
    final data = response.data as List;
    return data.map((e) => ServiceModel.fromJson(e)).toList();
  } catch (e) {
    // Return empty list on error for now or rethrow
    return [];
  }
}
