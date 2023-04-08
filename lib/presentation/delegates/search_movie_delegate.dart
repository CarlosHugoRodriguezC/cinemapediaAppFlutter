import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia_app/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  void _onQueryChange(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  void clearStreams() {
    debouncedMovies.close();
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      stream: debouncedMovies.stream,
      initialData: initialMovies,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              movie: movie,
              onMovieSelected: (context, movie) {
                close(context, movie);
                clearStreams();
              },
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => "Buscar pelicula";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        StreamBuilder(
          stream: isLoadingStream.stream,
          initialData: false,
          builder: (context, snapshot) {
            final isLoading = snapshot.data ?? false;

            if (isLoading) {
              return SpinPerfect(
                duration: const Duration(seconds: 10),
                spins: 10,
                animate: query.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    query = '';
                  },
                  icon: const Icon(Icons.refresh_rounded),
                ),
              );
            }
            return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(
                onPressed: () {
                  query = '';
                },
                icon: const Icon(Icons.clear),
              ),
            );
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
        clearStreams();
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);
    return buildResultsAndSuggestions();
  }
}

typedef OnMovieSelectedCallback = void Function(BuildContext, Movie?);

class _MovieItem extends StatelessWidget {
  final Movie movie;

  final OnMovieSelectedCallback onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Row(children: [
          // image
          SizedBox(
            width: size.width * .20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                loadingBuilder: (context, child, loadingProgress) {
                  return FadeIn(child: child);
                },
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // description
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textStyles.titleMedium,
                ),
                Text(
                  movie.overview,
                  maxLines: 3,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star_half_rounded,
                      color: Colors.yellow.shade800,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      HumanFormats.number(movie.voteAverage, decimals: 1),
                      style: textStyles.bodyMedium
                          ?.copyWith(color: Colors.yellow.shade900),
                    )
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
