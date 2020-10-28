import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/movie.dart';

enum MovieType { upcoming, latest, now_playing, popular, top_rated }

abstract class MovieRepositoryApi {
  Future<List<Movie>> getMovies(MovieType movieType);
}

class MovieRepository implements MovieRepositoryApi {
  static const API_KEY = '8f512a842d97dd3228339affe175710f';
  static const baseUrl = 'api.themoviedb.org';

  static List<Movie> _parseMovie(String responseBody) {
    final parsed = jsonDecode(responseBody)['results'];
    return parsed.map<Movie>((json) => Movie.fromJson(json)).toList();
  }

  @override
  Future<List<Movie>> getMovies(MovieType movieType) async {
    final url = Uri.https(
        baseUrl,
        '/3/movie/${movieType.toString().split('.').last}',
        {'api_key': API_KEY, 'language': 'en-US'});

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return compute(_parseMovie, response.body);
    } else {
      throw Exception();
    }
  }
}
