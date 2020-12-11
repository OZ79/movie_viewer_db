class MovieDetail {
  String backPoster;
  List<dynamic> genres;
  String originalTitle;
  String overview;
  String poster;
  DateTime releaseDate;
  num rating;
  List<Cast> casts;

  MovieDetail({
    this.backPoster,
    this.genres,
    this.originalTitle,
    this.overview,
    this.poster,
    this.releaseDate,
    this.rating,
    this.casts,
  });

  static MovieDetail fromJson(Map<String, dynamic> json) {
    return MovieDetail(
        backPoster: json['backdrop_path'],
        genres: json['genres'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        poster: json['poster_path'],
        releaseDate: DateTime.parse(json['release_date']),
        rating: json['vote_average'],
        casts: List<Cast>.from(
            json['credits']['cast'].map((json) => Cast.fromJson(json))));
  }
}

class Cast {
  int id;
  String name;
  String profilePath;

  Cast({this.id, this.name, this.profilePath});

  Cast.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePath = json['profile_path'];
  }
}
