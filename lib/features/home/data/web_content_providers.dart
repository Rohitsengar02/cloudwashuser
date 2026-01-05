import 'package:cloud_user/core/network/api_client.dart';
import 'package:cloud_user/features/home/data/about_us_model.dart';
import 'package:cloud_user/features/home/data/stats_model.dart';
import 'package:cloud_user/features/home/data/testimonial_model.dart';
import 'package:cloud_user/features/home/data/why_choose_us_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'web_content_providers.g.dart';

@riverpod
Future<AboutUsModel?> aboutUs(AboutUsRef ref) async {
  final dio = ref.watch(apiClientProvider);
  try {
    final response = await dio.get('/web-content/about');
    return AboutUsModel.fromJson(response.data);
  } catch (e) {
    return null;
  }
}

@riverpod
Future<StatsModel?> stats(StatsRef ref) async {
  final dio = ref.watch(apiClientProvider);
  try {
    final response = await dio.get('/web-content/stats');
    return StatsModel.fromJson(response.data);
  } catch (e) {
    return null;
  }
}

@riverpod
Future<List<TestimonialModel>> testimonials(TestimonialsRef ref) async {
  final dio = ref.watch(apiClientProvider);
  try {
    final response = await dio.get('/testimonials');
    final List data = response.data;
    return data.map((e) => TestimonialModel.fromJson(e)).toList();
  } catch (e) {
    return [];
  }
}

@riverpod
Future<List<WhyChooseUsModel>> whyChooseUs(WhyChooseUsRef ref) async {
  final dio = ref.watch(apiClientProvider);
  try {
    final response = await dio.get('/why-choose-us');
    final List data = response.data;
    return data.map((e) => WhyChooseUsModel.fromJson(e)).toList();
  } catch (e) {
    return [];
  }
}
