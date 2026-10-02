import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

class GeminiService {
  static const String _model = 'gemini-1.5-flash';
  String? _apiKey;

  Future<void> init() async {
    try {
      final envString = await rootBundle.loadString('env.json');
      final env = json.decode(envString);
      _apiKey = env['GEMINI_API_KEY'];
    } catch (e) {
      debugPrint('Warning: Could not load env.json: $e');
    }
  }

  Future<Map<String, dynamic>> analyzeJobDescription(String description) async {
    if (_apiKey == null) await init();
    
    // Fallback if key is missing or dummy
    if (_apiKey == null || _apiKey!.isEmpty || _apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      await Future.delayed(const Duration(seconds: 2));
      return {
        "category": description.toLowerCase().contains('pipe') || description.toLowerCase().contains('water') ? 'Plumbing' : 'Electrical',
        "problemType": "Detected Issue",
        "requiredSkills": ["General Maintenance", "Repair"],
        "severity": "Medium",
        "estimatedDurationHours": 1
      };
    }

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey');

    final prompt = '''
Analyze the following home-service problem description and output ONLY a valid JSON object without markdown formatting.

Description: "$description"

The JSON object must have exactly these keys:
- "category": (string) Choose the best fit from [Plumbing, Electrical, Carpentry, Cleaning, Handyman, Appliance Repair, Painting].
- "problemType": (string) A short 2-4 word summary of the problem.
- "requiredSkills": (list of strings) 2-4 specific technical skills needed (e.g., ["pipe fitting", "drain unblocking"]).
- "severity": (string) Choose from [Low, Medium, High, Emergency].
- "estimatedDurationHours": (number) Estimated time to fix.

Output ONLY JSON.
''';

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'responseMimeType': 'application/json',
        }
      }),
    );

    if (response.statusCode != 200) {
      debugPrint('Failed to communicate with Gemini API: \${response.body}');
      return {
        "category": description.toLowerCase().contains('pipe') || description.toLowerCase().contains('water') ? 'Plumbing' : 'Electrical',
        "problemType": "Detected Issue",
        "requiredSkills": ["General Maintenance", "Repair"],
        "severity": "Medium",
        "estimatedDurationHours": 1
      };
    }

    final data = json.decode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
    
    try {
      return json.decode(text);
    } catch (e) {
      throw Exception('Failed to parse Gemini response as JSON: $text');
    }
  }
}
