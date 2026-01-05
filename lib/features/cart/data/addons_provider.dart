import 'package:cloud_user/core/models/addon_model.dart';
import 'package:cloud_user/core/network/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'addons_provider.g.dart';

@riverpod
Future<List<AddonModel>> addons(AddonsRef ref) async {
  final dio = ref.watch(apiClientProvider);
  try {
    final response = await dio.get('/addons');
    final data = response.data as List;
    return data.map((e) => AddonModel.fromJson(e)).toList();
  } catch (e) {
    return [];
  }
}
