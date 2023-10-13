import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_assignment/bloc/news_bloc.dart';
import 'package:home_assignment/news_repository.dart';
import 'package:home_assignment/search_page.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({required this.repository, super.key});

  final NewsRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider<NewsBloc>.value(value: NewsBloc(), child: const NewsAppView()),
    );
  }
}

class NewsAppView extends StatelessWidget {
  const NewsAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SearchPage(),
    );
  }
}
