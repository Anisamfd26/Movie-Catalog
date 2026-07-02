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

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'releaseDate': releaseDate,
      'rating': rating,
      'genre': genre,
      'description': description,
      'poster': poster,
      'isFavorite': isFavorite,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      releaseDate: json['releaseDate'] as String? ?? '',
      rating: json['rating'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      description: json['description'] as String? ?? '',
      poster: json['poster'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
