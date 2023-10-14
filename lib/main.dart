import 'package:flutter/material.dart';
import 'package:home_assignment/news_app.dart';
import 'package:home_assignment/news_repository.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //"A new repository should not be created in RepositoryProvider.value", so I create it here and pass it to NewsApp.
    return NewsApp(repository: NewsRepository());
  }
}
