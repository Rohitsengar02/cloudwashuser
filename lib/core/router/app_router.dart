import 'package:cloud_user/core/models/service_model.dart';
import 'package:cloud_user/features/bookings/presentation/bookings_screen.dart';
import 'package:cloud_user/features/home/presentation/home_screen.dart';

import 'package:cloud_user/features/home/presentation/service_details_screen.dart';
import 'package:cloud_user/features/home/presentation/scaffold_with_nav_bar.dart';
import 'package:cloud_user/features/profile/presentation/profile_screen.dart';
import 'package:cloud_user/features/rewards/presentation/rewards_screen.dart';
import 'package:cloud_user/features/auth/presentation/login_screen.dart';
import 'package:cloud_user/features/auth/presentation/otp_screen.dart';
import 'package:cloud_user/features/location/presentation/map_screen.dart';
import 'package:cloud_user/features/cart/presentation/cart_screen.dart';
import 'package:cloud_user/features/cart/presentation/checkout_screen.dart';
import 'package:cloud_user/features/cart/presentation/thank_you_screen.dart';
import 'package:cloud_user/features/web/presentation/web_home_screen.dart';
import 'package:cloud_user/features/web/presentation/web_bookings_screen.dart';
import 'package:cloud_user/features/web/presentation/web_sub_categories_screen.dart';
import 'package:cloud_user/features/home/presentation/sub_categories_screen.dart';
import 'package:cloud_user/features/web/presentation/web_services_page.dart';
import 'package:cloud_user/features/web/presentation/web_static_page.dart';
import 'package:cloud_user/features/home/presentation/services_list_screen.dart';
import 'package:cloud_user/features/web/presentation/web_services_list_screen.dart';
import 'package:cloud_user/features/location/presentation/add_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorBookingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellBookings',
);
final _shellNavigatorRewardsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellRewards',
);
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellProfile',
);

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // Web uses WebHomeScreen directly, Mobile uses bottom tabs
  if (kIsWeb) {
    return _buildWebRouter();
  } else {
    return _buildMobileRouter();
  }
}

/// Web Router - No bottom tabs, uses WebLayout with navbar + footer
GoRouter _buildWebRouter() {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const WebHomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OtpScreen(
            phone: extra['phone'] as String,
            generatedOtp: extra['otp'] as String,
          );
        },
      ),
      GoRoute(
        path: '/category/:id',
        name: 'category',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final name = state.extra as String? ?? 'Services';
          return WebSubCategoriesScreen(categoryId: id, categoryName: name);
        },
      ),
      GoRoute(
        path: '/services-list/:subCategoryId',
        name: 'servicesList',
        builder: (context, state) {
          final id = state.pathParameters['subCategoryId']!;
          final name = state.extra as String? ?? 'Services';
          return WebServicesListScreen(
            subCategoryId: id,
            subCategoryName: name,
          );
        },
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/thank-you',
        name: 'thankYou',
        builder: (context, state) => const ThankYouScreen(),
      ),
      GoRoute(
        path: '/bookings',
        name: 'bookings',
        builder: (context, state) => const WebBookingsScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/service-details',
        name: 'serviceDetails',
        builder: (context, state) {
          final service = state.extra as ServiceModel;
          return ServiceDetailsScreen(service: service);
        },
      ),
      // Web-only pages
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) => const WebServicesPage(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) =>
            const WebStaticPage(pageType: StaticPageType.aboutUs),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) =>
            const WebStaticPage(pageType: StaticPageType.contactUs),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) =>
            const WebStaticPage(pageType: StaticPageType.terms),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) =>
            const WebStaticPage(pageType: StaticPageType.privacy),
      ),
      GoRoute(
        path: '/blog',
        builder: (context, state) =>
            const WebStaticPage(pageType: StaticPageType.blog),
      ),
      GoRoute(
        path: '/reviews',
        builder: (context, state) =>
            const WebStaticPage(pageType: StaticPageType.reviews),
      ),
      GoRoute(
        path: '/child-protection',
        builder: (context, state) =>
            const WebStaticPage(pageType: StaticPageType.childProtection),
      ),
      GoRoute(path: '/map', builder: (context, state) => const MapScreen()),
      GoRoute(
        path: '/add-address',
        name: 'addAddress',
        builder: (context, state) => const AddAddressScreen(),
      ),
    ],
  );
}

/// Mobile Router - With bottom navigation tabs
GoRouter _buildMobileRouter() {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OtpScreen(
            phone: extra['phone'] as String,
            generatedOtp: extra['otp'] as String,
          );
        },
      ),
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/add-address',
        name: 'addAddress',
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: '/category/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final name = state.extra as String? ?? 'Services';
          return SubCategoriesScreen(categoryId: id, categoryName: name);
        },
      ),
      GoRoute(
        path: '/services-list/:subCategoryId',
        builder: (context, state) {
          final id = state.pathParameters['subCategoryId']!;
          final name = state.extra as String? ?? 'Services';
          return ServicesListScreen(subCategoryId: id, subCategoryName: name);
        },
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/thank-you',
        builder: (context, state) => const ThankYouScreen(),
      ),
      GoRoute(
        path: '/service-details',
        builder: (context, state) {
          final service = state.extra as ServiceModel;
          return ServiceDetailsScreen(service: service);
        },
      ),
      // Stateful Nested Shell Route (Bottom Navigation)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Bookings Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBookingsKey,
            routes: [
              GoRoute(
                path: '/bookings',
                name: 'bookings',
                builder: (context, state) => const BookingsScreen(),
              ),
            ],
          ),
          // Rewards Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorRewardsKey,
            routes: [
              GoRoute(
                path: '/rewards',
                name: 'rewards',
                builder: (context, state) => const RewardsScreen(),
              ),
            ],
          ),
          // Profile Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
