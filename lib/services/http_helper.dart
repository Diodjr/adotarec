import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHelper {
  /// Timeout padrão para requisições (30 segundos)
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// GET request com tratamento de erro
  static Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      print('📤 GET: $url');
      
      final response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(timeout, onTimeout: () {
        throw TimeoutException(
          'Timeout ao conectar em $url',
          timeout,
        );
      });

      return _handleResponse(response);
    } catch (e) {
      print('❌ Erro GET: $e');
      rethrow;
    }
  }

  /// POST request com tratamento de erro
  static Future<dynamic> post(
    String url, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      print('📤 POST: $url');
      print('📦 Body: $body');
      
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers ?? {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeout, onTimeout: () {
        throw TimeoutException(
          'Timeout ao conectar em $url',
          timeout,
        );
      });

      return _handleResponse(response);
    } catch (e) {
      print('❌ Erro POST: $e');
      rethrow;
    }
  }

  /// PATCH request com tratamento de erro
  static Future<dynamic> patch(
    String url, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      print('📤 PATCH: $url');
      print('📦 Body: $body');

      final response = await http
          .patch(
            Uri.parse(url),
            headers: headers ?? {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeout, onTimeout: () {
        throw TimeoutException(
          'Timeout ao conectar em $url',
          timeout,
        );
      });

      return _handleResponse(response);
    } catch (e) {
      print('❌ Erro PATCH: $e');
      rethrow;
    }
  }

  /// PUT request com tratamento de erro
  static Future<dynamic> put(
    String url, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      print('📤 PUT: $url');
      print('📦 Body: $body');
      
      final response = await http
          .put(
            Uri.parse(url),
            headers: headers ?? {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeout, onTimeout: () {
        throw TimeoutException(
          'Timeout ao conectar em $url',
          timeout,
        );
      });

      return _handleResponse(response);
    } catch (e) {
      print('❌ Erro PUT: $e');
      rethrow;
    }
  }

  /// DELETE request com tratamento de erro
  static Future<dynamic> delete(
    String url, {
    Map<String, String>? headers,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      print('📤 DELETE: $url');
      
      final response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(timeout, onTimeout: () {
        throw TimeoutException(
          'Timeout ao conectar em $url',
          timeout,
        );
      });

      return _handleResponse(response);
    } catch (e) {
      print('❌ Erro DELETE: $e');
      rethrow;
    }
  }

  static String _formatErrorMessage(
    Map<String, dynamic> error,
    int statusCode,
  ) {
    final message =
        error['message']?.toString() ?? 'Erro na requisição ($statusCode)';
    final errors = error['errors'];

    if (errors is List && errors.isNotEmpty) {
      return '$message: ${errors.join(', ')}';
    }

    return message;
  }

  /// Trata resposta HTTP
  static dynamic _handleResponse(http.Response response) {
    print('📥 Status: ${response.statusCode}');
    print('📝 Response: ${response.body}');

    // Success responses (200-299)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);
    }

    // Client errors (400-499)
    if (response.statusCode >= 400 && response.statusCode < 500) {
      try {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        throw HttpException(
          _formatErrorMessage(error, response.statusCode),
          statusCode: response.statusCode,
        );
      } catch (e) {
        if (e is HttpException) rethrow;
        throw HttpException(
          'Erro na requisição: ${response.body}',
          statusCode: response.statusCode,
        );
      }
    }

    // Server errors (500+)
    throw HttpException(
      'Erro no servidor (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }
}

/// Exceção HTTP personalizada
class HttpException implements Exception {
  final String message;
  final int? statusCode;

  HttpException(
    this.message, {
    this.statusCode,
  });

  @override
  String toString() => message;
}
