import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trendora/data/models/cart_model.dart';
import 'package:trendora/data/models/product_model.dart';
import 'package:trendora/data/models/wishlist_model.dart';

import 'package:trendora/data/services/cart_service.dart';

import 'package:trendora/providers/wishlist_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  String selectedSize = '';

  final CartService cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final bool hasSizes =
        product.category == "Dresses" || product.category == "Shoes";

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// PRODUCT IMAGE
            Container(
              height: 380,

              width: double.infinity,

              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(product.image),

                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// TITLE
                  Text(
                    product.title,

                    style: const TextStyle(
                      fontSize: 28,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// PRICE
                  Text(
                    "₹${product.price}",

                    style: const TextStyle(
                      color: Color(0xFFA14F62),

                      fontSize: 24,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// WISHLIST BUTTON
                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),

                      onPressed: () {
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
                          const SnackBar(content: Text("Added to Wishlist")),
                        );
                      },

                      icon: const Icon(
                        Icons.favorite_border,

                        color: Colors.red,
                      ),

                      label: const Text(
                        "Add to Wishlist",

                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// DESCRIPTION
                  const Text(
                    "Description",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    product.description,

                    style: TextStyle(
                      color: Colors.grey.shade700,

                      fontSize: 16,

                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// SIZE SECTION
                  if (hasSizes) ...[
                    const Text(
                      "Select Size",

                      style: TextStyle(
                        fontSize: 22,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 12,

                      runSpacing: 12,

                      children: product.sizes.map((size) {
                        final isSelected = selectedSize == size;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSize = size;
                            });
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,

                              vertical: 14,
                            ),

                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFA14F62)
                                  : Colors.grey.shade200,

                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Text(
                              size,

                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),
                  ],

                  /// ADD TO CART BUTTON
                  SizedBox(
                    width: double.infinity,

                    height: 58,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA14F62),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      onPressed: () async {
                        /// SIZE VALIDATION
                        if (hasSizes && selectedSize.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select size")),
                          );

                          return;
                        }

                        await cartService.addToCart(
                          CartModel(
                            id: product.id,

                            title: product.title,

                            image: product.image,

                            price: product.price,

                            quantity: 1,

                            size: hasSizes ? selectedSize : '',
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to Cart")),
                        );
                      },

                      child: const Text(
                        "Add to Cart",

                        style: TextStyle(
                          color: Colors.white,

                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
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
