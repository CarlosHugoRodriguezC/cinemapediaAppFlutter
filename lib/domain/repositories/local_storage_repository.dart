import '../entities/movie.dart';

abstract class LocalStorageRepository {
  Future<bool> toggleFavorite(Movie movie);
  Future<bool> isMovieFavorite(int movieId);
  Future<List<Movie>> getFavoriteMovies({int limit = 10, int offset = 0});
}
