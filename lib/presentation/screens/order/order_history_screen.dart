import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),

        title: const Text(
          "Order History",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user!.uid)
            .snapshots(),

        builder: (context, snapshot) {
          /// LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// NO ORDERS
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Orders Yet", style: TextStyle(fontSize: 18)),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: orders.length,

            itemBuilder: (context, index) {
              final order = orders[index];

              final data = order.data() as Map<String, dynamic>;

              /// ITEMS
              final items = data['items'] ?? [];

              /// EMPTY ITEMS SAFETY
              if (items.isEmpty) {
                return const SizedBox();
              }

              final firstItem = items[0];

              return Container(
                margin: const EdgeInsets.only(bottom: 18),

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

                child: Padding(
                  padding: const EdgeInsets.all(14),

                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// PRODUCT IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),

                            child: Image.network(
                              firstItem['image'] ?? '',

                              width: 90,

                              height: 90,

                              fit: BoxFit.cover,

                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 90,

                                  height: 90,

                                  color: Colors.grey.shade200,

                                  child: const Icon(Icons.image),
                                );
                              },
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
                                  firstItem['title'] ?? '',

                                  maxLines: 2,

                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 18,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                /// SIZE
                                Text(
                                  "Size: ${firstItem['size'] ?? '-'}",

                                  style: TextStyle(color: Colors.grey.shade700),
                                ),

                                const SizedBox(height: 4),

                                /// QUANTITY
                                Text(
                                  "Qty: ${firstItem['quantity'] ?? 1}",

                                  style: TextStyle(color: Colors.grey.shade700),
                                ),

                                const SizedBox(height: 4),

                                /// PRICE
                                Text(
                                  "₹${firstItem['price'] ?? 0}",

                                  style: const TextStyle(
                                    color: Color(0xFFA14F62),

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// TRACK ORDER BUTTON
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA14F62),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          onPressed: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => OrderTrackingScreen(
                                  orderStatus:
                                      data['orderStatus'] ?? "Order Placed",
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
