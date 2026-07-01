import '../model/movie_model.dart';

abstract class MovieState {
  const MovieState();
}

class MoviesLoaded extends MovieState {
  final List<Movie> movies;
  final List<Movie> favorites;

  const MoviesLoaded({required this.movies, required this.favorites});
}
