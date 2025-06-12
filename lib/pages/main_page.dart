import 'package:flutter/material.dart';
import 'package:movie_mate/models/movie_model.dart';
import 'package:movie_mate/pages/single_movie_details.dart';
import 'package:movie_mate/services/movie_services.dart';
import 'package:movie_mate/widgets/movie_details.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Movie> _movie = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  Future<void> _fetchMovie() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    // eka digta scroll giyama data ganna one nisa 2 sec delay karala thiyenne
    await Future.delayed(const Duration(seconds: 2));
    try {
      final newMovies =
          await MovieServices().fetchUpcomingMovies(page: _currentPage);
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _movie.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Movie Mate",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            fontSize: 24,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!_isLoading &&
              _hasMore &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            _fetchMovie();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _movie.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _movie.length) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 4,
                ),
              );
            }
            final Movie movie = _movie[index];

            return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SingleMovieDetails(movie: movie);
                  }));
                },
                child: MovieDetails(movie: movie));
          },
        ),
      ),
    );
  }
}
