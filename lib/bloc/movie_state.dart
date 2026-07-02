import '../model/movie_model.dart';

abstract class MovieState {
  const MovieState();
}

class MoviesInitial extends MovieState {
  const MoviesInitial();
}

class MoviesLoading extends MovieState {
  const MoviesLoading();
}

class MoviesLoaded extends MovieState {
  final List<Movie> movies;
  final List<Movie> favorites;
  final bool isFromLocalStorage;

  const MoviesLoaded({
    required this.movies,
    required this.favorites,
    this.isFromLocalStorage = false,
  });
}

class MoviesError extends MovieState {
  final String message;

  const MoviesError(this.message);
}

class SearchLoading extends MovieState {
  const SearchLoading();
}

class SearchResults extends MovieState {
  final List<Movie> results;
  final List<Movie> favorites;

  const SearchResults({required this.results, required this.favorites});
}
