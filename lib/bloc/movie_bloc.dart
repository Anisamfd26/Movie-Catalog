import 'dart:async';
import '../model/movie_model.dart';
import '../service/movie_service.dart';
import '../service/local_storage_service.dart';
import '../service/connectivity_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc {
  late final MovieService _movieService;
  late final LocalStorageService _localStorageService;
  late final ConnectivityService _connectivityService;

  // List to hold all movies in memory
  final List<Movie> _allMovies = [];
  final List<String> _favoriteIds = [];

  late final StreamController<MovieState> _stateController;
  final StreamController<MovieEvent> _eventController =
      StreamController<MovieEvent>();

  MovieState? _lastState;
  late StreamSubscription<bool> _connectivitySubscription;

  Stream<MovieState> get state {
    return _createStateStream();
  }

  Stream<MovieState> _createStateStream() async* {
    if (_lastState != null) {
      yield _lastState!;
    }
    yield* _stateController.stream;
  }

  Stream<List<Movie>> get movies => state.map(
        (state) => state is MoviesLoaded ? state.movies : const <Movie>[],
      );

  Stream<List<Movie>> get favorites => state.map(
        (state) => state is MoviesLoaded ? state.favorites : const <Movie>[],
      );

  Sink<MovieEvent> get eventSink => _eventController.sink;

  // Constructor
  MovieBloc({
    required MovieService movieService,
    required LocalStorageService localStorageService,
    required ConnectivityService connectivityService,
  }) {
    _movieService = movieService;
    _localStorageService = localStorageService;
    _connectivityService = connectivityService;

    _stateController = StreamController<MovieState>.broadcast();
    _eventController.stream.listen(_mapEventToState);

    // Listen to connectivity changes
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((isConnected) {
      if (isConnected) {
        print('Internet connection restored');
      } else {
        print('Internet connection lost');
      }
    });

    // Load initial movies
    _loadInitialMovies();
  }

  /// Load movies on initialization
  Future<void> _loadInitialMovies() async {
    try {
      final bool hasInternet =
          await _connectivityService.hasInternetConnection();

      if (hasInternet) {
        // Try to fetch from API
        await _fetchMoviesFromApi();
      } else {
        // Fallback to local storage
        await _loadMoviesFromStorage();
      }
    } catch (e) {
      print('Error loading initial movies: $e');
      // Try to load from local storage as last resort
      await _loadMoviesFromStorage();
    }
  }

  /// Fetch movies from API with local storage fallback
  Future<void> _fetchMoviesFromApi() async {
    try {
      _emitLoadingState();
      final movies = await _movieService.fetchMovies();
      _allMovies.clear();
      _allMovies.addAll(movies);

      // Save to local storage for offline use
      await _localStorageService.saveMovies(movies);

      // Load favorites from local storage
      await _loadFavoritesFromStorage();

      _emitMoviesLoadedState(isFromLocalStorage: false);
    } catch (e) {
      print('Error fetching from API: $e');
      // Fallback to local storage
      await _loadMoviesFromStorage();
    }
  }

  /// Load movies from local storage
  Future<void> _loadMoviesFromStorage() async {
    try {
      final movies = await _localStorageService.getMovies();
      _allMovies.clear();
      _allMovies.addAll(movies);

      await _loadFavoritesFromStorage();

      if (_allMovies.isEmpty) {
        _emitErrorState(
            'No movies found. Please check your internet connection.');
      } else {
        _emitMoviesLoadedState(isFromLocalStorage: true);
      }
    } catch (e) {
      print('Error loading from local storage: $e');
      _emitErrorState('Failed to load movies: $e');
    }
  }

  /// Load favorites from local storage
  Future<void> _loadFavoritesFromStorage() async {
    try {
      final favoriteIds = await _localStorageService.getFavorites();
      _favoriteIds.clear();
      _favoriteIds.addAll(favoriteIds);

      // Update isFavorite property on movies
      for (int i = 0; i < _allMovies.length; i++) {
        if (_favoriteIds.contains(_allMovies[i].id)) {
          _allMovies[i] = _allMovies[i].copyWith(isFavorite: true);
        }
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  /// Search movies
  Future<void> _searchMovies(String query) async {
    try {
      _stateController.add(const SearchLoading());

      final bool hasInternet =
          await _connectivityService.hasInternetConnection();

      List<Movie> results = [];

      if (hasInternet) {
        try {
          // Try API search first
          results = await _movieService.searchMovies(query);
        } catch (e) {
          print('API search failed, falling back to local search: $e');
          // Fallback to local search
          results = _searchLocally(query);
        }
      } else {
        // Search locally
        results = _searchLocally(query);
      }

      final favorites = _allMovies.where((m) => m.isFavorite).toList();
      _stateController.add(SearchResults(results: results, favorites: favorites));
    } catch (e) {
      print('Error searching movies: $e');
      _emitErrorState('Failed to search movies: $e');
    }
  }

  /// Search movies locally from in-memory list
  List<Movie> _searchLocally(String query) {
    final lowerQuery = query.toLowerCase();
    return _allMovies
        .where((movie) =>
            movie.title.toLowerCase().contains(lowerQuery) ||
            movie.genre.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get trending movies
  Future<void> _getTrendingMovies() async {
    try {
      _emitLoadingState();

      final bool hasInternet =
          await _connectivityService.hasInternetConnection();

      List<Movie> trendingMovies = [];

      if (hasInternet) {
        try {
          trendingMovies = await _movieService.getTrendingMovies();
        } catch (e) {
          print('API trending failed, showing cached movies: $e');
          // Show all cached movies as fallback
          trendingMovies = List.from(_allMovies);
        }
      } else {
        // Show all cached movies
        trendingMovies = List.from(_allMovies);
      }

      _stateController.add(MoviesLoaded(
        movies: trendingMovies,
        favorites: trendingMovies.where((m) => m.isFavorite).toList(),
        isFromLocalStorage: !hasInternet,
      ));
    } catch (e) {
      print('Error getting trending movies: $e');
      _emitErrorState('Failed to load trending movies: $e');
    }
  }

  /// Toggle favorite status
  void _toggleFavorite(String movieId) async {
    try {
      final index = _allMovies.indexWhere((movie) => movie.id == movieId);
      if (index == -1) return;

      final isFavorite = _allMovies[index].isFavorite;

      if (isFavorite) {
        await _localStorageService.removeFavorite(movieId);
        _favoriteIds.remove(movieId);
      } else {
        await _localStorageService.addFavorite(movieId);
        _favoriteIds.add(movieId);
      }

      _allMovies[index] = _allMovies[index].copyWith(
        isFavorite: !isFavorite,
      );

      _emitMoviesLoadedState();
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  /// Refresh movies from API
  Future<void> _refreshMovies() async {
    await _fetchMoviesFromApi();
  }

  /// Event mapping
  void _mapEventToState(MovieEvent event) {
    if (event is LoadMovies) {
      _loadInitialMovies();
    } else if (event is LoadMoviesFromApi) {
      _fetchMoviesFromApi();
    } else if (event is SearchMovies) {
      _searchMovies(event.query);
    } else if (event is GetTrendingMovies) {
      _getTrendingMovies();
    } else if (event is ToggleFavorite) {
      _toggleFavorite(event.movieId);
    } else if (event is RefreshMovies) {
      _refreshMovies();
    }
  }

  // State emission helpers
  void _emitLoadingState() {
    const state = MoviesLoading();
    _lastState = state;
    _stateController.add(state);
  }

  void _emitMoviesLoadedState({bool isFromLocalStorage = false}) {
    final favorites = _allMovies.where((m) => m.isFavorite).toList();
    final state = MoviesLoaded(
      movies: List<Movie>.unmodifiable(_allMovies),
      favorites: List<Movie>.unmodifiable(favorites),
      isFromLocalStorage: isFromLocalStorage,
    );
    _lastState = state;
    _stateController.add(state);
  }

  void _emitErrorState(String message) {
    final state = MoviesError(message);
    _lastState = state;
    _stateController.add(state);
  }

  /// Get movie by ID
  Movie? movieById(String id) {
    try {
      return _allMovies.firstWhere((movie) => movie.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Public methods for event triggering
  void loadMovies() {
    eventSink.add(const LoadMovies());
  }

  void loadMoviesFromApi() {
    eventSink.add(const LoadMoviesFromApi());
  }

  void searchMovies(String query) {
    eventSink.add(SearchMovies(query));
  }

  void getTrendingMovies() {
    eventSink.add(const GetTrendingMovies());
  }

  void toggleFavorite(String movieId) {
    eventSink.add(ToggleFavorite(movieId));
  }

  void refreshMovies() {
    eventSink.add(const RefreshMovies());
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
    _connectivitySubscription.cancel();
  }
}
