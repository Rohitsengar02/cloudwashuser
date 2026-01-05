import 'package:cloud_user/core/theme/app_theme.dart';
import 'package:cloud_user/features/web/presentation/widgets/web_footer.dart';
import 'package:cloud_user/features/web/presentation/widgets/web_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Web Layout wrapper - provides navbar + footer for all web pages
class WebLayout extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
