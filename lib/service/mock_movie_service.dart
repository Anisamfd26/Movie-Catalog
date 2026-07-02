import '../model/movie_model.dart';
import 'i_movie_service.dart';

/// Mock Movie Service untuk testing tanpa API asli
class MockMovieService implements IMovieService {
  static final List<Movie> mockMovies = [
    Movie(
      id: 'inception',
      title: 'Inception',
      releaseDate: '2010-07-15',
      rating: '8.4',
      genre: 'Sci-Fi, Action, Thriller',
      description:
          'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
      poster:
          'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_FMjpg_UX1000_.jpg',
    ),
    Movie(
      id: 'interstellar',
      title: 'Interstellar',
      releaseDate: '2014-11-07',
      rating: '8.6',
      genre: 'Adventure, Drama, Sci-Fi',
      description:
          'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot is tasked with piloting a spacecraft to find a new planet for humans.',
      poster:
          'https://m.media-amazon.com/images/I/514zBLkyJcL._AC_UF894,1000_QL80_.jpg',
    ),
    Movie(
      id: 'tenet',
      title: 'Tenet',
      releaseDate: '2020-08-22',
      rating: '7.3',
      genre: 'Action, Sci-Fi, Thriller',
      description:
          'Armed with only one word, Tenet, and fighting for the survival of the entire world, a protagonist journeys through a twilight world of international espionage.',
      poster:
          'https://m.media-amazon.com/images/I/71W2aEcrxxL._AC_UF894,1000_QL80_.jpg',
    ),
    Movie(
      id: 'tdkr',
      title: 'The Dark Knight Rises',
      releaseDate: '2012-07-16',
      rating: '7.8',
      genre: 'Action, Drama',
      description:
          'Eight years after the Joker\'s reign of anarchy, Batman, with the help of the enigmatic Catwoman, is forced from his exile to save Gotham City.',
      poster:
          'https://m.media-amazon.com/images/I/5151N2hUPiL._AC_UF894,1000_QL80_.jpg',
    ),
    Movie(
      id: 'avatar_way_of_water',
      title: 'Avatar: The Way of Water',
      releaseDate: '2022-12-14',
      rating: '7.6',
      genre: 'Action, Adventure, Fantasy',
      description:
          'Jake Sully lives with his newfound family formed on the extrasolar moon Pandora. Once a familiar threat returns to finish what was previously started.',
      poster: 'https://m.media-amazon.com/images/I/71Lvqoov42L.jpg',
    ),
    Movie(
      id: 'oppenheimer',
      title: 'Oppenheimer',
      releaseDate: '2023-07-21',
      rating: '8.1',
      genre: 'Biography, Drama, History',
      description:
          'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb during World War II.',
      poster:
          'https://m.media-amazon.com/images/M/MV5BN2JkMTc1ZmEtYWY1Yi00NTY0LTg4OTItYzlmY2RkNTAxNzAxXkEyXkFqcGdeQXVyMTI5MTk0NjI0._V1_FMjpg_UX1000_.jpg',
    ),
  ];

  /// Get mock movies
  @override
  Future<List<Movie>> fetchMovies() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return mockMovies;
  }

  /// Get mock movie by ID
  @override
  Future<Movie> fetchMovieById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockMovies.firstWhere((movie) => movie.id == id);
  }

  /// Search mock movies
  @override
  Future<List<Movie>> searchMovies(String query) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final lowerQuery = query.toLowerCase();
    return mockMovies
        .where((movie) =>
            movie.title.toLowerCase().contains(lowerQuery) ||
            movie.genre.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get trending movies
  @override
  Future<List<Movie>> getTrendingMovies() async {
    await Future.delayed(const Duration(seconds: 1));
    return mockMovies.sublist(0, 3); // Return first 3 as trending
  }
}
