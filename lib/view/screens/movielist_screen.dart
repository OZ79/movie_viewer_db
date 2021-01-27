import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movielist_bloc/movielist_bloc.dart';
import 'package:movie_viewer_db/bloc/movielist_bloc/movielist_event.dart';
import 'package:movie_viewer_db/bloc/movielist_bloc/movielist_state.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/view/ui/button_bar.dart';
import 'package:movie_viewer_db/view/ui/movielist_item.dart';

import '../../config.dart';

class MovieListScreen extends StatefulWidget {
  MovieListScreen();

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isItemSelected = false;
  MovieType _curentMovieType = MovieType.popular;
  Map<MovieType, double> _scrollPosition = {};

  @override
  void initState() {
    super.initState();

    _loadPage();
  }

  void _loadPage([int page = 1]) {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    BlocProvider.of<MovieListBloc>(context)
      ..add(FetchMovieListPageEvent(movieType: _curentMovieType, page: page));
  }

  void _onItemSelected(int index) {
    if (_scrollController.hasClients) {
      _scrollPosition[_curentMovieType] = _scrollController.position.pixels;
    }

    _curentMovieType = mapIndexToMovieType(index);
    _isLoading = false;
    _isItemSelected = true;

    _loadPage();
  }

  void _jumpTo() {
    if (_scrollController.hasClients && _isItemSelected) {
      _isItemSelected = false;
      _scrollController.jumpTo(_scrollPosition[_curentMovieType] ?? 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 15),
      ButtonAppBar(_onItemSelected),
      const SizedBox(height: 15),
      BlocBuilder<MovieListBloc, MovieState>(builder: (context, state) {
        if (state is MovieListPagesLoadedState) {
          if (_scrollController.hasClients) {
            _jumpTo();
          } else {
            Timer.run(() => _jumpTo());
          }

          _isLoading = false;
          return Expanded(
            child: ListView.builder(
                controller: _scrollController,
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
        return Expanded(
            child: Center(child: const CircularProgressIndicator()));
      }),
    ]);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

MovieType mapIndexToMovieType(int index) {
  switch (index) {
    case 0:
      return MovieType.popular;
      break;
    case 1:
      return MovieType.now_playing;
      break;
    case 2:
      return MovieType.upcoming;
      break;
    case 3:
      return MovieType.top_rated;
      break;
    default:
      return MovieType.popular;
  }
}
