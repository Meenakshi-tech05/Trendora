import 'package:flutter/material.dart';

import '../../../data/services/ai_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController promptController = TextEditingController();

  final aiService = AIService();

  String response = "";

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        title: const Text("AI Stylist", style: TextStyle(color: Colors.black)),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Describe Your Style",

                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Get AI-powered fashion recommendations.",

                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 30),

              /// INPUT
              TextField(
                controller: promptController,

                maxLines: 5,

                decoration: InputDecoration(
                  hintText: "Example: Suggest a classy party outfit",

                  filled: true,

                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// BUTTON
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
                    if (promptController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a prompt")),
                      );

                      return;
                    }

                    setState(() {
                      isLoading = true;

                      response = "";
                    });

                    final result = await aiService.getFashionAdvice("""
You are a professional fashion stylist.

Suggest:
- outfits
- matching colors
- shoes
- accessories
- bags

User Request:
${promptController.text}
""");

                    setState(() {
                      response = result;

                      isLoading = false;
                    });
                  },

                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Generate Style",

                          style: TextStyle(
                            color: Colors.white,

                            fontWeight: FontWeight.bold,

                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              /// RESPONSE
              Container(
                width: double.infinity,

                constraints: const BoxConstraints(minHeight: 250),

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,

                  borderRadius: BorderRadius.circular(20),
                ),

                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : response.isEmpty
                    ? const Center(
                        child: Text(
                          "AI recommendations will appear here.",

                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Text(
                        response,

                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
