import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/cart_model.dart';

class WishlistNotifier extends StateNotifier<List<CartModel>> {
  WishlistNotifier() : super([]);

  void addToWishlist(CartModel product) {
    final exists = state.any((item) => item.title == product.title);

    if (!exists) {
      state = [...state, product];
    }
  }

  void removeFromWishlist(CartModel product) {
    state = state.where((item) => item.title != product.title).toList();
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<CartModel>>((ref) {
      return WishlistNotifier();
    });
