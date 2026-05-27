import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';

import '../../../data/services/auth_service.dart';
import '../../../data/services/order_service.dart';

import '../order/order_tracking_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = AuthService().currentUser;

    final cartItems = ref.watch(cartProvider);

    final wishlistItems = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        title: const Text("Profile", style: TextStyle(color: Colors.black)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// PROFILE SECTION
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,

                    backgroundColor: Colors.pink.shade100,

                    child: const Icon(
                      Icons.person,

                      size: 60,

                      color: Color(0xFFA14F62),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    user?.email ?? "Guest User",

                    style: const TextStyle(
                      fontSize: 22,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// DASHBOARD
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      children: [
                        const Icon(Icons.shopping_cart),

                        const SizedBox(height: 10),

                        Text(
                          "${cartItems.length}",

                          style: const TextStyle(
                            fontSize: 24,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text("Cart Items"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      children: [
                        const Icon(Icons.favorite),

                        const SizedBox(height: 10),

                        Text(
                          "${wishlistItems.length}",

                          style: const TextStyle(
                            fontSize: 24,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text("Wishlist"),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// ORDER HISTORY
            const Text(
              "Order History",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            StreamBuilder<QuerySnapshot>(
              stream: OrderService().getUserOrders(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!.docs;

                if (orders.isEmpty) {
                  return Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(30),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Center(
                      child: Text(
                        "No Orders Yet",

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: orders.length,

                  itemBuilder: (context, index) {
                    final order = orders[index];

                    final status = order.data().toString().contains('status')
                        ? order['status']
                        : "Order Placed";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "₹${order['total']}",

                            style: const TextStyle(
                              fontSize: 22,

                              color: Color(0xFFA14F62),

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(order['address']),

                          const SizedBox(height: 10),

                          Text(order['paymentMethod']),

                          const SizedBox(height: 14),

                          Text(
                            "Status: $status",

                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            "Products",

                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 8),

                          ...List.generate((order['items'] as List).length, (
                            itemIndex,
                          ) {
                            final item = order['items'][itemIndex];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),

                              child: Text(
                                "${item['title']}  -  Size ${item['size']}",

                                style: const TextStyle(fontSize: 15),
                              ),
                            );
                          }),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA14F62),
                              ),

                              onPressed: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (context) => OrderTrackingScreen(
                                      orderStatus: status,
                                    ),
                                  ),
                                );
                              },

                              child: const Text(
                                "Track Order",

                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 40),

            /// LOGOUT
            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: () async {
                  await AuthService().logout();

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.pop(context);
                },

                child: const Text(
                  "Logout",

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
    );
  }
}
