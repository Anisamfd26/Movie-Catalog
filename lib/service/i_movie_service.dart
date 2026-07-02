import '../model/movie_model.dart';

/// Abstract interface untuk Movie Service
/// Diimplementasikan oleh MovieService dan MockMovieService
abstract class IMovieService {
  /// Fetch all movies
  Future<List<Movie>> fetchMovies();

  /// Fetch single movie by ID
  Future<Movie> fetchMovieById(String id);

  /// Search movies
  Future<List<Movie>> searchMovies(String query);

  /// Get trending movies
  Future<List<Movie>> getTrendingMovies();
}
