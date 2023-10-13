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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () => _newsBloc.add(FetchNewsEvent(
                repository: RepositoryProvider.of(context),
                news: [],
                q: 'coca cola',
                from: "2023-9-25",
                to: "2023-9-27")),
            child: const Text("Fetch news")),
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: CircularProgressIndicator(),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text("Loading..."),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
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

  Widget _buildErrorState(NewsErrorState state) {
    return Center(
      child: Text(state.message),
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
            FToast().init(context).showToast(
                    child: Container(
                  color: Colors.red,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text(state.message),
                ));
          }
        },
        builder: (context, state) {
          if (state is NewsInitialState) {
            return _buildInitialState();
          } else if (state is NewsLoadingState) {
            return _buildLoadingState();
          } else if (state is NewsLoadedState) {
            return _buildLoadedState(state);
          } else if (state is NewsErrorState) {
            return _buildErrorState(state);
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
