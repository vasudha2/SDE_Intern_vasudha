import 'package:flutter/material.dart';
import 'package:movie_search/models/movie.dart';  // Import the Movie class from the correct location

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: text,
      child: const Icon(Icons.add),
    );
  }
}

class MovieItemWidget extends StatelessWidget {
  final Movie movie; 

  const MovieItemWidget({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(movie.title),
      subtitle: Text('Year: ${movie.year}, IMDB Rating: ${movie.imdbRating.toStringAsFixed(1)}'),
      leading: Image.network('https://image.tmdb.org/t/p/w92${movie.posterPath}'),
    );
  }
}
