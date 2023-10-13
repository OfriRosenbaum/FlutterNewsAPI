import 'package:home_assignment/barrel.dart';
import 'package:home_assignment/news_repository.dart';

sealed class NewsEvent {}

class NewsInitialEvent extends NewsEvent {}

class FetchNewsEvent extends NewsEvent {
  final NewsRepository repository;
  final List<NewsCard> news;
  final String? q;
  final String? to;
  final String? from;
  FetchNewsEvent({required this.repository, required this.news, this.q, this.to, this.from});
}
