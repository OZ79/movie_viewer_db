import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movielist_bloc/movielist_bloc.dart';
import 'package:movie_viewer_db/bloc/movielist_bloc/movielist_event.dart';
import 'package:movie_viewer_db/bloc/movielist_bloc/movielist_state.dart';
import 'package:movie_viewer_db/view/ui/movielist_item.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

import '../../config.dart';

class SearchScreen extends StatefulWidget {
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
    BlocProvider.of<MovieListBloc>(context)
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          //splashColor: Colors.transparent,
          //highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(children: [
            OutlineSearchBar(
              margin: EdgeInsets.all(5),
              hintText: 'SEARCH',
              borderRadius: BorderRadius.circular(15),
              borderWidth: 2,
              textStyle: TextStyle(fontSize: 20),
              onSearchButtonPressed: onSearchButtonPressed,
            ),
            BlocBuilder<MovieListBloc, MovieState>(builder: (context, state) {
              if (state is MovieListPagesBySearchLoadedState) {
                _isLoading = false;

                if (state.movies.isEmpty) {
                  return Expanded(
                      child: Center(
                          child: const Text('No results',
                              style: TextStyle(fontSize: 19))));
                }

                return Expanded(
                  child: ListView.builder(
                      itemExtent: 138,
                      itemCount: state.hasReachedMax
                          ? state.movies.length
                          : state.movies.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= state.movies.length) {
                          _loadPage(state.pages + 1);
                          return Center(
                              child: const CircularProgressIndicator());
                        } else {
                          final movie = state.movies[index];
                          return MovieIem(
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
        ),
      ),
    );
  }
}
