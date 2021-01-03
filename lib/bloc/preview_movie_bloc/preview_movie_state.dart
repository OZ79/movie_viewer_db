import 'package:flutter/foundation.dart';
import '../movie_state.dart';

class PreviewMovieLoadedState extends MovieLoadedState {
  PreviewMovieLoadedState({@required movies, @required movieType})
      : super(movies: movies, movieType: movieType);
}
