abstract class MovieEvent {
  const MovieEvent();
}

class LoadMovies extends MovieEvent {
  const LoadMovies();
}

class ToggleFavorite extends MovieEvent {
  final String movieId;

  const ToggleFavorite(this.movieId);
}
