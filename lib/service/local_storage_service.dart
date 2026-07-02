import 'package:hive_flutter/hive_flutter.dart';
import '../model/movie_model.dart';

class LocalStorageService {
  static const String _boxName = 'movies';
  static const String _favoritesBoxName = 'favorites';
  late final Box<Map> _moviesBox;
  late final Box<String> _favoritesBox;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();
    _moviesBox = await Hive.openBox<Map>(_boxName);
    _favoritesBox = await Hive.openBox<String>(_favoritesBoxName);
  }

  /// Save movies to local storage
  Future<void> saveMovies(List<Movie> movies) async {
    try {
      await _moviesBox.clear();
      for (final movie in movies) {
        await _moviesBox.put(movie.id, movie.toJson());
      }
    } catch (e) {
      throw Exception('Failed to save movies locally: $e');
    }
  }

  /// Get all movies from local storage
  Future<List<Movie>> getMovies() async {
    try {
      if (_moviesBox.isEmpty) {
        return [];
      }
      return _moviesBox.values
          .map((value) => Movie.fromJson(Map<String, dynamic>.from(value)))
          .toList();
    } catch (e) {
      throw Exception('Failed to get movies from local storage: $e');
    }
  }

  /// Get a single movie by ID from local storage
  Future<Movie?> getMovieById(String id) async {
    try {
      final value = _moviesBox.get(id);
      if (value == null) return null;
      return Movie.fromJson(Map<String, dynamic>.from(value));
    } catch (e) {
      throw Exception('Failed to get movie from local storage: $e');
    }
  }

  /// Save a movie
  Future<void> saveMovie(Movie movie) async {
    try {
      await _moviesBox.put(movie.id, movie.toJson());
    } catch (e) {
      throw Exception('Failed to save movie locally: $e');
    }
  }

  /// Add movie ID to favorites
  Future<void> addFavorite(String movieId) async {
    try {
      await _favoritesBox.put(movieId, movieId);
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  /// Remove movie ID from favorites
  Future<void> removeFavorite(String movieId) async {
    try {
      await _favoritesBox.delete(movieId);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  /// Get all favorite movie IDs
  Future<List<String>> getFavorites() async {
    try {
      return _favoritesBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  /// Check if movie is favorite
  Future<bool> isFavorite(String movieId) async {
    try {
      return _favoritesBox.containsKey(movieId);
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }

  /// Clear all local data
  Future<void> clearAll() async {
    try {
      await _moviesBox.clear();
      await _favoritesBox.clear();
    } catch (e) {
      throw Exception('Failed to clear local storage: $e');
    }
  }

  /// Close boxes
  Future<void> dispose() async {
    await _moviesBox.close();
    await _favoritesBox.close();
  }
}
