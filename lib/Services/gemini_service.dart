
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // IMPORTANT: The user should provide their own API key. 
  // For training/demo purposes, you might use an environment variable or a secure vault.
  static const String _apiKey = "AIzaSyCltn91mSr1A_emvctgz-aMfBqSt_1qX-Q"; 

  static Future<String> getFarmingAdvice({
    required String soilType,
    required String cropName,
    required int day,
    required double moisture,
    required double nutrients,
    required double health,
  }) async {
    if (_apiKey.isEmpty || _apiKey == "YOUR_GEMINI_API_KEY") {
      return "Gemini API Key not configured. Using rule-based logic: Keep watering and fertilizing regularly!";
    }

    try {
      final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);
      
      final prompt = """
        You are an expert AI Farming Advisor. 
        A farmer is playing a virtual farming simulation.
        Current details:
        - Soil Type: $soilType
        - Crop: $cropName
        - Day of Growth: $day
        - Soil Moisture: ${(moisture * 100).toInt()}%
        - Soil Nutrients: ${(nutrients * 100).toInt()}%
        - Crop Health: ${(health * 100).toInt()}%

        Based on these stats, give a very short, encouraging, and professional advice (max 2 sentences) on what the farmer should do next to maximize yield. 
        Also, predict if the final yield will be "High", "Average", or "Low".
      """;

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      return response.text ?? "Unable to get advice at the moment.";
    } catch (e) {
      return "Error connecting to Gemini: $e";
    }
  }

  // General chat response method for vendor advisory and price prediction
  Future<String> getChatResponse(String prompt) async {
    if (_apiKey.isEmpty || _apiKey == "YOUR_GEMINI_API_KEY" || _apiKey == "PASTE_YOUR_NEW_KEY_HERE") {
      return "Gemini API Key not configured. Please add your API key to use AI features.";
    }

    try {
      final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      return response.text ?? "Unable to get response at the moment.";
    } catch (e) {
      return "Error connecting to Gemini: $e";
    }
  }
}
