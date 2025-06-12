import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_mate/models/movie_model.dart';

class MovieServices {
  // get api key
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.themoviedb.org/3/movie';

  // get upcoming movies
  Future<List<Movie>> fetchUpcomingMovies({int page = 1}) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/upcoming?api_key=$_apiKey&page=$page'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      print('Error fetching upcoming movies: $e');
      return [];
    }
  }

  // fetch now playing movies
  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/now_playing?api_key=$_apiKey&page=$page'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to load now playing movies');
      }
    } catch (e) {
      print('Error fetching now playing movies: $e');
      return [];
    }
  }

  // search movies by query
  Future<List<Movie>> serachMovies(String query) async {
    try {
      final response = await http
          .get(Uri.parse('https://api.themoviedb.org/3/search/movie?query=$query&api_key=$_apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      print('Error searching movies: $e');
      throw Exception('$e');
    }
  }

  //similar movies
  Future<List<Movie>> fetchSimilarMovies(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/$movieId/similar?api_key=$_apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to load similar movies');
      }
    } catch (e) {
      print('Error fetching similar movies: $e');
      return [];
    }
  }

  // recommended movies
  Future<List<Movie>> fetchRecommendedMovies(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/$movieId/recommendations?api_key=$_apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to load recommended movies');
      }
    } catch (e) {
      print('Error fetching recommended movies: $e');
      return [];
    }
  }

  // fetch images by movie id
  Future<List<String>> fetchMovieImages(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/images?api_key=$_apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> backdrops = data['backdrops'];

        return backdrops.take(10).map((image)=>"https://image.tmdb.org/t/p/w500${image['file_path']}").toList();
      } else {
        throw Exception('Failed to load movie images');
      }
    } catch (e) {
      print('Error fetching movie images: $e');
      return [];
    }
  }
}
