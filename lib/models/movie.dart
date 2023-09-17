class Movie {
  final String title;
  final int year;
  final double imdbRating;
  final String posterPath;

  Movie({
    required this.title,
    required this.year,
    required this.imdbRating,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    try {
      return Movie(
        title: json['title'] ?? '',
        year: json['year'] ?? 0,
        imdbRating: json['imdbRating']?.toDouble() ?? 0.0,
        posterPath: json['posterPath'] ?? '',
      );
    } catch (e) {
      print('Error parsing movie data: $e');
      
      return Movie(
        title: '',
        year: 0,
        imdbRating: 0.0,
        posterPath: '',
      );
    }
  }
}
