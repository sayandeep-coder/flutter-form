import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String webhookUrl = ''; // your api

  static Future<bool> submitScoreCard(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
} 