import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_user/core/network/api_client.dart';

final notificationRepositoryProvider = Provider((ref) {
  return NotificationRepository(ref.watch(apiClientProvider));
});

class NotificationRepository {
  final Dio _dio;

  NotificationRepository(this._dio);

  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await _dio.get('notifications');
      return (response.data as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Notification Fetch Error: $e');
      return [];
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _dio.patch('notifications/$id/read');
    } catch (e) {
      print('Mark Read Error: $e');
    }
  }
}
