import 'dart:async';

import 'package:dio/dio.dart';

import 'news_event.dart';
import 'news_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitialState()) {
    on<NewsInitialEvent>(onNewsInitialEvent);
    on<FetchNewsEvent>(onFetchNewsEvent);
  }

  FutureOr<void> onNewsInitialEvent(NewsInitialEvent event, Emitter<NewsState> emit) async {
    emit(NewsInitialState());
  }

  Future<void> onFetchNewsEvent(FetchNewsEvent event, Emitter<NewsState> emit) async {
    if (state is NewsLoadedState) {
      var newState = state as NewsLoadedState;
      if (!newState.hasReachedMax) {
        newState.loading = true;
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
            emit(NewsErrorState.fromException(e));
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
        emit(NewsLoadedState(news: results['news'], page: 1, hasReachedMax: results['hasReachedMax'], loading: false));
      } catch (e) {
        if (e is DioException) {
          emit(NewsErrorState.fromException(e));
        } else {
          emit(NewsErrorState(message: e.toString()));
        }
      }
    }
  }
}
