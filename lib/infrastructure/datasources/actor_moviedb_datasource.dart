import 'package:cinemapedia_app/config/constants/environment.dart';
import 'package:cinemapedia_app/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia_app/domain/entities/actor.dart';
import 'package:cinemapedia_app/infrastructure/mapers/actor_mapper.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  List<Actor> _jsonToActor(Map<String, dynamic> json) {
    final actorsResponse = CreditsResponse.fromJson(json);
    final List<Actor> actors = actorsResponse.cast
        .map(
          (cast) => ActorMapper.castToEntity(cast),
        )
        .toList();
    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    return _jsonToActor(response.data);
  }
}
