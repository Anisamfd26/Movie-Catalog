import 'package:flutter/material.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_state.dart';
import '../model/movie_model.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;
  final MovieBloc bloc;

  const MovieDetailPage({super.key, required this.movie, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final currentMovies = state is MoviesLoaded ? state.movies : const <Movie>[];
        final currentMovie = _findMovie(currentMovies, movie.id) ?? movie;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
            title: Text(
              currentMovie.title,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  bloc.toggleFavorite(currentMovie.id);
                },
                icon: Icon(
                  currentMovie.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: currentMovie.isFavorite ? Colors.red : Colors.black87,
                  size: 24,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 220,
                    height: 320,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        currentMovie.poster,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  currentMovie.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromRGBO(158, 158, 158, 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(
                        Icons.calendar_today,
                        currentMovie.releaseDate,
                        Colors.blue,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: const Color.fromRGBO(158, 158, 158, 0.3),
                      ),
                      _buildInfoItem(
                        Icons.star,
                        currentMovie.rating,
                        Colors.amber,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: const Color.fromRGBO(158, 158, 158, 0.3),
                      ),
                      _buildInfoItem(
                        Icons.movie,
                        currentMovie.genre,
                        Colors.purple,
                        isText: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Synopsis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentMovie.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      bloc.toggleFavorite(currentMovie.id);
                    },
                    icon: Icon(
                      currentMovie.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: currentMovie.isFavorite ? Colors.white : Colors.red,
                    ),
                    label: Text(
                      currentMovie.isFavorite ? 'Remove from Favorite' : 'Add to Favorite',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: currentMovie.isFavorite ? Colors.white : Colors.red,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentMovie.isFavorite ? Colors.red : Colors.white,
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Movie? _findMovie(List<Movie> movies, String id) {
    try {
      return movies.firstWhere((movie) => movie.id == id);
    } catch (_) {
      return null;
    }
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    Color color, {
    bool isText = false,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isText ? 11 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
