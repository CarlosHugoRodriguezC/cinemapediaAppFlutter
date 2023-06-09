import 'package:cinemapedia_app/domain/entities/movie.dart';

abstract class LocalStorageDatasource {
  Future<bool> toggleFavorite(Movie movie);
  Future<bool> isMovieFavorite(int movieId);
  Future<List<Movie>> getFavoriteMovies({int limit = 10, int offset = 0});
}
