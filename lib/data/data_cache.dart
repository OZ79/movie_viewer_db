import 'models/movie_page.dart';
import 'movie_repositories.dart';

class DataCache {
  static final Map<MovieType, List<MoviePage>> _moviePages = {};

  static MoviePage getMoviePage(MovieType movieType, int page) {
    return _moviePages[movieType][page - 1];
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
