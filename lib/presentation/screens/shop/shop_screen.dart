import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/product_provider.dart';

import '../../../core/widgets/product_card.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  String selectedCategory = "All";

  final categories = ["All", "Dresses", "Shoes", "Bags", "Jewelry"];

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        title: const Text("Shop", style: TextStyle(color: Colors.black)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// SEARCH
            TextField(
              decoration: InputDecoration(
                hintText: "Search products",

                prefixIcon: const Icon(Icons.search),

                filled: true,

                fillColor: Colors.grey.shade100,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CATEGORY FILTERS
            SizedBox(
              height: 50,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                itemCount: categories.length,

                itemBuilder: (context, index) {
                  final category = categories[index];

                  final isSelected = selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },

                    child: Container(
                      margin: const EdgeInsets.only(right: 12),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),

                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFA14F62)
                            : Colors.grey.shade200,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        category,

                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// PRODUCTS
            Expanded(
              child: productAsync.when(
                data: (products) {
                  final filteredProducts = selectedCategory == "All"
                      ? products
                      : products.where((product) {
                          return product.category.toLowerCase().contains(
                            selectedCategory.toLowerCase(),
                          );
                        }).toList();

                  if (filteredProducts.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Products Found",

                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: filteredProducts.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,

                          childAspectRatio: 0.62,

                          crossAxisSpacing: 16,

                          mainAxisSpacing: 16,
                        ),

                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return ProductCard(product: product);
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
            ),
          ],
        ),
      ),
    );
  }
}
