import 'package:flutter/material.dart';
import 'package:movie_mate/models/movie_model.dart';
import 'package:movie_mate/services/movie_services.dart';
import 'package:movie_mate/widgets/movie_details.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  List<Movie> _movies = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;

  Future<void> _fetchMovies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Movie> fetchedMovies =
          await MovieServices().fetchNowPlayingMovies(page: _currentPage);
      setState(() {
        _movies = fetchedMovies;
        _totalPages = 100;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // previous page
  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchMovies();
    }
  }

  // next page
  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchMovies();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NOW PLAYING"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _movies.length + 1,
                    itemBuilder: (context, index) {
                      if (index > _movies.length - 1) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildPagenationControls(),
                        );
                      } else {
                        return MovieDetails(movie: _movies[index]);
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPagenationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            _currentPage > 1 ? _previousPage() : null;
          },
          child: Text(
            "Previous",
          ),
        ),
        SizedBox(width: 10),
        Text("Page $_currentPage of $_totalPages"),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            _currentPage < _totalPages ? _nextPage() : null;
          },
          child: Text(
            "Next",
          ),
        ),
      ],
    );
  }
}
