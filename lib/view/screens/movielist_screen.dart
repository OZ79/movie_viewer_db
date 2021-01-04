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
import 'package:movie_viewer_db/view/ui/star_rating.dart';

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

class MovieIem extends StatelessWidget {
  final int movieId;
  final String title;
  final String releaseDate;
  final String overview;
  final String imageUrl;
  final double rating;

  const MovieIem(
      {@required this.movieId,
      @required this.title,
      @required this.releaseDate,
      @required this.overview,
      @required this.imageUrl,
      @required this.rating});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final imageHeight = 138.0;
    return GestureDetector(
      onTap: () {
        print(movieId);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 92,
                  height: imageHeight,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                      child: !imageUrl.contains("null")
                          ? Image(
                              fit: BoxFit.cover, image: NetworkImage(imageUrl))
                          : const Icon(Icons.movie))),
              const SizedBox(width: 8),
              Container(
                //color: Colors.yellow,
                height: imageHeight,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getFontSize(context) + 1,
                              color: const Color(0xFF1E88E5)),
                        ),
                      ),
                      Text(
                        releaseDate,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: getFontSize(context) - 2,
                            color: const Color(0xFF1E88E5)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          overview,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: screenSize.width > 540 ||
                                  screenSize.aspectRatio > 0.6
                              ? 2
                              : 3,
                          style: TextStyle(
                              fontSize: getFontSize(context),
                              color: const Color(0xFF1E88E5)),
                        ),
                      ),
                      Row(children: [
                        StarRating(
                          rating: rating * 0.5,
                          size: 15,
                          color: Colors.yellow[700],
                          borderColor: Colors.yellow[700],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                              fontSize: getFontSize(context) - 2,
                              color: const Color(0xFF1E88E5)),
                        ),
                      ])
                    ]),
              )
            ]),
      ),
    );
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

double getFontSize(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  //print(screenWidth);
  //print(MediaQuery.of(context).size.aspectRatio);

  //return 16;

  if (screenWidth <= 320) {
    return 18;
  }
  if (screenWidth <= 360) {
    return 20;
  }
  if (screenWidth <= 411) {
    return 20;
  }
  if (screenWidth <= 480) {
    return 20;
  }
  if (screenWidth <= 540) {
    return 24;
  }
  if (screenWidth <= 768) {
    return 24;
  }
  if (screenWidth <= 800) {
    return 25;
  }

  return 20;
}
