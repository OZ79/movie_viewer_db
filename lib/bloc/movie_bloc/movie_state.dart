import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/models/movie_detail.dart';
import '../base_movie_state.dart';

class PreviewMovieLoadedState extends MovieLoadedState {
  PreviewMovieLoadedState({@required movies, @required movieType})
      : super(movies: movies, movieType: movieType);
}

class MovieDetailLoadedState extends MovieState {
  final MovieDetail movieDetail;

  const MovieDetailLoadedState({@required this.movieDetail});

  @override
  List<Object> get props => [movieDetail];
}
