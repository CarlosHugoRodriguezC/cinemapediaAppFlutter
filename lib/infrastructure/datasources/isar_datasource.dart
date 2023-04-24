import 'package:cinemapedia_app/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDatabase();
  }

  Future<Isar> openDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([MovieSchema],
          directory: dir.path, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<List<Movie>> getFavoriteMovies(
      {int limit = 10, int offset = 0}) async {
    final isar = await db;

    final List<Movie> movies =
        await isar.movies.where().offset(offset).limit(limit).findAll();

    return movies;
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? movie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();

    return movie != null;
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovie != null) {
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;
    }
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
