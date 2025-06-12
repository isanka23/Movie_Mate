import 'package:flutter/material.dart';
import 'package:movie_mate/models/movie_model.dart';
import 'package:movie_mate/services/movie_services.dart';
import 'package:movie_mate/widgets/search_detail.dart';

class SingleMovieDetails extends StatefulWidget {
  Movie movie;
  SingleMovieDetails({super.key, required this.movie});

  @override
  State<SingleMovieDetails> createState() => _SingleMovieDetailsState();
}

class _SingleMovieDetailsState extends State<SingleMovieDetails> {
  List<Movie> _similarMovies = [];
  List<Movie> _recommendations = [];
  List<String> _movieImages = [];

  bool _isLoadingSimilar = true;
  bool _isLoadingRecommendations = true;
  bool _isLoadingImages = true;

  // Fetch similar movies
  Future<void> _fetchSimilarMovies() async {
    try {
      List<Movie> fetchedSimilarMovies =
          await MovieServices().fetchSimilarMovies(widget.movie.id);

      setState(() {
        _similarMovies = fetchedSimilarMovies;
        _isLoadingSimilar = false;
      });
    } catch (e) {
      print('Error fetching similar movies: $e');
      setState(() {
        _isLoadingSimilar = false;
      });
    } finally {
      setState(() {
        _isLoadingSimilar = false;
      });
    }
  }

  // Fetch movie recommendations
  Future<void> _fetchRecommendations() async {
    try {
      List<Movie> fetchedRecommendations =
          await MovieServices().fetchRecommendedMovies(widget.movie.id);

      setState(() {
        _recommendations = fetchedRecommendations;
        _isLoadingRecommendations = false;
      });
    } catch (e) {
      print('Error fetching recommendations: $e');
      setState(() {
        _isLoadingRecommendations = false;
      });
    } finally {
      setState(() {
        _isLoadingRecommendations = false;
      });
    }
  }

  // Fetch movie images
  Future<void> _fetchMovieImages() async {
    try {
      List<String> fetchedImages =
          await MovieServices().fetchMovieImages(widget.movie.id);

      setState(() {
        _movieImages = fetchedImages;
        _isLoadingImages = false;
      });
    } catch (e) {
      print('Error fetching movie images: $e');
      setState(() {
        _isLoadingImages = false;
      });
    } finally {
      setState(() {
        _isLoadingImages = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSimilarMovies();
    _fetchRecommendations();
    _fetchMovieImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchDetail(
                movie: widget.movie,
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Movie Images',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildImageSection(),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Similar Movies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildMovieSection(
                _similarMovies,
                _isLoadingSimilar,
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Recommendations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildMovieSection(
                _recommendations,
                _isLoadingRecommendations,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    if (_isLoadingImages) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.redAccent,
          strokeWidth: 4,
        ),
      );
    }

    if (_movieImages.isEmpty) {
      return Center(
        child: Text('No images available for this movie.'),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _movieImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _movieImages[index],
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieSection(List<Movie> movies, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (movies.isEmpty) {
      return const Center(child: Text('No movies found.'));
    }
    return SizedBox(
      height: 200, // Height for horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.movie = movies[index];
                _fetchSimilarMovies();
                _fetchRecommendations();
                _fetchMovieImages();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.all(4.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (movies[index].posterPath != null)
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      'Average Vote: ${movies[index].voteAverage}',
                      style: TextStyle(
                        fontSize: 7,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
