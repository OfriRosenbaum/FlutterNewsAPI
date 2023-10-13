import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

class NewsCardRequestException implements Exception {}

class NewsApiClient {
  NewsApiClient({required this.apiKey, required this.dio}) {
    dio.options.baseUrl = _baseUrl;
    dio.options.headers = {
      'Authorization': apiKey,
    };
  }

  final Dio dio;
  final String apiKey;
  static const _baseUrl = 'https://newsapi.org';
  static const _path = '/v2/everything';

  Future<Map<String, dynamic>> newsSearch({
    String? q,
    String? from,
    String? to,
    int? page,
  }) async {
    Response response;
    try {
      response = await dio.get(_path, queryParameters: {
        'q': q,
        'from': from,
        'to': to,
        'page': page,
      });
    } catch (e) {
      log('$e');
      throw NewsCardRequestException();
    }
    final data = response.data;
    return data;
  }
}