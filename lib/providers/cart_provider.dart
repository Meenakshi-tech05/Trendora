import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/cart_model.dart';

class CartNotifier extends StateNotifier<List<CartModel>> {
  CartNotifier() : super([]);

  /// ADD TO CART
  void addToCart(CartModel product) {
    state = [...state, product];
  }

  /// REMOVE FROM CART
  void removeFromCart(CartModel product) {
    state = state.where((item) => item.title != product.title).toList();
  }

  /// CLEAR CART
  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartModel>>((
  ref,
) {
  return CartNotifier();
});
