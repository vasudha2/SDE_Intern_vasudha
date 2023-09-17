import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_search/models/movie.dart';

class MovieService {
  final String baseUrl = 'http://localhost:3001/api/movies'; // Update with your backend URL
  int _page = 1;

  Future<List<Movie>> fetchMovies(int limit, String sortBy) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$_page&limit=$limit&sortBy=$sortBy'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Movie> movies = data.map((json) => Movie.fromJson(json)).toList();
      _page++; // Increment page for lazy loading
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Movie> movies = data.map((json) => Movie.fromJson(json)).toList();
      return movies;
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
