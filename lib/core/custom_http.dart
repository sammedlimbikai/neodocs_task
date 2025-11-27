import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../envornment_config.dart';

class CustomHttp extends http.BaseClient {
  static CustomHttp? _instance;
  final http.Client _client = http.Client();
  final _log = Logger("CustomHttp");

  CustomHttp._();

  static CustomHttp get instance {
    _instance ??= CustomHttp._();
    return _instance!;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Add base URL if needed
    final url = request.url.toString();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      final baseUrl = EnvironmentConfig.baseUrl;
      final endpoint = url.startsWith('/') ? url : '/$url';
      final newUrl = baseUrl.endsWith('/')
          ? '$baseUrl${endpoint.substring(1)}'
          : '$baseUrl$endpoint';
      request = _updateUrl(request, Uri.parse(newUrl));
    }

    // Add headers
    request.headers.addAll({
      'Authorization': 'Bearer ${EnvironmentConfig.authToken}',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // Log request
    _log.fine('--> ${request.method} ${request.url}');
    _log.fine('--> Headers: ${request.headers}');
    if (request is http.Request && request.body.isNotEmpty) {
      _log.fine('--> Body: ${request.body}');
    }

    try {
      // Send with timeout
      final streamedResponse = await _client
          .send(request)
          .timeout(const Duration(seconds: 30));

      // Read response body
      final responseBytes = await streamedResponse.stream.toBytes();
      final responseBody = String.fromCharCodes(responseBytes);

      // Log response
      _log.fine('<-- ${streamedResponse.statusCode} ${request.url}');
      _log.fine('<-- Headers: ${streamedResponse.headers}');
      _log.fine('<-- Body: $responseBody');

      return http.StreamedResponse(
        http.ByteStream.fromBytes(responseBytes),
        streamedResponse.statusCode,
        contentLength: responseBytes.length,
        request: streamedResponse.request,
        headers: streamedResponse.headers,
        isRedirect: streamedResponse.isRedirect,
        persistentConnection: streamedResponse.persistentConnection,
        reasonPhrase: streamedResponse.reasonPhrase,
      );
    } catch (e) {
      _log.fine('✗ Error: $e');
      rethrow;
    }
  }

  http.BaseRequest _updateUrl(http.BaseRequest request, Uri newUri) {
    if (request is http.Request) {
      return http.Request(request.method, newUri)
        ..bodyBytes = request.bodyBytes
        ..headers.addAll(request.headers);
    }
    return request;
  }
}
