import 'package:cloud_user/features/web/presentation/web_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_provider.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      return WebLayout(
        child: Container(
          constraints: const BoxConstraints(minHeight: 600),
          width: double.infinity,
          color: Colors.white,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildNotificationList(ref, isWeb: true),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _buildNotificationList(ref, isWeb: false),
    );
  }

  Widget _buildNotificationList(WidgetRef ref, {required bool isWeb}) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 60,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No notifications yet',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true, // Needed for Web usage inside Column
          physics: isWeb
              ? const NeverScrollableScrollPhysics()
              : null, // Let page scroll on web
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final n = notifications[index];
            final isRead = n['isRead'] == true;

            return ListTile(
              contentPadding: isWeb ? const EdgeInsets.all(16) : null,
              tileColor: isRead
                  ? Colors.transparent
                  : Colors.blue.withOpacity(0.05),
              leading: CircleAvatar(
                backgroundColor: isRead
                    ? Colors.grey.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                child: Icon(
                  _getIcon(n['type']),
                  color: isRead ? Colors.grey : Colors.blue,
                  size: 20,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      n['title'] ?? 'Notification',
                      style: TextStyle(
                        fontWeight: isRead
                            ? FontWeight.normal
                            : FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    n['message'] ?? '',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (n['createdAt'] != null)
                        Text(
                          DateFormat(
                            'MMM dd, hh:mm a',
                          ).format(DateTime.parse(n['createdAt'])),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      if (!isRead)
                        const Icon(Icons.circle, color: Colors.blue, size: 8),
                    ],
                  ),
                ],
              ),
              onTap: () {
                if (!isRead) {
                  ref
                      .read(notificationsProvider.notifier)
                      .markRead(n['_id'], source: n['source']);
                }
              },
            );
          },
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'order_created':
        return Icons.receipt_long;
      case 'order_status':
      case 'order_update':
        return Icons.local_shipping;
      default:
        return Icons.notifications;
    }
  }
}
