import 'dart:developer';

import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';
import 'package:home_assignment/barrel.dart';

class NewsRepository {
  NewsApiClient? _client;

  NewsRepository();

  Future<Map<String, dynamic>> fetchNews(List<NewsCard> news, int page, {String? q, String? to, String? from}) async {
    _client ??= NewsApiClient(apiKey: await readFile(), dio: Dio());
    Map<String, dynamic> response = await _client!.newsSearch(q: q, to: to, from: from, page: page);
    List<dynamic> articles = response['articles'];
    for (var element in articles) {
      news.add(NewsCard.fromJson(element));
    }
    log(response['totalResults'].toString());
    return {'news': news, 'page': page + 1, 'hasReachedMax': news.length >= response['totalResults']};
    // log(news.length.toString());
    // log(response['totalResults'].toString());
    // return news;
  }

  Future<String> readFile() async {
    String key = await rootBundle.loadString('assets/api_key.txt', cache: true);
    key = key.trim();
    return key;
  }
}
