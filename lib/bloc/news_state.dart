import 'package:dio/dio.dart';

import '../news_card.dart';

abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<NewsCard> news;
  int page = 1;
  int results = 0;
  bool hasReachedMax = false;
  bool loading = false;
  NewsLoadedState({required this.news, required this.page, required this.hasReachedMax, required this.loading});
}

class NewsErrorState extends NewsState {
  late String message;
  NewsErrorState({required this.message});

  NewsErrorState.fromException(Exception e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          message = 'Connection timeout';
          break;
        case DioExceptionType.sendTimeout:
          message = 'Send timeout';
          break;
        case DioExceptionType.receiveTimeout:
          message = 'Receive timeout';
          break;
        case DioExceptionType.badResponse:
          message = 'Response error';
          break;
        case DioExceptionType.cancel:
          message = 'Request cancelled';
          break;
        case DioExceptionType.badCertificate:
          message = 'Bad certificate';
          break;
        case DioExceptionType.connectionError:
          message = 'Connection error';
          break;
        case DioExceptionType.unknown:
          message = 'Unknown error';
          break;
        default:
          message = 'Unknown error';
      }
      return;
    }
    message = e.toString();
  }
}
