import 'package:flutter/material.dart';
import 'package:movie_mate/models/movie_model.dart';
import 'package:movie_mate/services/movie_services.dart';
import 'package:movie_mate/widgets/search_detail.dart';

class SerachPage extends StatefulWidget {
  const SerachPage({super.key});

  @override
  State<SerachPage> createState() => _SerachPageState();
}

class _SerachPageState extends State<SerachPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // methord to search movies
  Future<void> _searchMovies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<Movie> movies = await MovieServices().serachMovies(
        _searchController.text,
      );

      setState(() {
        _searchResults = movies;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching search results: $error');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching search results';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEARCH MoVIES"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for movies',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onSubmitted: (_) {
                        _searchMovies();
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _searchMovies,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (_searchResults.isEmpty)
              const Center(
                child: Text('No results found'),
              ),
            if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = _searchResults[index];
                    return Column(
                      children: [
                        SearchDetail(movie: movie),
                        SizedBox(height: 10),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                          indent: 8,
                          endIndent: 8,
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
