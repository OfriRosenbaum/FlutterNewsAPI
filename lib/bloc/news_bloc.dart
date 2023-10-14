import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:home_assignment/details_page.dart';

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
    emit(NewsInitialState());
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
      log('Hey this is new news event. State is: $state');
      Map<String, dynamic> results =
          await event.repository.fetchNews(event.news, 1, q: event.q, to: event.to, from: event.from);
      if (results['status'] == 'error') {
        throw results['error'];
      }
      emit(NewsLoadedState(news: results['news'], page: 1, hasReachedMax: results['hasReachedMax'], loading: false));
    } catch (e) {
      if (e is DioException) {
        var code = e.response?.data['code'];
        if (code != null) {
          emit(NewsErrorState.fromCode(code));
        } else {
          emit(NewsErrorState.fromException(e));
        }
      } else {
        emit(NewsErrorState(message: e.toString()));
      }
    }
  }

  Future<void> onFetchMoreNewsEvent(FetchMoreNewsEvent event, Emitter<NewsState> emit) async {
    if (state is NewsLoadedState) {
      var newState = state as NewsLoadedState;
      if (!newState.hasReachedMax && !newState.loading) {
        newState.loading = true;
        emit(newState);
        try {
          Map<String, dynamic> results = await event.repository
              .fetchNews(event.news, newState.page + 1, q: event.q, to: event.to, from: event.from);
          if (results['status'] == 'error') {
            throw results['error'];
          }
          emit(NewsLoadedState(
              news: results['news'], page: results['page'], hasReachedMax: results['hasReachedMax'], loading: false));
        } catch (e) {
          if (e is DioException) {
            var code = e.response?.data['code'];
            if (code != null) {
              emit(NewsErrorState.fromCode(code));
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
        log('Hey this is more news event. State is: $state');
        Map<String, dynamic> results =
            await event.repository.fetchNews(event.news, 1, q: event.q, to: event.to, from: event.from);
        if (results['status'] == 'error') {
          throw results['error'];
        }
        emit(NewsLoadedState(news: results['news'], page: 1, hasReachedMax: results['hasReachedMax'], loading: false));
      } catch (e) {
        if (e is DioException) {
          var code = e.response?.data['code'];
          if (code != null) {
            emit(NewsErrorState.fromCode(code));
          } else {
            emit(NewsErrorState.fromException(e));
          }
        } else {
          emit(NewsErrorState(message: e.toString()));
        }
      }
    }
  }
}
