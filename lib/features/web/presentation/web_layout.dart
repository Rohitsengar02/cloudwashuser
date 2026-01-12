import 'package:cloud_user/core/theme/app_theme.dart';
import 'package:cloud_user/features/web/presentation/widgets/web_footer.dart';
import 'package:cloud_user/features/web/presentation/widgets/web_navbar.dart';
import 'package:cloud_user/features/notifications/presentation/providers/notification_provider.dart';
import 'package:cloud_user/features/orders/data/order_provider.dart';
import 'package:cloud_user/features/orders/data/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Web Layout wrapper - provides navbar + footer for all web pages
class WebLayout extends ConsumerWidget {
  final Widget child;
  final Widget? endDrawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? floatingBottomBar;

  const WebLayout({
    super.key,
    required this.child,
    this.endDrawer,
    this.scaffoldKey,
    this.floatingBottomBar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for real-time order status updates from Firebase
    // (Snackbars removed as per user request to use Push only)
    ref.listen(userOrdersRealtimeProvider, (previous, next) {});

    // Listen for real-time notifications (Socket based)
    // (Snackbars removed as per user request to use Push only)
    ref.listen<AsyncValue<List<Map<String, dynamic>>>>(
      notificationsProvider,
      (previous, next) {},
    );

    final bool isMobile = MediaQuery.of(context).size.width < 1000;
    final GlobalKey<ScaffoldState> effectiveScaffoldKey =
        scaffoldKey ?? GlobalKey<ScaffoldState>();

    return Scaffold(
      key: effectiveScaffoldKey,
      backgroundColor: const Color(0xFFF7F8FA),
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      endDrawer: endDrawer,
      body: Stack(
        children: [
          Column(
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
                      if (!isMobile) const WebFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (floatingBottomBar != null)
            Positioned(bottom: 0, left: 0, right: 0, child: floatingBottomBar!),
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
                color: AppTheme.primary.withValues(alpha: 0.05),
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
