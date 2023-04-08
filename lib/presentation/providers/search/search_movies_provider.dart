import 'package:cinemapedia_app/domain/repositories/movies_repository.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

final searchQueryProvider = StateProvider((ref) => '');

final searchedMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, List<Movie>>(
  (ref) {
    final searchMovies = ref.read(movieRepositoryProvider).searchMovies;
    return SearchMoviesNotifier(searchMovies: searchMovies, ref: ref);
  },
);

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallback searchMovies;
  final Ref ref;

  SearchMoviesNotifier({required this.searchMovies, required this.ref})
      : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {

    final List<Movie> movies = await searchMovies(query);

    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = movies;

    return movies;
  }
}
