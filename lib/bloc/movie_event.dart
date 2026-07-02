abstract class MovieEvent {
  const MovieEvent();
}

class LoadMovies extends MovieEvent {
  const LoadMovies();
}

class LoadMoviesFromApi extends MovieEvent {
  const LoadMoviesFromApi();
}

class SearchMovies extends MovieEvent {
  final String query;
  
  const SearchMovies(this.query);
}

class GetTrendingMovies extends MovieEvent {
  const GetTrendingMovies();
}

class ToggleFavorite extends MovieEvent {
  final String movieId;

  const ToggleFavorite(this.movieId);
}

class RefreshMovies extends MovieEvent {
  const RefreshMovies();
}
