import 'package:cloud_user/core/models/addon_model.dart';
import 'package:cloud_user/core/models/service_model.dart';
import 'package:cloud_user/features/cart/data/cart_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  CartState build() {
    return CartState(items: [], selectedAddons: []);
  }

  void addToCart(ServiceModel service) {
    // Check if item exists, if so increment quantity
    final index = state.items.indexWhere(
      (item) => item.service.id == service.id,
    );
    if (index >= 0) {
      final oldItem = state.items[index];
      final newItem = CartItem(
        service: service,
        quantity: oldItem.quantity + 1,
      );
      final newItems = [...state.items];
      newItems[index] = newItem;
      state = state.copyWith(items: newItems);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(service: service, quantity: 1),
        ],
      );
    }
  }

  void updateQuantity(String serviceId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(serviceId);
      return;
    }
    final index = state.items.indexWhere(
      (item) => item.service.id == serviceId,
    );
    if (index >= 0) {
      final newItems = [...state.items];
      newItems[index] = CartItem(
        service: newItems[index].service,
        quantity: newQuantity,
      );
      state = state.copyWith(items: newItems);
    }
  }

  void removeFromCart(String serviceId) {
    state = state.copyWith(
      items: state.items.where((item) => item.service.id != serviceId).toList(),
    );
  }

  void toggleAddon(AddonModel addon) {
    final exists = state.selectedAddons.any((a) => a.id == addon.id);
    if (exists) {
      state = state.copyWith(
        selectedAddons: state.selectedAddons
            .where((a) => a.id != addon.id)
            .toList(),
      );
    } else {
      state = state.copyWith(selectedAddons: [...state.selectedAddons, addon]);
    }
  }

  void clearCart() {
    state = CartState(items: [], selectedAddons: []);
  }
}

@riverpod
double cartTotal(CartTotalRef ref) {
  final cartState = ref.watch(cartProvider);
  return cartState.subtotal;
}
