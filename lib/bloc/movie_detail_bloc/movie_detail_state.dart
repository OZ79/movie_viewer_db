import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/models/movie_detail.dart';
import '../base_movie_state.dart';

class MovieDetailLoadedState extends MovieState {
  final int movieId;
  final MovieDetail movieDetail;

  const MovieDetailLoadedState(
      {@required this.movieId, @required this.movieDetail});

  @override
  List<Object> get props => [movieId, movieDetail];
}
