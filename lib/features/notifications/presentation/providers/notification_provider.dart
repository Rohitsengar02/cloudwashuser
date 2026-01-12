import 'package:cloud_user/core/services/notification_service.dart';
import 'package:cloud_user/core/services/socket_service.dart';
import 'package:cloud_user/features/notifications/data/notification_repository.dart';
import 'package:cloud_user/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:cloud_user/features/profile/presentation/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

// Reactive provider for Firebase UID
final firebaseUidProvider = StreamProvider<String?>((ref) {
  return FirebaseAuth.instance.authStateChanges().map((user) => user?.uid);
});

final notificationsProvider =
    StateNotifierProvider<
      NotificationNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) {
      // Re-create this notifier whenever the user profile OR UID changes
      // We prefer the MongoDB ID (_id) as it's stable across login methods (Google/Form)
      final userAsync = ref.watch(userProfileProvider);
      final firebaseUidAsync = ref.watch(firebaseUidProvider);
      final isAuthenticated = ref.watch(authStateProvider).valueOrNull ?? false;

      final stableId =
          userAsync.valueOrNull?['_id'] ??
          userAsync.valueOrNull?['id'] ??
          firebaseUidAsync.valueOrNull;

      return NotificationNotifier(
        ref: ref,
        userId: stableId,
        isAuthenticated: isAuthenticated,
      );
    });

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref ref;
  final String? userId;
  final bool isAuthenticated;
  final Set<String> _notifiedIds = {};
  StreamSubscription? _fbSubscription;

  NotificationNotifier({
    required this.ref,
    required this.userId,
    required this.isAuthenticated,
  }) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final repo = ref.read(notificationRepositoryProvider);

      // 1. Initial API load (Legacy/Backend) - Only if authenticated
      List<Map<String, dynamic>> apiList = [];
      if (isAuthenticated) {
        apiList = await repo.getNotifications();
        for (var n in apiList) {
          if (n['_id'] != null) _notifiedIds.add(n['_id']);
        }
      }
      state = AsyncValue.data(apiList);

      // 2. Setup Firebase Stream (Crucial for Real-time + Persistence)
      if (userId != null) {
        _fbSubscription?.cancel();
        _fbSubscription = repo
            .listenToFirebaseNotifications(userId!)
            .listen(
              (fbList) {
                final currentList = state.value ?? [];

                // Alert for new unread notifications
                for (var n in fbList) {
                  final id = n['_id'];
                  if (id != null && !_notifiedIds.contains(id)) {
                    _notifiedIds.add(id);
                    if (n['isRead'] == false) {
                      ref
                          .read(notificationServiceProvider)
                          .showNotification(
                            title: n['title'] ?? 'New Notification',
                            body: n['message'] ?? '',
                          );
                    }
                  }
                }

                // Merge Lists (preferring Firebase as source of truth)
                final Map<String, Map<String, dynamic>> deduped = {};
                for (var n in fbList) {
                  deduped[n['_id']] = n;
                }
                for (var n in currentList) {
                  if (!deduped.containsKey(n['_id'])) {
                    deduped[n['_id']!] = n;
                  }
                }

                final merged = deduped.values.toList();
                merged.sort((a, b) {
                  final dateA = DateTime.parse(
                    a['createdAt'] ?? DateTime.now().toIso8601String(),
                  );
                  final dateB = DateTime.parse(
                    b['createdAt'] ?? DateTime.now().toIso8601String(),
                  );
                  return dateB.compareTo(dateA);
                });

                if (mounted) state = AsyncValue.data(merged);
              },
              onError: (e) {
                print(
                  '🔥 Notification Stream Error (Check Firestore Index): $e',
                );
              },
            );
      }

      // 3. Socket Setup
      final socket = ref.read(socketServiceProvider);
      socket.init();

      // Trigger initial check if already loaded
      ref.read(userProfileProvider).whenData((user) {
        if (user != null && (user['_id'] != null || user['id'] != null)) {
          socket.joinRoom(user['_id'] ?? user['id']);
        }
      });

      socket.onNotification((data) {
        final currentList = state.value ?? [];
        final id = data['_id'];
        if (id != null && !currentList.any((n) => n['_id'] == id)) {
          if (mounted) state = AsyncValue.data([data, ...currentList]);
          if (!_notifiedIds.contains(id)) {
            _notifiedIds.add(id);
            ref
                .read(notificationServiceProvider)
                .showNotification(
                  title: data['title'] ?? 'New Notification',
                  body: data['message'] ?? '',
                );
          }
        }
      });
    } catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }

  Future<void> markRead(String id, {String? source}) async {
    await ref
        .read(notificationRepositoryProvider)
        .markAsRead(id, source: source);
    if (source != 'firebase') {
      final currentList = state.value ?? [];
      final newList = currentList.map((n) {
        if (n['_id'] == id) return {...n, 'isRead': true};
        return n;
      }).toList();
      state = AsyncValue.data(newList);
    }
  }

  @override
  void dispose() {
    _fbSubscription?.cancel();
    super.dispose();
  }
}

final unreadNotificationsCountProvider = Provider.autoDispose<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.maybeWhen(
    data: (list) => list.where((n) => n['isRead'] == false).length,
    orElse: () => 0,
  );
});
