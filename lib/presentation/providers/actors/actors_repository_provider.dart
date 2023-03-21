import 'package:cinemapedia_app/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia_app/infrastructure/repositories/actors_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository inmutable
final actorsRepositoryProvider = Provider((ref) {
  return ActorsRepositoryImpl(ActorMovieDbDatasource());
});
