import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import './models/movie.dart';
import 'models/movie_detail.dart';
import 'models/movie_page.dart';

enum MovieType { upcoming, latest, now_playing, popular, top_rated, none }

abstract class MovieRepositoryApi {
  Future<List<Movie>> fetchMovies(MovieType movieType);
  Future<MoviePage> fetchMoviePage(MovieType movieType, int page);
  Future<MoviePage> fetchMoviePageBySearch(String query, int page);
  Future<MovieDetail> fetchMovieDetail(int movieId);
}

class MovieRepository implements MovieRepositoryApi {
  static List<Movie> _parseMovie(String responseBody) {
    final parsed = jsonDecode(responseBody)['results'];
    return parsed.map<Movie>((json) => Movie.fromJson(json)).toList();
  }

  static MoviePage _parseMoviePages(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return MoviePage.fromJson(parsed);
  }

  static MovieDetail _parseMovieDetail(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return MovieDetail.fromJson(parsed);
  }

  @override
  Future<List<Movie>> fetchMovies(MovieType movieType) async {
    final url = Uri.https(
        MOVIE_DB_BASE_URL,
        '/3/movie/${movieType.toString().split('.').last}',
        {'api_key': API_KEY, 'language': 'en-US', 'page': "1"});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return compute(_parseMovie, response.body);
    } else {
      throw Exception();
    }
  }

  @override
  Future<MoviePage> fetchMoviePage(MovieType movieType, int page) async {
    final url = Uri.https(
        MOVIE_DB_BASE_URL,
        '/3/movie/${movieType.toString().split('.').last}',
        {'api_key': API_KEY, 'language': 'en-US', 'page': page.toString()});

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return compute(_parseMoviePages, response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<MoviePage> fetchMoviePageBySearch(String query, int page) async {
    final url = Uri.https(MOVIE_DB_BASE_URL, '/3/search/movie', {
      'api_key': API_KEY,
      'language': 'en-US',
      'query': query,
      'page': page.toString()
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return compute(_parseMoviePages, response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<MovieDetail> fetchMovieDetail(int movieId) async {
    final url = Uri.https(MOVIE_DB_BASE_URL, '3/movie/$movieId', {
      'api_key': API_KEY,
      'language': 'en-US',
      'append_to_response': 'credits'
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return compute(_parseMovieDetail, response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
