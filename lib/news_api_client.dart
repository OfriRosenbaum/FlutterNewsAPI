import 'dart:async';

import 'package:dio/dio.dart';

class NewsApiClient {
  NewsApiClient({required this.apiKey, required this.dio}) {
    dio.options.baseUrl = _baseUrl;
    dio.options.headers = {
      'Authorization': apiKey,
    };
    dio.options.connectTimeout = const Duration(seconds: 10);
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
    response = await dio.get(_path, queryParameters: {
      'q': q,
      'from': from,
      'to': to,
      'page': page,
      'pageSize': 20, //Max is 100, can be changed to whatever
    });
    final data = response.data;
    return data;
  }
}
