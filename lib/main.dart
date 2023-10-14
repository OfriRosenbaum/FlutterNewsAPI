import 'package:flutter/material.dart';
import 'package:home_assignment/news_app.dart';
import 'package:home_assignment/news_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //"A new repository should not be created in RepositoryProvider.value",
    //so I create it here and pass it to the NewsApp widget.
    return NewsApp(repository: NewsRepository());
  }
}
