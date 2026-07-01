import 'dart:async';

import '../model/movie_model.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc {
  final List<Movie> _movies = List<Movie>.of([
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
  ]);

  late final StreamController<MovieState> _stateController;
  final StreamController<MovieEvent> _eventController =
      StreamController<MovieEvent>();
  
  MovieState? _lastState;

  Stream<MovieState> get state {
    // Return a stream that emits the last state to new subscribers first
    return _createStateStream();
  }

  Stream<MovieState> _createStateStream() async* {
    // Emit last state immediately if available (for late subscribers)
    if (_lastState != null) {
      yield _lastState!;
    }
    // Then yield from the controller stream
    yield* _stateController.stream;
  }
  Stream<List<Movie>> get movies => state.map(
        (state) => state is MoviesLoaded ? state.movies : const <Movie>[],
      );
  Stream<List<Movie>> get favorites => state.map(
        (state) => state is MoviesLoaded ? state.favorites : const <Movie>[],
      );
  Sink<MovieEvent> get eventSink => _eventController.sink;

  MovieBloc() {
    _stateController = StreamController<MovieState>.broadcast();

    _eventController.stream.listen(_mapEventToState);
    _emitCurrentState();
  }

  void toggleFavorite(String movieId) {
    eventSink.add(ToggleFavorite(movieId));
  }

  void _emitCurrentState() {
    final movies = List<Movie>.unmodifiable(_movies);
    final favorites = List<Movie>.unmodifiable(_favoriteMovies);
    final newState = MoviesLoaded(movies: movies, favorites: favorites);
    _lastState = newState;
    _stateController.add(newState);
  }

  List<Movie> get _favoriteMovies =>
      _movies.where((movie) => movie.isFavorite).toList(growable: false);

  Movie? movieById(String id) {
    try {
      return _movies.firstWhere((movie) => movie.id == id);
    } catch (_) {
      return null;
    }
  }

  void _mapEventToState(MovieEvent event) {
    if (event is ToggleFavorite) {
      final index = _movies.indexWhere((movie) => movie.id == event.movieId);
      if (index == -1) return;

      _movies[index] = _movies[index]
          .copyWith(isFavorite: !_movies[index].isFavorite);
      _emitCurrentState();
    }
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
