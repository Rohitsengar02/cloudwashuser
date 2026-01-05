import 'package:cloud_user/core/theme/app_theme.dart';
import 'package:cloud_user/features/web/presentation/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebBookingsScreen extends ConsumerStatefulWidget {
  const WebBookingsScreen({super.key});

  @override
  ConsumerState<WebBookingsScreen> createState() => _WebBookingsScreenState();
}

class _WebBookingsScreenState extends ConsumerState<WebBookingsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WebLayout(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Bookings',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Track and manage your service requests',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Sidebar: Filters
                      SizedBox(
                        width: 280,
                        child: Column(
                          children: [
                            _BookingFilterItem(
                              label: 'Ongoing',
                              icon: Icons.access_time_filled,
                              isSelected: _selectedIndex == 0,
                              onTap: () => setState(() => _selectedIndex = 0),
                            ),
                            _BookingFilterItem(
                              label: 'History',
                              icon: Icons.history,
                              isSelected: _selectedIndex == 1,
                              onTap: () => setState(() => _selectedIndex = 1),
                            ),
                            _BookingFilterItem(
                              label: 'Cancelled',
                              icon: Icons.cancel,
                              isSelected: _selectedIndex == 2,
                              onTap: () => setState(() => _selectedIndex = 2),
                            ),
                            const SizedBox(height: 48),
                            // Promo Card in sidebar
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primary,
                                    AppTheme.primaryLight,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Premium Plan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Get 20% off on your next 5 bookings with Plus.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppTheme.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text('Upgrade Now'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 60),
                      // Right Panel: Booking List
                      Expanded(
                        child: _selectedIndex == 0
                            ? _buildOngoingList()
                            : _selectedIndex == 1
                            ? _buildHistoryList()
                            : _buildEmptyState(
                                'No cancelled bookings',
                                'You haven\'t cancelled any bookings recently.',
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOngoingList() {
    return Column(
      children: [
        _WebBookingCard(
          id: 'ORD-8821',
          service: 'Luxury Spa Experience',
          dateTime: 'Tomorrow, 10:30 AM',
          price: '₹2,299',
          status: 'Professional Assigned',
          statusColor: Colors.blue,
        ),
        const SizedBox(height: 24),
        _WebBookingCard(
          id: 'ORD-8825',
          service: 'Deep Kitchen Cleaning',
          dateTime: '15 Jan, 09:00 AM',
          price: '₹1,499',
          status: 'Confirmed',
          statusColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children: [
        _WebBookingCard(
          id: 'ORD-7710',
          service: 'Home Painting Service',
          dateTime: '02 Jan, 11:00 AM',
          price: '₹12,899',
          status: 'Completed',
          statusColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 100,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingFilterItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BookingFilterItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary.withOpacity(0.2)
                : Colors.transparent,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : Colors.grey,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.chevron_right, color: AppTheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _WebBookingCard extends StatelessWidget {
  final String id;
  final String service;
  final String dateTime;
  final String price;
  final String status;
  final Color statusColor;

  const _WebBookingCard({
    required this.id,
    required this.service,
    required this.dateTime,
    required this.price,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.cleaning_services_outlined,
              color: statusColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      id,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  service,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _infoBadge(Icons.calendar_today_outlined, dateTime),
                    const SizedBox(width: 16),
                    _infoBadge(Icons.payments_outlined, price),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Column(
            children: [
              _actionButton('View Details', false, () {}),
              const SizedBox(height: 12),
              _actionButton('Track Service', true, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, bool isPrimary, VoidCallback onTap) {
    return SizedBox(
      width: 160,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppTheme.primary : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          elevation: 0,
          side: isPrimary ? null : BorderSide(color: Colors.grey.shade200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
