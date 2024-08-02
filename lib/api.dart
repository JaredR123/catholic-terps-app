import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<String> Getdata(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      debugPrint('Response data: ${response.body}');
      return response.body;
    } else {
      debugPrint('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  } catch (e) {
    debugPrint('Error: $e');
    throw Exception('Failed to load data');
  }
}