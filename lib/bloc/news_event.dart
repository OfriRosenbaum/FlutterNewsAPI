import 'package:flutter/material.dart';
import 'package:home_assignment/barrel.dart';
import 'package:home_assignment/news_repository.dart';

sealed class NewsEvent {}

class NewsInitialEvent extends NewsEvent {}

class MoveToDetailsEvent extends NewsEvent {
  final BuildContext context;
  final NewsCard newsCard;
  MoveToDetailsEvent({required this.context, required this.newsCard});
}

class FetchMoreNewsEvent extends NewsEvent {
  final NewsRepository repository;
  final List<NewsCard> news;
  final String? q;
  final String? to;
  final String? from;
  FetchMoreNewsEvent({required this.repository, required this.news, this.q, this.to, this.from});
}

class FetchNewNewsEvent extends NewsEvent {
  final NewsRepository repository;
  final List<NewsCard> news;
  final String? q;
  final String? to;
  final String? from;
  FetchNewNewsEvent({required this.repository, required this.news, this.q, this.to, this.from});
}
