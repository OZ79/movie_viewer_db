class MovieDetail {
  final String backPoster;
  final List<dynamic> genres;
  final List<dynamic> prodCountries;
  final List<dynamic> prodCompanies;
  final String title;
  final String overview;
  final String poster;
  final String releaseDate;
  final num rating;
  final List<Cast> casts;

  MovieDetail({
    this.backPoster,
    this.genres,
    this.prodCountries,
    this.prodCompanies,
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
        prodCountries = json['production_countries'],
        prodCompanies = json['production_companies'],
        title = json['title'],
        overview = json['overview'],
        poster = json['poster_path'],
        releaseDate = json['release_date'],
        rating = json['vote_average'],
        casts = List<Cast>.from(
            json['credits']['cast'].map((json) => Cast.fromJson(json))) {
    prodCompanies.removeWhere((element) => element['logo_path'] == null);
    prodCountries.removeWhere((element) => element['iso_3166_1'] == null);
    casts.removeWhere((element) => element.profilePath == null);
  }
}

class Cast {
  final int id;
  final String name;
  final String character;
  final String profilePath;

  Cast({this.id, this.name, this.character, this.profilePath});

  Cast.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        character = json['character'],
        profilePath = json['profile_path'];
}
