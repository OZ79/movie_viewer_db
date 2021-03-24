import 'dart:collection';

import 'models/movie.dart';
import 'models/movie_page.dart';
import 'movie_repositories.dart';

class DataCache {
  static final _moviePages = HashMap<MovieType, List<MoviePage>>();

  static MoviePage getMoviePage(MovieType movieType, int page) {
    return _moviePages[movieType][page - 1];
  }

  static MoviePage geLastMoviePage(MovieType movieType) {
    return _moviePages[movieType].last;
  }

  static List<Movie> getMovies(MovieType movieType) {
    return _moviePages[movieType]
        .expand((moviePage) => moviePage.movies)
        .toList();
  }

  static bool containsMoviePage(MovieType movieType, int page) {
    if (_moviePages.containsKey(movieType)) {
      return _moviePages[movieType].length >= page;
    }

    return false;
  }

  static addMoviePage(MovieType movieType, MoviePage moviePage) {
    if (!_moviePages.containsKey(movieType)) {
      _moviePages[movieType] = [moviePage];
      return;
    }

    if (!containsMoviePage(movieType, moviePage.page)) {
      _moviePages[movieType].add(moviePage);
    }
  }
}
