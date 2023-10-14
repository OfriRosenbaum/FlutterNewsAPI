import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_assignment/barrel.dart';
import 'package:home_assignment/bloc/news_bloc.dart';
import 'package:home_assignment/bloc/news_event.dart';
import 'package:home_assignment/bloc/news_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const String routeName = '/search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late NewsBloc _newsBloc;
  final _screenScrollController = ScrollController();
  final _newsScrollController = ScrollController();
  bool showScrollTopButton = false;
  List<NewsCard> news = [];
  TextEditingController textController = TextEditingController();
  final _color = Colors.white54;
  final _cardColor = Colors.white70;

  //Free NewsAPI search is limited to 1 month back with free API key. Substract 5 years instead if you have a paid key.
  DateTime selectedStartDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime selectedEndDate = DateTime.now();

  String? lastKeywords;
  String? lastFrom;
  String? lastTo;

  @override
  void initState() {
    super.initState();
    _newsBloc = BlocProvider.of(context);
    _newsBloc.add(NewsInitialEvent());
    _screenScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _screenScrollController.removeListener(_onScroll);
    _newsScrollController.dispose();
    _screenScrollController.dispose();
    super.dispose();
  }

  String dateToString(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Widget _buildInitialState() {
    return _searchBar();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Text("Loading..."),
        ],
      ),
    );
  }

  Widget _buildLoadedState(NewsLoadedState state) {
    news = state.news;
    return news.isEmpty
        ? Column(children: [
            _searchBar(),
            const SizedBox(
              height: 20,
            ),
            const Text("No news found"),
          ])
        : SingleChildScrollView(
            controller: _screenScrollController,
            child: Column(children: [
              _searchBar(),
              ListView.builder(
                itemCount: state.hasReachedMax ? news.length : news.length + 1,
                itemBuilder: (context, index) {
                  return index >= news.length
                      ? const Center(child: CircularProgressIndicator())
                      : getNewsCard(news[index]);
                },
                controller: _newsScrollController,
                shrinkWrap: true,
              ),
            ]),
          );
  }

  Widget getNewsCard(NewsCard newsCard) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    Widget image;
    if (newsCard.urlToImage != null) {
      try {
        image = Image.network(
          newsCard.urlToImage!,
          width: screenWidth * 0.35,
          height: screenHeight * 0.35,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: screenWidth * 0.35),
        );
      } catch (e) {
        image = Icon(Icons.image_not_supported, size: screenWidth * 0.35);
      }
    } else {
      image = Icon(Icons.image_not_supported, size: screenWidth * 0.35);
    }
    return GestureDetector(
      onTap: () => _newsBloc.add(MoveToDetailsEvent(context: context, newsCard: newsCard)),
      child: Card(
        color: _cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  children: [
                    Text(newsCard.title ?? 'No title'),
                    Text(
                      newsCard.author ?? 'No author',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16.0),
                    Text(newsCard.description ?? 'No description'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSearchDialog() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Search Keywords'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Advanced search is supported! What does it mean?'),
                SizedBox(height: 8.0),
                Text('Surround phrases with quotes (") for exact match.'),
                SizedBox(height: 8.0),
                Text('Prepend words or phrases that must appear with a + symbol. Eg: +bitcoin.'),
                SizedBox(height: 8.0),
                Text('Prepend words that must not appear with a - symbol. Eg: -bitcoin.'),
                SizedBox(height: 8.0),
                Text(
                    'Alternatively you can use the AND / OR / NOT keywords, and optionally group these with parenthesis. Eg: crypto AND (ethereum OR litecoin) NOT bitcoin.'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        }));
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Search Text',
                ),
                validator: (value) {
                  if (value == null) return null;
                  if (value.isEmpty) {
                    return 'Please enter search text';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8.0),
            IconButton(
              onPressed: showSearchDialog,
              icon: const Icon(Icons.info_outline),
              tooltip: 'Advanced Search',
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  'Start Date: ${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: selectedStartDate,
                    firstDate: selectedStartDate,
                    lastDate: selectedEndDate,
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      setState(() {
                        selectedStartDate = pickedDate;
                      });
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('End Date: ${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: selectedEndDate,
                    firstDate: selectedStartDate,
                    lastDate: selectedEndDate,
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      setState(() {
                        selectedEndDate = pickedDate;
                      });
                    }
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(onPressed: fetchNewNews, child: const Text("Fetch news")),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        title: const Text('News App'),
      ),
      backgroundColor: _color,
      floatingActionButton: Visibility(
        visible: showScrollTopButton,
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
      body: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is NewsErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FToast().init(context).showToast(
                  toastDuration: const Duration(seconds: 5),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration:
                        const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.red),
                    child: Text(
                      state.message,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ));
            });
          }
        },
        builder: (context, state) {
          if (state is NewsInitialState) {
            return _buildInitialState();
          } else if (state is NewsLoadingState) {
            return _buildLoadingState();
          } else if (state is NewsLoadedState) {
            return _buildLoadedState(state);
          } else {
            return _buildInitialState();
          }
        },
      ),
    );
  }

  void fetchNewNews() {
    lastKeywords = textController.text;
    lastFrom = dateToString(selectedStartDate);
    lastTo = dateToString(selectedEndDate);
    _newsBloc.add(FetchNewNewsEvent(
        repository: RepositoryProvider.of(context), news: [], q: lastKeywords, from: lastFrom, to: lastTo));
  }

  void _scrollToTop() {
    if (!_screenScrollController.hasClients) return;
    _screenScrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _onScroll() {
    if (_screenScrollController.offset > 100) {
      if (!showScrollTopButton) {
        showScrollTopButton = true;
        setState(() {});
      }
    } else {
      if (showScrollTopButton) {
        showScrollTopButton = false;
        setState(() {});
      }
    }
    if (_isBottom) {
      if (_newsBloc.state is NewsLoadedState) {
        var state = _newsBloc.state as NewsLoadedState;
        if (state.hasReachedMax || state.loading) {
          return;
        }
        context.read<NewsBloc>().add(FetchMoreNewsEvent(
            repository: RepositoryProvider.of(context), news: news, q: lastKeywords, from: lastFrom, to: lastTo));
      }
    }
  }

  bool get _isBottom {
    if (!_screenScrollController.hasClients) return false;
    final maxScroll = _screenScrollController.position.maxScrollExtent;
    final currentScroll = _screenScrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
