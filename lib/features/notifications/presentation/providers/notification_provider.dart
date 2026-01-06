import 'package:cloud_user/core/services/socket_service.dart';
import 'package:cloud_user/features/notifications/data/notification_repository.dart';
import 'package:cloud_user/features/profile/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsProvider =
    StateNotifierProvider.autoDispose<
      NotificationNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) {
      ref.onDispose(() {
        ref.read(socketServiceProvider).dispose();
      });

      return NotificationNotifier(ref);
    });

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref ref;

  NotificationNotifier(this.ref) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final repo = ref.read(notificationRepositoryProvider);
      final list = await repo.getNotifications();
      state = AsyncValue.data(list);

      // Socket Setup
      final socket = ref.read(socketServiceProvider);
      socket.init();

      // Listen for User to join room
      ref.listen(userProfileProvider, (previous, next) {
        next.whenData((user) {
          if (user != null && (user['_id'] != null || user['id'] != null)) {
            socket.joinRoom(user['_id'] ?? user['id']);
          }
        });
      });

      // Trigger initial check if already loaded
      ref.read(userProfileProvider).whenData((user) {
        if (user != null) {
          socket.joinRoom(user['_id'] ?? user['id']);
        }
      });

      socket.onNotification((data) {
        final currentList = state.value ?? [];
        state = AsyncValue.data([data, ...currentList]);
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markRead(String id) async {
    await ref.read(notificationRepositoryProvider).markAsRead(id);
    final currentList = state.value ?? [];
    final newList = currentList.map((n) {
      if (n['_id'] == id) {
        return {...n, 'isRead': true};
      }
      return n;
    }).toList();
    state = AsyncValue.data(newList);
  }
}
