import 'package:cinemapedia_app/infrastructure/datasources/themoviedb_datasource.dart';
import 'package:cinemapedia_app/infrastructure/repositories/movies_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Repository inmutable
final movieRepositoryProvider = Provider((ref) {
  return MoviesRepositoryImpl(TheMovieDbDatasource());
});
