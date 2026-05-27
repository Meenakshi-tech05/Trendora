import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  int currentIndex = 0;

  final pages = [
    {"title": "Discover Fashion", "subtitle": "Explore latest trends"},
    {"title": "AI Recommendation", "subtitle": "Get personalized outfits"},
    {"title": "Fast Shopping", "subtitle": "Quick checkout experience"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,

              itemCount: pages.length,

              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },

              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Icon(
                        Icons.shopping_bag,
                        size: 120,
                        color: Colors.pink,
                      ),

                      const SizedBox(height: 40),

                      Text(
                        pages[index]['title']!,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        pages[index]['subtitle']!,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),

            child: ElevatedButton(
              onPressed: () {
                if (currentIndex == 2) {
                  context.go('/login');
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },

              child: Text(currentIndex == 2 ? "Get Started" : "Next"),
            ),
          ),
        ],
      ),
    );
  }
}
