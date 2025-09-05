import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// GET request
  static Future<Map<String, dynamic>> get(
      String url, {
        Map<String, String>? headers,
        Duration timeout = const Duration(seconds: 30),
      }) async {
    print("🌐 [GET] Request URL: $url");

    try {
      final response = await http
          .get(
        Uri.parse(url),
        headers: headers ?? _defaultHeaders,
      )
          .timeout(timeout);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      print("❌ Client error: ${e.message}");
      return _handleError('Client error: ${e.message}');
    } catch (e) {
      print("❌ Unexpected error: $e");
      return _handleError('Unexpected error: $e');
    }
  }

  /// POST request
  static Future<Map<String, dynamic>> post(
      String url, {
        dynamic body,
        Map<String, String>? headers,
        Duration timeout = const Duration(seconds: 30),
      }) async {
    print("🌐 [POST] Request URL: $url");
    print("📦 [POST] Body: ${jsonEncode(body)}");

    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: headers ?? _defaultHeaders,
        body: jsonEncode(body),
      )
          .timeout(timeout);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      print("❌ Client error: ${e.message}");
      return _handleError('Client error: ${e.message}');
    } catch (e) {
      print("❌ Unexpected error: $e");
      return _handleError('Unexpected error: $e');
    }
  }

  /// Response handler
  static Map<String, dynamic> _handleResponse(http.Response response) {
    print("✅ [Response] Status: ${response.statusCode}");

    try {
      final decoded = json.decode(response.body);
      final prettyJson = const JsonEncoder.withIndent('  ').convert(decoded);
      print("📥 [Response JSON]:\n$prettyJson");

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': decoded,
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Failed with status code: ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print("⚠️ Failed to decode response body: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Failed to parse response body',
        'statusCode': response.statusCode,
      };
    }
  }

  /// Error handler
  static Map<String, dynamic> _handleError(String message) {
    print("🚫 [Error] $message");

    return {
      'success': false,
      'data': null,
      'message': message,
      'statusCode': 0,
    };
  }
}
