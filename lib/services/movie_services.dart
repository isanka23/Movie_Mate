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
      final response =
          await http.get(Uri.parse('$_baseUrl/upcoming?api_key=$_apiKey&page=$page'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((movieData)=> Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      print('Error fetching upcoming movies: $e');
      return [];
    }
  }

  // fetch now playing movies
  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async{
    try{

      final response =
          await http.get(Uri.parse('$_baseUrl/now_playing?api_key=$_apiKey&page=$page'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((movieData)=> Movie.fromJson(movieData)).toList();
      } else {
        throw Exception('Failed to load now playing movies');
      }

    }catch(e){
      print('Error fetching now playing movies: $e');
      return [];
    }
  }
}
