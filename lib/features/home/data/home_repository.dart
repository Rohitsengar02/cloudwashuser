import 'package:cloud_user/core/models/category_model.dart';
import 'package:cloud_user/core/models/service_model.dart';
import 'package:cloud_user/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@Riverpod(keepAlive: true)
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository(ref.watch(apiClientProvider));
}

class HomeRepository {
  final Dio _dio;

  HomeRepository(this._dio);

  Future<List<CategoryModel>> getCategories() async {
    try {
      // Logic from APIService: apiClient.get('/content/categories')
      final response = await _dio.get('/content/categories');

      // Assuming response.data is List or { data: List }
      final data = response.data['data'] as List;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      // Return Mock Data if API fails (for development)
      return [
        CategoryModel(
          id: '1',
          name: 'Laundry',
          description: 'Professional laundry service',
          price: 0,
          imageUrl: 'https://via.placeholder.com/150',
        ),
        CategoryModel(
          id: '2',
          name: 'Dry Cleaning',
          description: 'Expert dry cleaning',
          price: 0,
          imageUrl: 'https://via.placeholder.com/150',
        ),
        CategoryModel(
          id: '3',
          name: 'Shoe Cleaning',
          description: 'Shoe care service',
          price: 0,
          imageUrl: 'https://via.placeholder.com/150',
        ),
        CategoryModel(
          id: '4',
          name: 'Leather Cleaning',
          description: 'Leather care',
          price: 0,
          imageUrl: 'https://via.placeholder.com/150',
        ),
        CategoryModel(
          id: '5',
          name: 'Curtain Cleaning',
          description: 'Curtain cleaning',
          price: 0,
          imageUrl: 'https://via.placeholder.com/150',
        ),
        CategoryModel(
          id: '6',
          name: 'Carpet Cleaning',
          description: 'Carpet deep clean',
          price: 0,
          imageUrl: 'https://via.placeholder.com/150',
        ),
      ];
    }
  }

  Future<List<ServiceModel>> getPopularServices() async {
    try {
      final response = await _dio.get('/services?popular=true');
      final data = response.data['data'] as List;
      return data.map((e) => ServiceModel.fromJson(e)).toList();
    } catch (e) {
      return [
        ServiceModel(
          id: '1',
          title: 'Wash & Fold',
          price: 49,
          category: 'Laundry',
          rating: 4.8,
          reviewCount: 120,
          image: 'https://cdn-icons-png.flaticon.com/512/3003/3003984.png',
        ),
        ServiceModel(
          id: '2',
          title: 'Premium Dry Clean',
          price: 149,
          category: 'Dry Cleaning',
          rating: 4.9,
          reviewCount: 215,
          image: 'https://cdn-icons-png.flaticon.com/512/2954/2954835.png',
        ),
      ];
    }
  }
}
