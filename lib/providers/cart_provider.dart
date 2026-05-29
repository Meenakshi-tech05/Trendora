import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/cart_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartModel>>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<List<CartModel>> {
  CartNotifier() : super([]);

  /// ADD TO CART
  void addToCart(CartModel item) {
    final index = state.indexWhere(
      (cartItem) => cartItem.id == item.id && cartItem.size == item.size,
    );

    /// SAME PRODUCT + SAME SIZE EXISTS
    if (index != -1) {
      final updatedItem = state[index].copyWith(
        quantity: state[index].quantity + 1,
      );

      final updatedList = [...state];

      updatedList[index] = updatedItem;

      state = updatedList;
    } else {
      /// NEW PRODUCT
      state = [...state, item];
    }
  }

  /// REMOVE ITEM
  void removeFromCart(CartModel item) {
    state = state
        .where(
          (cartItem) => !(cartItem.id == item.id && cartItem.size == item.size),
        )
        .toList();
  }

  /// INCREASE QUANTITY
  void increaseQuantity(CartModel item) {
    final updatedList = state.map((cartItem) {
      if (cartItem.id == item.id && cartItem.size == item.size) {
        return cartItem.copyWith(quantity: cartItem.quantity + 1);
      }

      return cartItem;
    }).toList();

    state = updatedList;
  }

  /// DECREASE QUANTITY
  void decreaseQuantity(CartModel item) {
    final updatedList = state.map((cartItem) {
      if (cartItem.id == item.id && cartItem.size == item.size) {
        if (cartItem.quantity > 1) {
          return cartItem.copyWith(quantity: cartItem.quantity - 1);
        }
      }

      return cartItem;
    }).toList();

    state = updatedList;
  }

  /// CLEAR CART
  void clearCart() {
    state = [];
  }
}
