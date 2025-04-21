import 'package:flutter/material.dart';
import 'package:movie_mate/pages/main_page.dart';
import 'package:movie_mate/pages/now_playing_page.dart';
import 'package:movie_mate/pages/search_page.dart';
import 'package:movie_mate/pages/tv_shows_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _pages = [
    const MainPage(),
    const NowPlayingPage(),
    const TvShowsPage(),
    const SerachPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill),
            label: "Now Playing",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            label: "Tv Shows",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Serach"),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
