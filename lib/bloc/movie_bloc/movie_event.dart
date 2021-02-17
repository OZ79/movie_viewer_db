import 'package:flutter/foundation.dart';
import '../base_movie_event.dart';

class FetchPreviewMovieEvent extends FetchMovieEvent {
  FetchPreviewMovieEvent({@required movieType}) : super(movieType: movieType);
}
