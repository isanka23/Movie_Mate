import 'package:flutter/material.dart';
import 'package:movie_mate/models/tv_shows_model.dart';
import 'package:movie_mate/services/tv_shows_service.dart';
import 'package:movie_mate/widgets/tv_show_details.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  final List<TVShow> _tvShows = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // fetch TV shows data
  Future<void> _fetchTvShows ()async{
    try{
      List<TVShow> fetchedShows = await TvShowsService().fetchTvShows();

      setState(() {
        _tvShows.addAll(fetchedShows);
        _isLoading = false;
      });

    }catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load TV shows';
      });
    }finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TV SHOWS"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _tvShows.length,
                  itemBuilder: (context, index) {
                    final show = _tvShows[index];
                    return TVShowListItem(tvShow: show);
                  },
                ),
    );
  }
}