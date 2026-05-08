import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class CachedSvgHttpClient extends http.BaseClient {
  CachedSvgHttpClient({
    required this.cacheManager,
    this.cacheKey,
  });

  final BaseCacheManager cacheManager;
  final String? cacheKey;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (request.method != 'GET') {
      return http.Response('', 405, request: request).streamedResponse;
    }

    final url = request.url.toString();
    final file = await cacheManager.getSingleFile(
      url,
      key: cacheKey ?? url,
      headers: request.headers,
    );
    final bytes = await file.readAsBytes();

    return http.StreamedResponse(
      Stream.value(bytes),
      200,
      contentLength: bytes.length,
      request: request,
    );
  }
}

extension on http.Response {
  http.StreamedResponse get streamedResponse {
    return http.StreamedResponse(
      Stream.value(bodyBytes),
      statusCode,
      contentLength: bodyBytes.length,
      request: request,
      headers: headers,
      reasonPhrase: reasonPhrase,
      isRedirect: isRedirect,
      persistentConnection: persistentConnection,
    );
  }
}
