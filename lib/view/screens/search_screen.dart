import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/moviesearch_bloc/moviesearch_bloc.dart';
import 'package:movie_viewer_db/bloc/moviesearch_bloc/moviesearch_event.dart';
import 'package:movie_viewer_db/bloc/moviesearch_bloc/moviesearch_state.dart';
import 'package:movie_viewer_db/view/ui/movielist_item.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

import '../../config.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  bool _isLoading = false;
  String _query;

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
    _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey('ss_GestureDetector'),
      behavior: HitTestBehavior.opaque,
      //splashColor: Colors.transparent,
      //highlightColor: Colors.transparent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(children: [
        OutlineSearchBar(
          key: ValueKey('ss_OutlineSearchBar'),
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
                  key: ValueKey('ss_ListView'),
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
                      );
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
