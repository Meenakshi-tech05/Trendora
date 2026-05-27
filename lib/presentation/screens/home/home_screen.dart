import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/product_card.dart';

import '../../../providers/product_provider.dart';

import '../ai/ai_chat_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../shop/shop_screen.dart';
import '../../../providers/search_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      {"title": "Dresses", "icon": Icons.checkroom},

      {"title": "Shoes", "icon": Icons.shopping_bag},

      {"title": "Bags", "icon": Icons.work},

      {"title": "Jewelry", "icon": Icons.diamond},
    ];

    final productAsync = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        title: const Text(
          "Trendora",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        actions: [
          /// WISHLIST
          IconButton(
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              );
            },

            icon: const Icon(Icons.favorite, color: Colors.black),
          ),

          /// AI
          IconButton(
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (context) => const AIChatScreen()),
              );
            },

            icon: const Icon(Icons.auto_awesome, color: Colors.black),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// SEARCH BAR
            TextField(
              onChanged: (value) {
                ref.read(searchProvider.notifier).state = value;
              },

              decoration: InputDecoration(
                hintText: "Search fashion...",

                prefixIcon: const Icon(Icons.search),

                filled: true,

                fillColor: Colors.grey.shade100,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// AI BANNER
            Container(
              height: 230,

              width: double.infinity,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                gradient: const LinearGradient(
                  colors: [Color(0xFFA14F62), Color(0xFFD67B95)],
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text(
                      "AI Fashion\nAssistant",

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 30,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const AIChatScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "Chat with AI",

                        style: TextStyle(color: Color(0xFFA14F62)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// CATEGORY HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  "Categories",

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => const ShopScreen(),
                      ),
                    );
                  },

                  child: const Text("View All"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// CATEGORY LIST
            SizedBox(
              height: 110,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                itemCount: categories.length,

                itemBuilder: (context, index) {
                  final category = categories[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => const ShopScreen(),
                        ),
                      );
                    },

                    child: Container(
                      width: 90,

                      margin: const EdgeInsets.only(right: 16),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            category["icon"] as IconData,

                            size: 32,

                            color: const Color(0xFFA14F62),
                          ),

                          const SizedBox(height: 10),

                          Text(category["title"] as String),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            /// TRENDING TITLE
            const Text(
              "Trending Now",

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// FIRESTORE PRODUCTS
            productAsync.when(
              data: (products) {
                final searchQuery = ref.watch(searchProvider).toLowerCase();

                final filteredProducts = products.where((product) {
                  return product.title.toLowerCase().contains(searchQuery) ||
                      product.category.toLowerCase().contains(searchQuery);
                }).toList();
                if (products.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),

                      child: Text(
                        "No Products Found",

                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: filteredProducts.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,

                    childAspectRatio: 0.62,

                    crossAxisSpacing: 16,

                    mainAxisSpacing: 16,
                  ),

                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                );
              },

              loading: () {
                return const Center(child: CircularProgressIndicator());
              },

              error: (error, stackTrace) {
                return Center(child: Text(error.toString()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
