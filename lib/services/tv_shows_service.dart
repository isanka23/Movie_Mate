import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_mate/models/tv_shows_model.dart';
import 'package:http/http.dart' as http;

class TvShowsService {
  //api key
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  Future<List<TVShow>> fetchTvShows() async {
    try {
      // Fetching popular TV shows
      final popularResponse = await http.get(
        Uri.parse('https://api.themoviedb.org/3/tv/popular?api_key=$_apiKey'),
      );

      // Fetching final airing Today TV shows
      final airingTodayResponse = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/tv/airing_today?api_key=$_apiKey'),
      );

      // Fetching top rated TV shows
      final topRatedResponse = await http.get(
        Uri.parse('https://api.themoviedb.org/3/tv/top_rated?api_key=$_apiKey'),
      );

      if (popularResponse.statusCode == 200 &&
          airingTodayResponse.statusCode == 200 &&
          topRatedResponse.statusCode == 200) {
        final popularShows = json.decode(popularResponse.body);
        final airingTodayShows = json.decode(airingTodayResponse.body);
        final topRatedShows = json.decode(topRatedResponse.body);

        final List<dynamic> popularResults = popularShows['results'];
        final List<dynamic> airingTodayResults = airingTodayShows['results'];
        final List<dynamic> topRatedResults = topRatedShows['results'];

        List<TVShow> tvShows = [];

        // take 10 from each category
        tvShows.addAll(popularResults.map((show) => TVShow.fromJson(show)).take(10));
        tvShows.addAll(airingTodayResults.map((show) => TVShow.fromJson(show)).take(10));
        tvShows.addAll(topRatedResults.map((show) => TVShow.fromJson(show)).take(10));

        return tvShows;


      } else {
        throw Exception('Failed to load TV shows');
      }
    } catch (e) {
      print('Error fetching TV shows: $e');
      return [];
    }
  }
}
