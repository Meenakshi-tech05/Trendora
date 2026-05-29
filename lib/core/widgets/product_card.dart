import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trendora/data/models/cart_model.dart';
import 'package:trendora/data/models/product_model.dart';
import 'package:trendora/data/models/wishlist_model.dart';

import 'package:trendora/data/services/cart_service.dart';

import 'package:trendora/providers/wishlist_provider.dart';

import 'package:trendora/presentation/screens/product/product_details_screen.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CartService cartService = CartService();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),

              blurRadius: 8,

              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// IMAGE
            Expanded(
              flex: 5,

              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),

                  topRight: Radius.circular(18),
                ),

                child: Image.network(
                  product.image,

                  width: double.infinity,

                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// DETAILS
            Expanded(
              flex: 5,

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,

                  vertical: 8,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    /// TITLE
                    Text(
                      product.title,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 14,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// CATEGORY
                    Text(
                      product.category,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 12,

                        color: Colors.grey.shade600,
                      ),
                    ),

                    /// PRICE + ACTIONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Flexible(
                          child: Text(
                            "₹${product.price}",

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: Color(0xFFA14F62),

                              fontSize: 14,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            /// WISHLIST
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(wishlistProvider.notifier)
                                    .addToWishlist(
                                      WishlistModel(
                                        id: product.id,

                                        title: product.title,

                                        image: product.image,

                                        price: product.price,
                                      ),
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Added to Wishlist"),
                                  ),
                                );
                              },

                              child: const Icon(
                                Icons.favorite_border,

                                color: Colors.red,

                                size: 18,
                              ),
                            ),

                            const SizedBox(width: 10),

                            /// CART
                            GestureDetector(
                              onTap: () async {
                                await cartService.addToCart(
                                  CartModel(
                                    id: product.id,

                                    title: product.title,

                                    image: product.image,

                                    price: product.price,

                                    quantity: 1,

                                    size: '',
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Added to Cart"),
                                  ),
                                );
                              },

                              child: const Icon(
                                Icons.shopping_cart_outlined,

                                color: Color(0xFFA14F62),

                                size: 18,
                              ),
                            ),
                          ],
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
    );
  }
}
