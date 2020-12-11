import 'movie.dart';

class MoviePage {
  final int page;
  final int totalPages;
  final List<Movie> movies;

  MoviePage(this.totalPages, this.page, this.movies);

  MoviePage.fromJson(Map<String, dynamic> json)
      : totalPages = json['total_pages'],
        page = json['page'],
        movies =
            json['results'].map<Movie>((json) => Movie.fromJson(json)).toList();
}
