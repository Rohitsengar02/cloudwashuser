import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_user/core/network/api_client.dart';

final notificationRepositoryProvider = Provider((ref) {
  return NotificationRepository(ref.watch(apiClientProvider));
});

class NotificationRepository {
  final Dio _dio;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Stream<List<Map<String, dynamic>>> listenToFirebaseNotifications(
    String userId,
  ) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final notifications = snapshot.docs.map((doc) {
            var data = doc.data();
            // Convert Timestamp to String for UI consistency
            if (data['createdAt'] is Timestamp) {
              data = Map<String, dynamic>.from(data); // clone to modify
              data['createdAt'] = (data['createdAt'] as Timestamp)
                  .toDate()
                  .toIso8601String();
            }
            return {...data, '_id': doc.id, 'source': 'firebase'};
          }).toList();

          // Sort in memory (newest first)
          notifications.sort((a, b) {
            final dateA =
                DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime(0);
            final dateB =
                DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime(0);
            return dateB.compareTo(dateA);
          });

          return notifications;
        });
  }

  Future<void> markAsRead(String id, {String? source}) async {
    try {
      if (source == 'firebase') {
        await _firestore.collection('notifications').doc(id).update({
          'isRead': true,
        });
      } else {
        await _dio.patch('notifications/$id/read');
      }
    } catch (e) {
      print('Mark Read Error: $e');
    }
  }
}
