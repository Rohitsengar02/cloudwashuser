import 'dart:ui';
import 'package:cloud_user/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class WebNavBar extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const WebNavBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 1000;

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
                            top: isMobile
                                ? -10
                                : -20, // Center Vertically: (80-100)/2 = -10, (100-140)/2 = -20
                            child: InkWell(
                              onTap: () => context.go('/'),
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: isMobile ? 100 : 140,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Text(
                                  'CLINOWASH',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isMobile
                                        ? 24
                                        : 36, // Slightly adjusted font size for new layout
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
                              width: isMobile
                                  ? 150
                                  : 200, // Estimated width of logo
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Nav Links (Hidden on Mobile)
                    if (!isMobile)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavLink(label: 'Home', onTap: () => context.go('/')),
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

                    // Action Group (Right Aligned)
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isMobile) ...[
                              _NavActionButton(
                                icon: Icons.search_rounded,
                                onTap: () {},
                              ),
                              const SizedBox(width: 8),
                              _NavActionButton(
                                icon: Icons.account_circle_outlined,
                                onTap: () => context.push('/profile'),
                              ),
                              const SizedBox(width: 24),
                              _ScheduleButton(
                                onTap: () => context.go('/services'),
                              ),
                            ] else
                              IconButton(
                                icon: const Icon(
                                  Icons.account_circle_outlined,
                                  color: AppTheme.primary,
                                ),
                                onPressed: () => context.push('/profile'),
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

class _ScheduleButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ScheduleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [
            AppTheme.primary,
            Color(0xFF2B3A67), // Slightly lighter blue for gradient
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Book Now',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
