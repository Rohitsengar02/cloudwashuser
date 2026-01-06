import 'package:cloud_user/features/auth/presentation/providers/auth_state_provider.dart';
import 'dart:ui';
import 'package:cloud_user/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_user/features/profile/presentation/providers/user_provider.dart';
import 'package:cloud_user/features/notifications/presentation/providers/notification_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class WebNavBar extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const WebNavBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 1000;

    // Watch Notifications
    final notificationsAsync = ref.watch(notificationsProvider);
    int unreadCount = 0;
    notificationsAsync.whenData((list) {
      unreadCount = list.where((n) => n['isRead'] == false).length;
    });

    return SizedBox(
      height: isMobile ? 80 : 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Layer
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content Layer
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50),
                child: Row(
                  children: [
                    if (isMobile)
                      IconButton(
                        icon: const Icon(Icons.menu, color: AppTheme.primary),
                        onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      ),

                    // Logo Container (Left Aligned with Overflow)
                    Expanded(
                      flex: isMobile ? 2 : 1,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: isMobile
                            ? Alignment.center
                            : Alignment.centerLeft,
                        children: [
                          Positioned(
                            top: isMobile ? 0 : 0,
                            child: InkWell(
                              onTap: () => context.go('/'),
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: isMobile ? 60 : 80,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Text(
                                  'CLINOWASH',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isMobile ? 24 : 36,
                                    color: AppTheme.primary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Invisible placeholder to maintain width in Row
                          Opacity(
                            opacity: 0,
                            child: SizedBox(
                              height: isMobile ? 80 : 100,
                              width: isMobile ? 120 : 160,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Nav Links (Hidden on Mobile)
                    if (!isMobile)
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _NavLink(
                                label: 'Home',
                                onTap: () => context.go('/'),
                              ),
                              _NavLink(
                                label: 'About',
                                onTap: () => context.go('/about'),
                              ),
                              _NavLink(
                                label: 'Services',
                                onTap: () => context.go('/services'),
                              ),
                              _NavLink(
                                label: 'My Bookings',
                                onTap: () => context.go('/bookings'),
                              ),
                              _NavLink(
                                label: 'Blog',
                                onTap: () => context.go('/blog'),
                              ),
                              _NavLink(
                                label: 'Contact',
                                onTap: () => context.go('/contact'),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Action Group (Right Aligned)
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isMobile) ...[
                              const SizedBox(width: 4),
                              ref
                                  .watch(authStateProvider)
                                  .when(
                                    data: (isAuthenticated) {
                                      if (isAuthenticated) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _NotificationButton(
                                              unreadCount: unreadCount,
                                            ),
                                            const SizedBox(width: 12),
                                            ref
                                                .watch(userProfileProvider)
                                                .when(
                                                  data: (user) => user != null
                                                      ? InkWell(
                                                          onTap: () => context
                                                              .push('/profile'),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 16,
                                                                  backgroundColor:
                                                                      AppTheme
                                                                          .primary
                                                                          .withOpacity(
                                                                            0.1,
                                                                          ),
                                                                  backgroundImage:
                                                                      user['profileImage'] !=
                                                                          null
                                                                      ? NetworkImage(
                                                                          user['profileImage'],
                                                                        )
                                                                      : null,
                                                                  child:
                                                                      user['profileImage'] ==
                                                                          null
                                                                      ? const Icon(
                                                                          Icons
                                                                              .person,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              AppTheme.primary,
                                                                        )
                                                                      : null,
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  user['name']
                                                                          ?.split(
                                                                            ' ',
                                                                          )[0] ??
                                                                      'User',
                                                                  style: GoogleFonts.inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: AppTheme
                                                                        .textPrimary,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : _NavActionButton(
                                                          icon: Icons
                                                              .account_circle_outlined,
                                                          onTap: () => context
                                                              .push('/profile'),
                                                        ),
                                                  loading: () => const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                  error: (_, __) => const Icon(
                                                    Icons.error_outline,
                                                  ),
                                                ),
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextButton(
                                              onPressed: () =>
                                                  context.push('/login'),
                                              style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                    ),
                                              ),
                                              child: Text(
                                                'Login',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.textPrimary,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  context.push('/register'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppTheme.primary,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 10,
                                                    ),
                                              ),
                                              child: Text(
                                                'Register',
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                    loading: () => const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    error: (_, __) =>
                                        const Icon(Icons.error_outline),
                                  ),
                            ] else
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _NotificationButton(unreadCount: unreadCount),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.account_circle_outlined,
                                      color: AppTheme.primary,
                                    ),
                                    onPressed: () => context.push('/profile'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                  color: _isHovered
                      ? AppTheme.primary
                      : AppTheme.textPrimary.withOpacity(0.8),
                ),
                child: Text(widget.label),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: _isHovered ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavActionButton({required this.icon, required this.onTap});

  @override
  State<_NavActionButton> createState() => _NavActionButtonState();
}

class _NavActionButtonState extends State<_NavActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: AppTheme.primary.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppTheme.primary.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? AppTheme.primary : AppTheme.textSecondary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatefulWidget {
  final int unreadCount;
  const _NotificationButton({required this.unreadCount});

  @override
  State<_NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<_NotificationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => context.push('/notifications'),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppTheme.primary.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: _isHovered ? AppTheme.primary : AppTheme.textSecondary,
                size: 24,
              ),
              if (widget.unreadCount > 0)
                Positioned(
                  top: -2,
                  right: -1,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.unreadCount > 9 ? '9+' : '${widget.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
