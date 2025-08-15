library virak;

import 'dart:convert';
import 'package:http/http.dart' as http;

String _baseUrl = "";
String? _authToken;

/// Set the base API URL
void setBaseUrl(String url) {
  _baseUrl = url;
}

/// Set or clear the authentication token
void setAuthToken(String? token) {
  _authToken = token;
}

/// Build headers with optional token
Map<String, String> _buildHeaders() {
  final headers = {"Content-Type": "application/json"};
  if (_authToken != null && _authToken!.isNotEmpty) {
    headers["Authorization"] = "Bearer $_authToken";
  }
  return headers;
}

/// Generic GET request
Future<T> getData<T>({
  required String endpoint,
  T Function(dynamic json)? fromJson,
}) async {
  if (_baseUrl.isEmpty) {
    throw Exception("Base URL is not set. Call setBaseUrl() first.");
  }

  final response = await http.get(
    Uri.parse("$_baseUrl/$endpoint"),
    headers: _buildHeaders(),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return fromJson != null ? fromJson(json) : json;
  } else {
    throw Exception("GET $endpoint failed: ${response.statusCode}");
  }
}

/// Generic POST request
Future<T> postData<T>({
  required String endpoint,
  required Map<String, dynamic> body,
  T Function(dynamic json)? fromJson,
}) async {
  if (_baseUrl.isEmpty) {
    throw Exception("Base URL is not set. Call setBaseUrl() first.");
  }

  final response = await http.post(
    Uri.parse("$_baseUrl/$endpoint"),
    headers: _buildHeaders(),
    body: jsonEncode(body),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final json = jsonDecode(response.body);
    return fromJson != null ? fromJson(json) : json;
  } else {
    throw Exception("POST $endpoint failed: ${response.statusCode}");
  }
}

/// Generic PUT request
Future<T> putData<T>({
  required String endpoint,
  required Map<String, dynamic> body,
  T Function(dynamic json)? fromJson,
}) async {
  if (_baseUrl.isEmpty) {
    throw Exception("Base URL is not set. Call setBaseUrl() first.");
  }

  final response = await http.put(
    Uri.parse("$_baseUrl/$endpoint"),
    headers: _buildHeaders(),
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return fromJson != null ? fromJson(json) : json;
  } else {
    throw Exception("PUT $endpoint failed: ${response.statusCode}");
  }
}

/// Generic DELETE request
Future<void> deleteData({required String endpoint}) async {
  if (_baseUrl.isEmpty) {
    throw Exception("Base URL is not set. Call setBaseUrl() first.");
  }

  final response = await http.delete(
    Uri.parse("$_baseUrl/$endpoint"),
    headers: _buildHeaders(),
  );
  if (response.statusCode != 200 && response.statusCode != 204) {
    throw Exception("DELETE $endpoint failed: ${response.statusCode}");
  }
}
