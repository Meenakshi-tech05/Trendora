import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/cart_provider.dart';

import '../../../data/models/order_model.dart';

import '../../../data/services/auth_service.dart';
import '../../../data/services/order_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final addressController = TextEditingController();

  final couponController = TextEditingController();

  String paymentMethod = "Cash on Delivery";

  double discount = 0;

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    double total = 0;

    for (var item in cartItems) {
      total += item.price * item.quantity;
    }

    final finalTotal = total - discount;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        title: const Text("Checkout", style: TextStyle(color: Colors.black)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ADDRESS
            const Text(
              "Delivery Address",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: addressController,

              maxLines: 3,

              decoration: InputDecoration(
                hintText: "Enter delivery address",

                filled: true,

                fillColor: Colors.grey.shade100,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// PAYMENT
            const Text(
              "Payment Method",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField(
              value: paymentMethod,

              items: const [
                DropdownMenuItem(
                  value: "Cash on Delivery",

                  child: Text("Cash on Delivery"),
                ),

                DropdownMenuItem(value: "UPI", child: Text("UPI")),

                DropdownMenuItem(value: "Card", child: Text("Card")),
              ],

              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            /// COUPON
            const Text(
              "Coupon Code",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: couponController,

                    decoration: InputDecoration(
                      hintText: "Enter coupon",

                      filled: true,

                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA14F62),
                  ),

                  onPressed: () {
                    if (couponController.text.trim() == "TREND10") {
                      setState(() {
                        discount = total * 0.1;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Coupon Applied")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid Coupon")),
                      );
                    }
                  },

                  child: const Text(
                    "Apply",

                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// ORDER SUMMARY
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [const Text("Subtotal"), Text("₹$total")],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [const Text("Discount"), Text("- ₹$discount")],
                  ),

                  const Divider(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Total",

                        style: TextStyle(
                          fontSize: 20,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "₹$finalTotal",

                        style: const TextStyle(
                          fontSize: 22,

                          color: Color(0xFFA14F62),

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// PLACE ORDER
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

                onPressed: () async {
                  if (addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter Address")),
                    );

                    return;
                  }

                  final order = OrderModel(
                    userId: AuthService().currentUser!.uid,

                    items: cartItems.map((item) {
                      return {
                        "title": item.title,

                        "size": item.size,

                        "quantity": item.quantity,
                      };
                    }).toList(),

                    total: finalTotal,

                    address: addressController.text,

                    paymentMethod: paymentMethod,

                    status: "Order Placed",
                  );

                  await OrderService().placeOrder(order);

                  ref.read(cartProvider.notifier).clearCart();

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order Placed Successfully")),
                  );

                  Navigator.pop(context);
                },

                child: const Text(
                  "Place Order",

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
    );
  }
}
