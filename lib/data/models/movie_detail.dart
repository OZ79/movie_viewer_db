class MovieDetail {
  final String backPoster;
  final List<dynamic> genres;
  final String title;
  final String overview;
  final String poster;
  final String releaseDate;
  final num rating;
  final List<Cast> casts;

  MovieDetail({
    this.backPoster,
    this.genres,
    this.title,
    this.overview,
    this.poster,
    this.releaseDate,
    this.rating,
    this.casts,
  });

  MovieDetail.fromJson(Map<String, dynamic> json)
      : backPoster = json['backdrop_path'],
        genres = json['genres'],
        title = json['title'],
        overview = json['overview'],
        poster = json['poster_path'],
        releaseDate = json['release_date'],
        rating = json['vote_average'],
        casts = List<Cast>.from(
            json['credits']['cast'].map((json) => Cast.fromJson(json)));
}

class Cast {
  final int id;
  final String name;
  final String profilePath;

  Cast({this.id, this.name, this.profilePath});

  Cast.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        profilePath = json['profile_path'];
}
