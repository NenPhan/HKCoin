import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'translation_parser.dart'; 

typedef LocalizationLogger = void Function(
  String message, {
  Object? error,
  StackTrace? stackTrace,
});

class HttpTranslationLoader {
  HttpTranslationLoader(
    this.baseUrl, {
    http.Client? client,
    this.timeout = const Duration(seconds: 5),
    this.logger,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  final Duration timeout;
  final LocalizationLogger? logger;

  final Map<String, Map<String, dynamic>> _memoryCache = {};

  Future<Map<String, dynamic>> load(
    String localeKey, {
    bool forceRefresh = false,
  }) async {
    // 1️⃣ memory cache (nhanh nhất)
    if (!forceRefresh && _memoryCache.containsKey(localeKey)) {
      logger?.call("[Localization] Memory cache hit: $localeKey");
      return _memoryCache[localeKey]!;
    }

    final url = "$baseUrl/$localeKey.json";
    logger?.call("[Localization] Fetching: $url");

    try {
      final resp = await _client
          .get(Uri.parse(url))
          .timeout(timeout);

      if (resp.statusCode == 200) {
        final body = utf8.decode(resp.bodyBytes);
        final parsed = await compute(parseTranslations, body);
         // ✅ log đúng kiểu String      
        _memoryCache[localeKey] = parsed;

        return _memoryCache[localeKey]!;
      }

      throw Exception("Server returned ${resp.statusCode}");
    } catch (e, st) {
      logger?.call("HTTP load error for $localeKey", error: e, stackTrace: st);
      rethrow;
    }
  }
}


