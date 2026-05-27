import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/cart_provider.dart';

import '../checkout/checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    double totalPrice = 0;

    for (var item in cartItems) {
      totalPrice += item.price;
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        title: const Text("My Cart", style: TextStyle(color: Colors.black)),
      ),

      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.shopping_bag_outlined,

                    size: 100,

                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Your cart is empty",

                    style: TextStyle(
                      fontSize: 22,

                      color: Colors.grey.shade700,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                /// CART ITEMS
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),

                    itemCount: cartItems.length,

                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Row(
                          children: [
                            /// IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),

                              child: Image.network(
                                item.image,

                                width: 90,
                                height: 90,

                                fit: BoxFit.cover,

                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90,
                                    height: 90,

                                    color: Colors.grey.shade300,

                                    child: const Icon(Icons.image),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 16),

                            /// DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    item.title,

                                    style: const TextStyle(
                                      fontSize: 18,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "₹${item.price}",

                                    style: const TextStyle(
                                      fontSize: 16,

                                      color: Color(0xFFA14F62),

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,

                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),

                                        child: IconButton(
                                          onPressed: () {},

                                          icon: const Icon(Icons.remove),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      const Text(
                                        "1",

                                        style: TextStyle(
                                          fontSize: 18,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,

                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),

                                        child: IconButton(
                                          onPressed: () {},

                                          icon: const Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            /// DELETE
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .removeFromCart(item);
                              },

                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// BOTTOM SECTION
                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),

                        blurRadius: 10,

                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      /// TOTAL
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            "Total",

                            style: TextStyle(
                              fontSize: 22,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "₹${totalPrice.toStringAsFixed(0)}",

                            style: const TextStyle(
                              fontSize: 24,

                              fontWeight: FontWeight.bold,

                              color: Color(0xFFA14F62),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// CHECKOUT BUTTON
                      SizedBox(
                        width: double.infinity,

                        height: 55,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA14F62),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          onPressed: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) => const CheckoutScreen(),
                              ),
                            );
                          },

                          child: const Text(
                            "Proceed to Checkout",

                            style: TextStyle(
                              color: Colors.white,

                              fontWeight: FontWeight.bold,

                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
