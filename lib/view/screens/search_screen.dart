import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_viewer_db/bloc/moviesearch_bloc/moviesearch_bloc.dart';
import 'package:movie_viewer_db/bloc/moviesearch_bloc/moviesearch_event.dart';
import 'package:movie_viewer_db/bloc/moviesearch_bloc/moviesearch_state.dart';
import 'package:movie_viewer_db/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:movie_viewer_db/view/ui/movielist_item.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

import '../../config.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final _textController = TextEditingController();
  bool _isLoading = false;
  String _query;
  // ignore: close_sinks
  MovieDetailBloc _movieDetailBloc;
  // ignore: close_sinks
  NavigationBloc _navigationBloc;

  @override
  void initState() {
    super.initState();

    _movieDetailBloc = BlocProvider.of<MovieDetailBloc>(context);
    _navigationBloc = BlocProvider.of<NavigationBloc>(context);

    if (BlocProvider.of<MovieSearchBloc>(context).state
        is MovieListPagesBySearchLoadedState) {
      _query = (BlocProvider.of<MovieSearchBloc>(context).state
              as MovieListPagesBySearchLoadedState)
          .query;
      _textController.text = _query;
    }
  }

  void _loadPage([int page = 1]) {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    BlocProvider.of<MovieSearchBloc>(context)
      ..add(FetchMovieListPageBySearchEvent(query: _query, page: page));
  }

  void onSearchButtonPressed(String value) {
    if (_isLoading || value == _query || value.isEmpty) {
      return;
    }
    _query = value;

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    _loadPage();
  }

  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(children: [
        OutlineSearchBar(
          textEditingController: _textController,
          margin: const EdgeInsets.all(5),
          hintText: 'Search',
          borderRadius: BorderRadius.circular(15),
          borderWidth: 2,
          textStyle: const TextStyle(fontSize: 20),
          onSearchButtonPressed: onSearchButtonPressed,
        ),
        BlocBuilder<MovieSearchBloc, MovieState>(builder: (context, state) {
          if (state is MovieListPagesBySearchLoadedState) {
            _isLoading = false;

            if (state.movies.isEmpty) {
              return const Expanded(
                  child: const Center(
                      child: const Text('No results',
                          style: const TextStyle(fontSize: 19))));
            }

            return Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  key: PageStorageKey('ss_ListView'),
                  itemExtent: 138,
                  itemCount: state.hasReachedMax
                      ? state.movies.length
                      : state.movies.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= state.movies.length) {
                      _loadPage(state.pages + 1);
                      return Center(child: const CircularProgressIndicator());
                    } else {
                      final movie = state.movies[index];
                      return MovieItem(
                          key: ValueKey('ss_$index'),
                          movieId: movie.id,
                          title: movie.title ?? 'no info',
                          releaseDate: movie.releaseDate ?? '',
                          overview: movie.overview ?? 'no info',
                          imageUrl: "$IMAGE_URL_92${movie.poster}",
                          rating: movie.rating ?? 0,
                          movieDetailBloc: _movieDetailBloc,
                          navigationBloc: _navigationBloc);
                    }
                  }),
            );
          }
          if (state is MovieLoadingState) {
            return Expanded(
                child: Center(child: const CircularProgressIndicator()));
          }
          if (state is MovieErrorState) {
            _isLoading = false;
            return Expanded(
                child: Center(
                    child: const Text('No results',
                        style: TextStyle(fontSize: 19))));
          }
          return Expanded(
              child: Center(
            child: const Text(
              'No results',
              style: TextStyle(fontSize: 19),
            ),
          ));
        }),
      ]),
    );
  }
}
