class Movie {
  final String id;
  final String title;
  final String releaseDate;
  final String rating;
  final String genre;
  final String description;
  final String poster;
  final bool isFavorite;

  const Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.rating,
    required this.genre,
    required this.description,
    required this.poster,
    this.isFavorite = false,
  });

  Movie copyWith({bool? isFavorite}) {
    return Movie(
      id: id,
      title: title,
      releaseDate: releaseDate,
      rating: rating,
      genre: genre,
      description: description,
      poster: poster,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
