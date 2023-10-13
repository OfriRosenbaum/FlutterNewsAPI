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
  final String message;
  NewsErrorState({required this.message});
}
