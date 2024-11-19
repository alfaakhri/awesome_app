import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final String baseUrl;
  late final Map<String, String> headers;

  ApiClient._internal();

  factory ApiClient({required String baseUrl, required Map<String, String> headers}) {
    _instance.baseUrl = baseUrl;
    _instance.headers = headers;
    return _instance;
  }

  static ApiClient get instance => _instance;

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.post(uri, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }
}
