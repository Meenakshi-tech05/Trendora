import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trendora/data/models/wishlist_model.dart';

/// PROVIDER
final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<WishlistModel>>(
      (ref) => WishlistNotifier(),
    );

/// NOTIFIER
class WishlistNotifier extends StateNotifier<List<WishlistModel>> {
  WishlistNotifier() : super([]);

  /// ADD TO WISHLIST
  void addToWishlist(WishlistModel product) {
    final alreadyExists = state.any((item) => item.id == product.id);

    /// PREVENT DUPLICATES
    if (alreadyExists) {
      return;
    }

    state = [...state, product];
  }

  /// REMOVE FROM WISHLIST
  void removeFromWishlist(WishlistModel product) {
    state = state.where((item) => item.id != product.id).toList();
  }

  /// CHECK IF EXISTS
  bool isInWishlist(String productId) {
    return state.any((item) => item.id == productId);
  }

  /// CLEAR WISHLIST
  void clearWishlist() {
    state = [];
  }
}
