import 'package:flutter/foundation.dart';
import '../movie_event.dart';

class FetchPreviewMovieEvent extends FetchMovieEvent {
  FetchPreviewMovieEvent({@required movieType}) : super(movieType: movieType);
}
