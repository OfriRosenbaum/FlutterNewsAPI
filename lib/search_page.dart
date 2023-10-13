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
  final _scrollController = ScrollController();
  List<NewsCard> news = [];

  @override
  void initState() {
    super.initState();
    _newsBloc = BlocProvider.of(context);
    _newsBloc.add(NewsInitialEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildInitialState() {
    return Center(
      child: ElevatedButton(
          onPressed: () => _newsBloc.add(FetchNewsEvent(
              repository: RepositoryProvider.of(context),
              news: [],
              q: 'coca cola',
              from: "2023-9-25",
              to: "2023-9-27")),
          child: const Text("Fetch news")),
    );
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
    return ListView.builder(
      itemCount: state.hasReachedMax ? news.length : news.length + 1,
      itemBuilder: (context, index) {
        return index >= news.length
            ? const Center(child: CircularProgressIndicator())
            : news[index].showNewsCard(context);
      },
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search Page",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
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

  void _onScroll() {
    if (_isBottom) {
      if (_newsBloc.state is NewsLoadedState) {
        var state = _newsBloc.state as NewsLoadedState;
        if (state.hasReachedMax || state.loading) {
          return;
        }
        context.read<NewsBloc>().add(FetchNewsEvent(
            repository: RepositoryProvider.of(context),
            news: news,
            q: 'coca cola',
            from: "2023-9-25",
            to: "2023-9-27"));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
