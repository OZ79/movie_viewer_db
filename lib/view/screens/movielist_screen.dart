import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_viewer_db/bloc/movielist_bloc/movielist_bloc.dart';
import 'package:movie_viewer_db/bloc/movielist_bloc/movielist_event.dart';
import 'package:movie_viewer_db/bloc/movielist_bloc/movielist_state.dart';
import 'package:movie_viewer_db/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:movie_viewer_db/data/PageStorageIndetifier.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/view/ui/InternetConnectionAlert.dart';
import 'package:movie_viewer_db/view/ui/button_bar.dart';
import 'package:movie_viewer_db/view/ui/movielist_item.dart';

import '../../config.dart';

class MovieListScreen extends StatefulWidget {
  MovieListScreen({key}) : super(key: key);

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen>
    with InternetConnectionAlert<MovieListScreen, MovieListBloc> {
  bool _isLoading = false;
  //bool _isItemSelected = false;
  MovieType _curentMovieType;
  // ignore: close_sinks
  MovieDetailBloc _movieDetailBloc;
  // ignore: close_sinks
  NavigationBloc _navigationBloc;

  @override
  void initState() {
    super.initState();

    _movieDetailBloc = BlocProvider.of<MovieDetailBloc>(context);
    _navigationBloc = BlocProvider.of<NavigationBloc>(context);

    final movieType = BlocProvider.of<NavigationBloc>(context).state.movieType;
    if (movieType == MovieType.none) {
      _curentMovieType = PageStorage.of(context).readState(context,
              identifier: PageStorageIndetifier.curentMovieType) ??
          MovieType.popular;
    } else {
      _curentMovieType = movieType;
    }

    if (BlocProvider.of<MovieListBloc>(context).state is MovieInitialState) {
      _loadPage();
    }
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
    _curentMovieType = mapIndexToMovieType(index);
    _isLoading = false;

    _loadPage();

    PageStorage.of(context).writeState(context, _curentMovieType,
        identifier: PageStorageIndetifier.curentMovieType);
  }

  @override
  MovieListBloc get bloc => BlocProvider.of<MovieListBloc>(context);

  @override
  Widget getContent() {
    return Column(children: [
      const SizedBox(height: 15),
      ButtonAppBar(_onItemSelected,
          selectedIndex: mapMovieTypeToIndex(_curentMovieType)),
      const SizedBox(height: 15),
      BlocBuilder<MovieListBloc, MovieState>(builder: (context, state) {
        if (state is MovieListPagesLoadedState) {
          if (state.movieType == _curentMovieType) {
            _isLoading = false;
            return Expanded(
              child: ListView.builder(
                  key: PageStorageKey('ms_ListView_$_curentMovieType'),
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
                        key:
                            ValueKey('ms_MovieItem_${_curentMovieType}_$index'),
                        movieId: movie.id,
                        title: movie.title ?? 'no info',
                        releaseDate: movie.releaseDate ?? '',
                        overview: movie.overview ?? 'no info',
                        imageUrl: "$IMAGE_URL_92${movie.poster}",
                        rating: movie.rating ?? 0,
                        movieDetailBloc: _movieDetailBloc,
                        navigationBloc: _navigationBloc,
                      );
                    }
                  }),
            );
          }
        }
        return Expanded(
            child: const Center(child: const CircularProgressIndicator()));
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
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

int mapMovieTypeToIndex(MovieType type) {
  switch (type) {
    case MovieType.popular:
      return 0;
      break;
    case MovieType.now_playing:
      return 1;
      break;
    case MovieType.upcoming:
      return 2;
      break;
    case MovieType.top_rated:
      return 3;
      break;
    default:
      return 0;
  }
}
