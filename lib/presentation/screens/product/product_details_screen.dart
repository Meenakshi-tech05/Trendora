import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/product_model.dart';
import '../../../data/models/cart_model.dart';

import '../../../providers/cart_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  String selectedSize = "";

  @override
  Widget build(BuildContext context) {
    List<String> sizes = [];

    if (widget.product.category.toLowerCase() == "dresses") {
      sizes = ["S", "M", "L", "XL"];
    } else if (widget.product.category.toLowerCase() == "shoes") {
      sizes = ["7", "8", "9", "10", "11"];
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// IMAGE
            SizedBox(
              height: 400,

              width: double.infinity,

              child: Image.network(widget.product.image, fit: BoxFit.cover),
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// TITLE
                  Text(
                    widget.product.title,

                    style: const TextStyle(
                      fontSize: 28,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// PRICE
                  Text(
                    "₹${widget.product.price}",

                    style: const TextStyle(
                      fontSize: 24,

                      color: Color(0xFFA14F62),

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// SIZE SECTION
                  if (sizes.isNotEmpty) ...[
                    const Text(
                      "Select Size",

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 12,

                      children: sizes.map((size) {
                        final isSelected = selectedSize == size;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSize = size;
                            });
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,

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

                    const SizedBox(height: 30),
                  ],

                  /// DESCRIPTION
                  const Text(
                    "Description",

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Premium quality fashion product with elegant styling and modern comfort.",

                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),

                  const SizedBox(height: 40),

                  /// ADD TO CART
                  SizedBox(
                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA14F62),
                      ),

                      onPressed: () {
                        if (sizes.isNotEmpty && selectedSize.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Select Size")),
                          );

                          return;
                        }

                        ref
                            .read(cartProvider.notifier)
                            .addToCart(
                              CartModel(
                                title: widget.product.title,

                                image: widget.product.image,

                                price: widget.product.price,

                                quantity: 1,

                                size: selectedSize,
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

                          fontSize: 16,

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
