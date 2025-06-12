import 'package:flutter/material.dart';
import 'package:movie_mate/models/movie_model.dart';

class SearchDetail extends StatelessWidget {
  final Movie movie;
  const SearchDetail({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          movie.posterPath == null
              ? const Center(
                  child: Text(
                    "No Image Available",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),
                ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Release Date: ${movie.releaseDate}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Overview",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            movie.overview,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rating: ${movie.voteAverage}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[600],
                ),
              ),
              Text(
                "Popularity: ${movie.popularity}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
