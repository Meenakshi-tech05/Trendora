import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';
import '../../data/models/cart_model.dart';

import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';

import '../../presentation/screens/product/product_details_screen.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// IMAGE
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),

                      topRight: Radius.circular(20),
                    ),

                    child: Image.network(
                      product.image,

                      width: double.infinity,

                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,

                          child: const Center(
                            child: Icon(Icons.image, size: 50),
                          ),
                        );
                      },
                    ),
                  ),

                  /// WISHLIST
                  Positioned(
                    top: 10,
                    right: 10,

                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(wishlistProvider.notifier)
                            .addToWishlist(
                              CartModel(
                                title: product.title,

                                image: product.image,

                                price: product.price,

                                quantity: 1,

                                size: "",
                              ),
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to Wishlist")),
                        );
                      },

                      child: Container(
                        padding: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(50),
                        ),

                        child: const Icon(
                          Icons.favorite_border,

                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// DETAILS
            Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    product.title,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,

                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "₹${product.price}",

                    style: const TextStyle(
                      color: Color(0xFFA14F62),

                      fontWeight: FontWeight.bold,

                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA14F62),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: () {
                        ref
                            .read(cartProvider.notifier)
                            .addToCart(
                              CartModel(
                                title: product.title,

                                image: product.image,

                                price: product.price,

                                quantity: 1,

                                size: "",
                              ),
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to Cart")),
                        );
                      },

                      child: const Text(
                        "Add to Cart",

                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
