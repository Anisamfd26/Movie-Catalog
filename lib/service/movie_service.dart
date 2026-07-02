import 'package:dio/dio.dart';
import '../model/movie_model.dart';

class MovieService {
  late final Dio _dio;
  static const String _baseUrl = 'https://api.example.com'; // Replace with real API

  MovieService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Fetch all movies from API
  Future<List<Movie>> fetchMovies() async {
    try {
      final response = await _dio.get('/movies');
      final List<dynamic> data = response.data['movies'] ?? [];
      return data.map((json) => Movie.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  /// Fetch a single movie by ID
  Future<Movie> fetchMovieById(String id) async {
    try {
      final response = await _dio.get('/movies/$id');
      return Movie.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch movie: $e');
    }
  }

  /// Search movies by title
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        '/movies/search',
        queryParameters: {'q': query},
      );
      final List<dynamic> data = response.data['movies'] ?? [];
      return data.map((json) => Movie.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  /// Get trending movies
  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await _dio.get('/movies/trending');
      final List<dynamic> data = response.data['movies'] ?? [];
      return data.map((json) => Movie.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to fetch trending movies: $e');
    }
  }
}
