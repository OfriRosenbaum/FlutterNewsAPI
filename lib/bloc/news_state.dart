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

  NewsErrorState.fromCode(String code) {
    switch (code) {
      case 'apiKeyDisabled':
        message = 'Your API key has been disabled.';
        break;
      case 'apiKeyExhausted':
        message = 'Your API key has no more requests available.';
        break;
      case 'apiKeyInvalid':
        message = 'Your API key is invalid. Please check it in assets/api_key.txt file.';
        break;
      case 'apiKeyMissing':
        message = 'Your API key is missing. Please add it to assets/api_key.txt file.';
        break;
      case 'parameterInvalid':
        message = 'You\'ve included a parameter in your request which is currently not supported.';
        break;
      case 'parametersMissing':
        message = 'Required parameters are missing in your request. Try adding keywords in the search field.';
        break;
      case 'rateLimited':
        message = 'You have been rate limited. Back off for a while before trying the request again.';
        break;
      case 'sourcesTooMany':
        message =
            'You have requested too many sources in a single request. Try splitting the request into 2 smaller requests.';
        break;
      case 'sourceDoesNotExist':
        message = 'You have requested a source which does not exist.';
        break;
      case 'unexpectedError':
        message = 'Unexpected error. This shouldn\'t have happened. Please try again later.';
        break;
      default:
        message = 'Unknown error';
    }
  }

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
          message = 'Your search is too broad. Try adding more keywords.';
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
