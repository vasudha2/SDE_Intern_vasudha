import 'package:flutter/material.dart';
import 'package:movie_search/models/movie.dart';
import 'package:movie_search/services/movie_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _movieService = MovieService();
  final List<Movie> _movies = [];
  String _sortBy = 'popularity'; // Default sort by popularity
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      List<Movie> movies = await _movieService.fetchMovies(_page, _sortBy);
      setState(() {
        _movies.addAll(movies);
      });
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _fetchMoreMovies() async {
    try {
      List<Movie> movies = await _movieService.fetchMovies(_page, _sortBy);
      setState(() {
        _movies.addAll(movies);
        _page++; // Increment page for lazy loading
      });
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _searchMovies(String query) async {
    try {
      List<Movie> movies = await _movieService.searchMovies(query);
      setState(() {
        _movies.clear();
        _movies.addAll(movies);
      });
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _movies.clear(); // Clear existing movies when sorting changes
                _fetchMovies();
              });
            },
            itemBuilder: (BuildContext context) {
              return ['popularity', 'year', 'imdb_rating'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final query = await showSearch<String>(
                context: context,
                delegate: _MovieSearchDelegate(),
              );
              if (query != null && query.isNotEmpty) {
                _searchMovies(query);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _movies.length + 1,
        itemBuilder: (context, index) {
          if (index == _movies.length) {
            return _buildLoader();
          } else {
            return _buildMovieItem(_movies[index]);
          }
        },
      ),
    );
  }

  Widget _buildLoader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildMovieItem(Movie movie) {
    return ListTile(
      title: Text(movie.title),
      subtitle: Text('Year: ${movie.year}, IMDB Rating: ${movie.imdbRating.toStringAsFixed(1)}'),
      leading: Image.network('https://image.tmdb.org/t/p/w92${movie.posterPath}'),
    );
  }
}

class _MovieSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    return Container();
  }
}
