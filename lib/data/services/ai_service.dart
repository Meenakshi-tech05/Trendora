import 'dart:convert';

import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey = "AIzaSyDLS8d-NoyIuGzD8APF5sbQ54UQwgmtYMQ";

  Future<String> getFashionAdvice(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
        ),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      """

You are a professional AI fashion stylist.

Suggest stylish fashion recommendations for:

$prompt

Include:
- outfit ideas
- colors
- accessories
- shoes
- styling tips

""",
                },
              ],
            },
          ],
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data["candidates"][0]["content"]["parts"][0]["text"];
      }

      return "Error: ${data.toString()}";
    } catch (e) {
      return "Error: $e";
    }
  }
}
