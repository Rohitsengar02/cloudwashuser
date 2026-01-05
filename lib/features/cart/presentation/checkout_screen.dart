import 'package:cloud_user/core/theme/app_theme.dart';
import 'package:cloud_user/features/cart/data/addons_provider.dart';
import 'package:cloud_user/features/cart/data/cart_provider.dart';
import 'package:cloud_user/features/location/data/location_provider.dart';
import 'package:cloud_user/features/web/presentation/web_layout.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0; // 0: Details, 1: Payment
  String _selectedPaymentMethod = 'UPI'; // UPI, Cards, Cash
  bool _isLoading = false;

  void _placeOrder() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    ref.read(cartProvider.notifier).clearCart();
    if (mounted) {
      setState(() => _isLoading = false);
      context.push('/thank-you');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final isDesktop = MediaQuery.of(context).size.width > 1000;

    // Platform-specific content structure
    Widget layout = isDesktop
        ? _buildDesktopLayout(cartState, total)
        : _buildMobileLayout(cartState, total);

    if (kIsWeb) {
      return WebLayout(
        child: Container(
          color: const Color(0xFFF8F9FB),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? MediaQuery.of(context).size.width * 0.08
                : 20,
            vertical: isDesktop ? 60 : 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(isWeb: true),
              const SizedBox(height: 40),
              layout,
            ],
          ),
        ),
      );
    }

    // Standard Scaffold for Mobile App
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => _currentStep == 0
              ? context.pop()
              : setState(() => _currentStep = 0),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: layout,
            ),
          ),
          if (!isDesktop) _buildBottomAction(total),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(cartState, double total) {
    return _currentStep == 0
        ? _buildDetailsSection(cartState, total)
        : _buildPaymentSection(total);
  }

  Widget _buildDesktopLayout(cartState, double total) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Steps & Input
        SizedBox(
          width:
              600, // Fixed width for desktop to prevent overflow/assertion errors
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(isWeb: true),
              const SizedBox(height: 40),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentStep == 0
                    ? _buildDetailsSection(
                        cartState,
                        total,
                        isDesktop: true,
                        key: const ValueKey('details_step'),
                      )
                    : _buildPaymentSection(
                        total,
                        isDesktop: true,
                        key: const ValueKey('payment_step'),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 60),
        // Right Column: Summary Card
        Expanded(
          // This is okay now because it fills remaining space horizontally
          child: Column(
            children: [
              const SizedBox(height: 42), // Align with title
              _buildPricingCard(cartState, total, isDesktop: true),
              const SizedBox(height: 24),
              _buildDesktopAction(total),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator({bool isWeb = false}) {
    return Container(
      color: isWeb ? Colors.transparent : Colors.white,
      padding: EdgeInsets.symmetric(vertical: isWeb ? 0 : 20),
      child: Row(
        mainAxisAlignment: isWeb
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          _stepItem(0, 'Details', _currentStep >= 0),
          _stepDivider(_currentStep >= 1),
          _stepItem(1, 'Payment', _currentStep >= 1),
        ],
      ),
    );
  }

  Widget _buildDesktopAction(double total) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                if (_currentStep == 0) {
                  setState(() => _currentStep = 1);
                } else {
                  _placeOrder();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                _currentStep == 0 ? 'Review & Pay' : 'Pay & Confirm Booking',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _stepItem(int step, String label, bool isActive) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider(bool isActive) {
    return Container(
      width: 50,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: isActive ? AppTheme.primary : Colors.grey.shade300,
    );
  }

  Widget _buildDetailsSection(
    cartState,
    double total, {
    bool isDesktop = false,
    Key? key,
  }) {
    final location = ref.watch(userLocationProvider);
    final addonsAsync = ref.watch(addonsProvider);

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Service Address', isDesktop: isDesktop),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(isDesktop ? 32 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: AppTheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location?.address ?? 'No address selected',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 18 : 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your service will be delivered here',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isDesktop ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push('/add-address'),
                child: const Text(
                  'Change',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        if (!isDesktop) ...[
          const SizedBox(height: 32),
          _sectionTitle('Order Summary', isDesktop: isDesktop),
          const SizedBox(height: 12),
          _buildPricingCard(cartState, total),
        ],
        const SizedBox(height: 40),
        _sectionTitle('Recommended Add-ons', isDesktop: isDesktop),
        const SizedBox(height: 16),
        _buildAddonsRow(addonsAsync, cartState, isDesktop: isDesktop),
      ],
    );
  }

  Widget _buildPaymentSection(
    double total, {
    bool isDesktop = false,
    Key? key,
  }) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Select Payment Method', isDesktop: isDesktop),
        const SizedBox(height: 16),
        _paymentMethodItem(
          'UPI',
          'Pay via Google Pay, PhonePe, or Paytm',
          Icons.account_balance_wallet,
          'UPI',
          isDesktop: isDesktop,
        ),
        _paymentMethodItem(
          'Credit/Debit Cards',
          'Visa, Mastercard, RuPay',
          Icons.credit_card,
          'Cards',
          isDesktop: isDesktop,
        ),
        _paymentMethodItem(
          'Cash After Service',
          'Pay once work is done',
          Icons.money,
          'Cash',
          isDesktop: isDesktop,
        ),
        const SizedBox(height: 32),
        Container(
          padding: EdgeInsets.all(isDesktop ? 32 : 24),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: Colors.blue,
                size: isDesktop ? 32 : 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Your payment is 100% secure. We use industry-standard encryption.',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: isDesktop ? 15 : 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentMethodItem(
    String title,
    String subtitle,
    IconData icon,
    String value, {
    bool isDesktop = false,
  }) {
    final isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(isDesktop ? 28 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : Colors.grey,
              size: isDesktop ? 28 : 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 18 : 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isDesktop ? 13 : 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primary,
                size: isDesktop ? 28 : 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {bool isDesktop = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isDesktop ? 22 : 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPricingCard(cartState, double total, {bool isDesktop = false}) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ...cartState.items.map(
            (item) => _itemRow(item.service.title, '₹${item.totalPrice}'),
          ),
          ...cartState.selectedAddons.map(
            (addon) => _itemRow(addon.name, '₹${addon.price}'),
          ),
          const Divider(height: 48),
          _itemRow('Subtotal', '₹${total.toStringAsFixed(0)}'),
          _itemRow('GST (18%)', '₹${(total * 0.18).toStringAsFixed(0)}'),
          const Divider(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop ? 20 : 18,
                ),
              ),
              Text(
                '₹${(total * 1.18).toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: isDesktop ? 28 : 22,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAddonsRow(
    AsyncValue<List<dynamic>> addonsAsync,
    cartState, {
    bool isDesktop = false,
  }) {
    return addonsAsync.when(
      data: (addons) {
        final filtered = addons
            .where((a) => !cartState.selectedAddons.any((sa) => sa.id == a.id))
            .take(6)
            .toList();
        if (filtered.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: isDesktop ? 160 : 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final addon = filtered[index];
              return Container(
                width: isDesktop ? 140 : 100,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    Image.network(
                      addon.imageUrl,
                      width: isDesktop ? 50 : 30,
                      height: isDesktop ? 50 : 30,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.add_task),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      addon.name,
                      style: TextStyle(
                        fontSize: isDesktop ? 12 : 10,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '₹${addon.price}',
                      style: TextStyle(
                        fontSize: isDesktop ? 12 : 10,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () =>
                          ref.read(cartProvider.notifier).toggleAddon(addon),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildBottomAction(double total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Amount to Pay',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  '₹${(total * 1.18).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_currentStep == 0) {
                          setState(() => _currentStep = 1);
                        } else {
                          _placeOrder();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _currentStep == 0
                            ? 'Review & Pay'
                            : 'Pay & Confirm Booking',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
