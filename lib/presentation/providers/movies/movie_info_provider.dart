import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>(
  (ref) {
    final fetchMovieDetail = ref.watch(movieRepositoryProvider).getMovieById;
    return MovieMapNotifier(getMovieCallback: fetchMovieDetail);
  },
);

typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovieCallback;
  MovieMapNotifier({required this.getMovieCallback}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;
    // print('fetching movie...');
    final movie = await getMovieCallback(movieId);

    state = {...state, movieId: movie};
  }
}
