import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:home_assignment/barrel.dart';
import 'package:home_assignment/details_page.dart';
import 'package:hive/hive.dart';

import 'news_event.dart';
import 'news_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitialState()) {
    on<NewsInitialEvent>(onNewsInitialEvent);
    on<FetchMoreNewsEvent>(onFetchMoreNewsEvent);
    on<MoveToDetailsEvent>(onMoveToDetailsEvent);
    on<FetchNewNewsEvent>(onFetchNewNewsEvent);
  }

  FutureOr<void> onNewsInitialEvent(NewsInitialEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoadingState());
    try {
      var box = await Hive.openBox('news');
      String q = box.get('q');
      String from = box.get('from');
      String to = box.get('to');
      int page = box.get('page') ?? 1;
      int results = box.get('results') ?? 0;
      List<NewsCard> news = [];
      List<dynamic> articles = await box.get('articles');
      for (var element in articles) {
        if (element is Map<dynamic, dynamic>) {
          news.add(NewsCard.fromJson(Map<String, dynamic>.from(element)));
        }
      }
      emit(NewsInitialLoadState(
          q: q, from: from, to: to, news: news, page: page, hasReachedMax: news.length >= results));
    } catch (e) {
      log('No cache found in Hive. Error: $e');
      emit(NewsInitialState());
    }
  }

  FutureOr<void> onMoveToDetailsEvent(MoveToDetailsEvent event, Emitter<NewsState> emit) async {
    Navigator.of(event.context).push(
      MaterialPageRoute(
        builder: (context) => DetailsPage(newsCard: event.newsCard),
      ),
    );
  }

  Future<void> onFetchNewNewsEvent(FetchNewNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoadingState());
    try {
      Map<String, dynamic> results =
          await event.repository.fetchNews(event.news, 1, q: event.q, to: event.to, from: event.from);
      if (results['status'] == 'error') {
        throw results['error'];
      }
      saveInHive(event.q ?? '', event.from ?? '', event.to ?? '', results['page'], results['results'], results['news']);
      emit(NewsLoadedState(news: results['news'], page: 1, hasReachedMax: results['hasReachedMax'], loading: false));
    } catch (e) {
      if (e is DioException) {
        var code = e.response?.data['code'];
        if (code != null) {
          emit(NewsErrorState.fromCode(code, e.response?.data['message'] ?? 'Unknown error'));
        } else {
          emit(NewsErrorState.fromException(e));
        }
      } else {
        emit(NewsErrorState(message: e.toString()));
      }
      emit(NewsInitialState());
    }
  }

  Future<void> onFetchMoreNewsEvent(FetchMoreNewsEvent event, Emitter<NewsState> emit) async {
    if (state is NewsLoadedState) {
      var newState = state as NewsLoadedState;
      if (newState.loading) return;
      if (!newState.hasReachedMax) {
        newState.loading = true;
        try {
          Map<String, dynamic> results = await event.repository
              .fetchNews(event.news, newState.page + 1, q: event.q, to: event.to, from: event.from);
          if (results['status'] == 'error') {
            throw results['error'];
          }
          saveInHive(
              event.q ?? '', event.from ?? '', event.to ?? '', results['page'], results['results'], results['news']);
          emit(NewsLoadedState(
              news: results['news'], page: results['page'], hasReachedMax: results['hasReachedMax'], loading: false));
        } catch (e) {
          if (e is DioException) {
            var code = e.response?.data['code'];
            if (code != null) {
              emit(NewsErrorState.fromCode(code, e.response?.data['message'] ?? 'Unknown error'));
            } else {
              emit(NewsErrorState.fromException(e));
            }
          } else {
            emit(NewsErrorState(message: e.toString()));
          }
        }
      }
    } else {
      emit(NewsLoadingState());
      try {
        Map<String, dynamic> results =
            await event.repository.fetchNews(event.news, 1, q: event.q, to: event.to, from: event.from);
        if (results['status'] == 'error') {
          throw results['error'];
        }
        saveInHive(event.q ?? '', event.from ?? '', event.to ?? '', 1, results['results'], results['news']);
        emit(NewsLoadedState(news: results['news'], page: 1, hasReachedMax: results['hasReachedMax'], loading: false));
      } catch (e) {
        if (e is DioException) {
          var code = e.response?.data['code'];
          if (code != null) {
            emit(NewsErrorState.fromCode(code, e.response?.data['message'] ?? 'Unknown error'));
          } else {
            emit(NewsErrorState.fromException(e));
          }
        } else {
          emit(NewsErrorState(message: e.toString()));
        }
      }
    }
  }

  void saveInHive(String q, String from, String to, int page, int results, List<NewsCard> news) async {
    try {
      var box = await Hive.openBox('news');
      box.clear();
      box.put('q', q);
      box.put('from', from);
      box.put('to', to);
      box.put('page', page);
      box.put('results', results);
      List<Map<String, dynamic>> articles = [];
      for (var element in news) {
        articles.add(element.toJson());
      }
      box.put('articles', articles);
    } catch (e) {
      log('Error caching in hive: $e');
    }
  }
}
