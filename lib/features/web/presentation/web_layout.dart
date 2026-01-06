import 'package:cloud_user/core/theme/app_theme.dart';
import 'package:cloud_user/features/web/presentation/widgets/web_footer.dart';
import 'package:cloud_user/features/web/presentation/widgets/web_navbar.dart';
import 'package:cloud_user/features/notifications/presentation/providers/notification_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Web Layout wrapper - provides navbar + footer for all web pages
class WebLayout extends ConsumerWidget {
  final Widget child;
  final Widget? endDrawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const WebLayout({
    super.key,
    required this.child,
    this.endDrawer,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for real-time notifications
    ref.listen(notificationsProvider, (previous, next) {
      next.whenData((currentList) {
        previous?.whenData((prevList) {
          if (currentList.isNotEmpty &&
              (prevList.isEmpty ||
                  currentList.first['_id'] != prevList.first['_id'])) {
            final newNotif = currentList.first;
            // Only show if it's unread (newly arrived)
            if (newNotif['isRead'] == false) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  width: MediaQuery.of(context).size.width > 600 ? 400 : null,
                  backgroundColor: const Color(0xFF323232),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.notifications_active,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            newNotif['title'] ?? 'Notification',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        newNotif['message'] ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  action: SnackBarAction(
                    label: 'VIEW',
                    textColor: Colors.amber,
                    onPressed: () => context.go('/notifications'),
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }
        });
      });
    });

    final bool isMobile = MediaQuery.of(context).size.width < 1000;
    final GlobalKey<ScaffoldState> effectiveScaffoldKey =
        scaffoldKey ?? GlobalKey<ScaffoldState>();

    return Scaffold(
      key: effectiveScaffoldKey,
      backgroundColor: const Color(0xFFF7F8FA),
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      endDrawer: endDrawer,
      body: Column(
        children: [
          WebNavBar(scaffoldKey: effectiveScaffoldKey),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Main Content
                  child,

                  // Footer
                  const WebFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.05),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 140,
                  errorBuilder: (_, __, ___) => const Text(
                    'CLINOWASH',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                ),
              ),
            ),
            _drawerTile(context, 'Home', '/', Icons.home_outlined),
            _drawerTile(context, 'About', '/about', Icons.info_outline),
            _drawerTile(
              context,
              'Services',
              '/services',
              Icons.local_laundry_service_outlined,
            ),
            _drawerTile(context, 'Blog', '/blog', Icons.article_outlined),
            _drawerTile(
              context,
              'Contact',
              '/contact',
              Icons.contact_support_outlined,
            ),
            const Divider(),
            _drawerTile(
              context,
              'Notifications',
              '/notifications',
              Icons.notifications_outlined,
            ),
            _drawerTile(context, 'Profile', '/profile', Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
