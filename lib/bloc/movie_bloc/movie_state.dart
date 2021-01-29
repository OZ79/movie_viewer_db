import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/models/movie_detail.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import '../base_movie_state.dart';

class PreviewMovieLoadedState extends MovieLoadedState {
  final Map<MovieType, List<Movie>> movies;

  PreviewMovieLoadedState({@required this.movies, @required movieType})
      : super(movieType: movieType);

  @override
  List<Object> get props => [movies, movieType];
}

class MovieDetailLoadedState extends MovieState {
  final MovieDetail movieDetail;

  const MovieDetailLoadedState({@required this.movieDetail});

  @override
  List<Object> get props => [movieDetail];
}
