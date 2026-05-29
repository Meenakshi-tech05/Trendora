import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trendora/data/models/cart_model.dart';

import 'package:trendora/data/services/order_service.dart';

import 'package:trendora/presentation/screens/checkout/order_success_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final List<CartModel> cartItems;

  final double totalAmount;

  const CheckoutScreen({
    super.key,

    required this.cartItems,

    required this.totalAmount,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController addressController = TextEditingController();

  String paymentMethod = "Cash on Delivery";

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Checkout",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// DELIVERY ADDRESS
            const Text(
              "Delivery Address",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: addressController,

              maxLines: 4,

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

            /// PAYMENT METHOD
            const Text(
              "Payment Method",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                borderRadius: BorderRadius.circular(16),
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: paymentMethod,

                  isExpanded: true,

                  items: const [
                    DropdownMenuItem(
                      value: "Cash on Delivery",

                      child: Text("Cash on Delivery"),
                    ),

                    DropdownMenuItem(value: "UPI", child: Text("UPI")),

                    DropdownMenuItem(
                      value: "Credit/Debit Card",

                      child: Text("Credit/Debit Card"),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ORDER SUMMARY
            const Text(
              "Order Summary",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              itemCount: widget.cartItems.length,

              itemBuilder: (context, index) {
                final item = widget.cartItems[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),

                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(16),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),

                        blurRadius: 8,

                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      /// IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),

                        child: Image.network(
                          item.image,

                          width: 80,

                          height: 80,

                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              item.title,

                              maxLines: 2,

                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 16,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Qty: ${item.quantity}",

                              style: TextStyle(color: Colors.grey.shade700),
                            ),

                            /// SIZE
                            if (item.size.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),

                                child: Text(
                                  "Size: ${item.size}",

                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),

                            const SizedBox(height: 6),

                            Text(
                              "₹${item.price}",

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
                );
              },
            ),

            const SizedBox(height: 30),

            /// TOTAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  "Total Amount",

                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                Text(
                  "₹${widget.totalAmount}",

                  style: const TextStyle(
                    fontSize: 22,

                    color: Color(0xFFA14F62),

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// PLACE ORDER BUTTON
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

                onPressed: isLoading
                    ? null
                    : () async {
                        /// EMPTY ADDRESS
                        if (addressController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter address"),
                            ),
                          );

                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        /// PLACE ORDER
                        await OrderService().placeOrder(
                          cartItems: widget.cartItems,

                          totalAmount: widget.totalAmount,

                          address: addressController.text,

                          paymentMethod: paymentMethod,
                        );

                        if (!context.mounted) return;

                        setState(() {
                          isLoading = false;
                        });

                        /// SUCCESS
                        Navigator.pushReplacement(
                          context,

                          MaterialPageRoute(
                            builder: (_) => const OrderSuccessScreen(),
                          ),
                        );
                      },

                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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
