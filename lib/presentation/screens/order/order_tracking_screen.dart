import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderStatus;

  const OrderTrackingScreen({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      "Order Placed",

      "Packed",

      "Shipped",

      "Out for Delivery",

      "Delivered",
    ];

    int currentStep = statuses.indexOf(orderStatus);

    if (currentStep == -1) {
      currentStep = 0;
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        title: const Text(
          "Order Tracking",

          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Track Your Order",

              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: ListView.builder(
                itemCount: statuses.length,

                itemBuilder: (context, index) {
                  final isCompleted = index <= currentStep;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Column(
                        children: [
                          Container(
                            width: 28,
                            height: 28,

                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? const Color(0xFFA14F62)
                                  : Colors.grey.shade300,

                              shape: BoxShape.circle,
                            ),

                            child: Icon(
                              Icons.check,

                              size: 18,

                              color: isCompleted ? Colors.white : Colors.grey,
                            ),
                          ),

                          if (index != statuses.length - 1)
                            Container(
                              width: 4,

                              height: 70,

                              color: isCompleted
                                  ? const Color(0xFFA14F62)
                                  : Colors.grey.shade300,
                            ),
                        ],
                      ),

                      const SizedBox(width: 20),

                      Padding(
                        padding: const EdgeInsets.only(top: 2),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              statuses[index],

                              style: TextStyle(
                                fontSize: 20,

                                fontWeight: FontWeight.bold,

                                color: isCompleted ? Colors.black : Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              isCompleted ? "Completed" : "Pending",

                              style: TextStyle(
                                color: isCompleted ? Colors.green : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
