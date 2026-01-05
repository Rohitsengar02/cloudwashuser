import 'package:cloud_user/core/models/addon_model.dart';
import 'package:cloud_user/core/models/service_model.dart';

class CartItem {
  final ServiceModel service;
  final int quantity;

  CartItem({required this.service, required this.quantity});

  double get totalPrice => service.price * quantity;
}

class CartState {
  final List<CartItem> items;
  final List<AddonModel> selectedAddons;

  CartState({required this.items, required this.selectedAddons});

  CartState copyWith({
    List<CartItem>? items,
    List<AddonModel>? selectedAddons,
  }) {
    return CartState(
      items: items ?? this.items,
      selectedAddons: selectedAddons ?? this.selectedAddons,
    );
  }

  double get subtotal {
    final servicesTotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final addonsTotal = selectedAddons.fold(
      0.0,
      (sum, addon) => sum + addon.price,
    );
    return servicesTotal + addonsTotal;
  }
}
