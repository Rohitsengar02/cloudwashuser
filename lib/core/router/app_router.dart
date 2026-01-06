import 'package:cloud_user/core/models/service_model.dart';
import 'package:cloud_user/features/auth/presentation/login_screen.dart';
import 'package:cloud_user/features/auth/presentation/web_login_screen.dart';
import 'package:cloud_user/features/auth/presentation/register_screen.dart';
import 'package:cloud_user/features/auth/presentation/otp_screen.dart';
import 'package:cloud_user/features/orders/presentation/bookings_screen.dart';
import 'package:cloud_user/features/bookings/presentation/booking_details_screen.dart';
import 'package:cloud_user/features/home/presentation/home_screen.dart';
import 'package:cloud_user/features/notifications/presentation/screens/notifications_screen.dart';

import 'package:cloud_user/features/home/presentation/service_details_screen.dart';
import 'package:cloud_user/features/home/presentation/scaffold_with_nav_bar.dart';
import 'package:cloud_user/features/profile/presentation/profile_screen.dart';
import 'package:cloud_user/features/rewards/presentation/rewards_screen.dart';
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
import 'package:cloud_user/features/profile/presentation/edit_profile_screen.dart';
import 'package:cloud_user/features/profile/presentation/personal_info_screen.dart';
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
        name: 'web-home',
        builder: (context, state) => const WebHomeScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'web-notifications',
        builder: (context, state) => const NotificationsScreen(),
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
        name: 'web-bookings',
        builder: (context, state) => const WebBookingsScreen(),
      ),
      GoRoute(
        path: '/booking-details/:id',
        name: 'bookingDetails',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookingDetailsScreen(bookingId: id);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'web-profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/personal-info',
        name: 'personalInfo',
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'web-login',
        builder: (context, state) => const WebLoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'web-otp',
        builder: (context, state) {
          final extras = state.extra as Map<String, String>;
          return OtpScreen(
            phone: extras['phone']!,
            generatedOtp: extras['otp']!,
          );
        },
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
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
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
      GoRoute(
        path: '/booking-details/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookingDetailsScreen(bookingId: id);
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/personal-info',
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'mobile-login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final extras = state.extra as Map<String, String>;
          return OtpScreen(
            phone: extras['phone']!,
            generatedOtp: extras['otp']!,
          );
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
                name: 'mobile-home',
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
                name: 'mobile-bookings',
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
                name: 'mobile-profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
