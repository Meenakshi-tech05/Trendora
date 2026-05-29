import 'package:flutter/material.dart';

import 'package:trendora/data/models/cart_model.dart';

import 'package:trendora/data/services/cart_service.dart';

import 'package:trendora/presentation/screens/checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "My Cart",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder<List<CartModel>>(
        stream: cartService.getCartItems(),

        builder: (context, snapshot) {
          /// LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// EMPTY CART
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.shopping_cart_outlined,

                    size: 90,

                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Your Cart is Empty",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Add products to continue shopping",

                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                ],
              ),
            );
          }

          final cartItems = snapshot.data!;

          /// TOTAL PRICE
          double totalAmount = 0;

          for (var item in cartItems) {
            totalAmount += item.price * item.quantity;
          }

          return Column(
            children: [
              /// CART ITEMS
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: cartItems.length,

                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(18),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),

                            blurRadius: 10,

                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          /// PRODUCT IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),

                            child: Image.network(
                              item.image,

                              width: 100,

                              height: 100,

                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 14),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                /// TITLE
                                Text(
                                  item.title,

                                  maxLines: 2,

                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 17,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                /// SIZE
                                if (item.size.isNotEmpty)
                                  Text(
                                    "Size: ${item.size}",

                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),

                                const SizedBox(height: 8),

                                /// PRICE
                                Text(
                                  "₹${item.price}",

                                  style: const TextStyle(
                                    color: Color(0xFFA14F62),

                                    fontSize: 18,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                /// QUANTITY CONTROLS
                                Row(
                                  children: [
                                    /// DECREASE
                                    GestureDetector(
                                      onTap: () async {
                                        await cartService.decreaseQuantity(
                                          item,
                                        );
                                      },

                                      child: Container(
                                        padding: const EdgeInsets.all(6),

                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,

                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),

                                        child: const Icon(
                                          Icons.remove,

                                          size: 18,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    /// QUANTITY
                                    Text(
                                      item.quantity.toString(),

                                      style: const TextStyle(
                                        fontSize: 18,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    /// INCREASE
                                    GestureDetector(
                                      onTap: () async {
                                        await cartService.increaseQuantity(
                                          item,
                                        );
                                      },

                                      child: Container(
                                        padding: const EdgeInsets.all(6),

                                        decoration: BoxDecoration(
                                          color: const Color(0xFFA14F62),

                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),

                                        child: const Icon(
                                          Icons.add,

                                          color: Colors.white,

                                          size: 18,
                                        ),
                                      ),
                                    ),

                                    const Spacer(),

                                    /// DELETE
                                    GestureDetector(
                                      onTap: () async {
                                        await cartService.removeFromCart(item);
                                      },

                                      child: const Icon(
                                        Icons.delete_outline,

                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),

                    topRight: Radius.circular(24),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),

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
                          "₹${totalAmount.toStringAsFixed(0)}",

                          style: const TextStyle(
                            fontSize: 24,

                            color: Color(0xFFA14F62),

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// CHECKOUT BUTTON
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

                        onPressed: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(
                                cartItems: cartItems,

                                totalAmount: totalAmount,
                              ),
                            ),
                          );
                        },

                        child: const Text(
                          "Proceed to Checkout",

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
          );
        },
      ),
    );
  }
}
