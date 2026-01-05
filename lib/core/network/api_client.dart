import 'package:cloud_user/core/config/app_config.dart';
import 'package:cloud_user/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
Dio apiClient(ApiClientRef ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        if (kDebugMode) {
          print('🌐 [${options.method}] ${options.uri}');
          if (options.data != null) print('📦 Data: ${options.data}');
        }
        
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('✅ [${response.statusCode}] ${response.requestOptions.uri}');
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        if (kDebugMode) {
          print('❌ [${error.response?.statusCode}] ${error.requestOptions.uri}');
          print('❌ Error: ${error.message}');
          print('❌ Response: ${error.response?.data}');
        }
        
        // Handle 401 Unauthorized (optional: trigger logout)
        if (error.response?.statusCode == 401) {
          // You might want to clear token here or notify auth state
        }
        
        return handler.next(error);
      },
    ),
  );

  return dio;
}
