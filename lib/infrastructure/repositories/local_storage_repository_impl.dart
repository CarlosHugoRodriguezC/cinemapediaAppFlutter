import 'package:cinemapedia_app/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getFavoriteMovies({int limit = 10, int offset = 0}) {
    return datasource.getFavoriteMovies(limit: limit, offset: offset);
  }

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasource.isMovieFavorite(movieId);
  }

  @override
  Future<bool> toggleFavorite(Movie movie) {
    return datasource.toggleFavorite(movie);
  }
}
