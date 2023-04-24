import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = "movie_screen";
  final String movieId;

  const MovieScreen({
    super.key,
    required this.movieId,
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppbar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) => _MovieDetails(movie: movie),
            ),
          )
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MovieDescription(movie: movie, size: size, textStyles: textStyles),
        _GenresChips(movie: movie),
        _ActorByMovie(
          movieId: movie.id.toString(),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppbar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppbar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
            onPressed: () {
              ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
              ref.invalidate(isFavoriteProvider(movie.id));
            },
            icon: isFavoriteFuture.when(
              data: (data) => data
                  ? const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border),
              error: (_, __) => const Icon(Icons.favorite_border),
              loading: () => const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )

            // icon: const Icon(Icons.favorite_border),
            // icon: const Icon(
            //   Icons.favorite_rounded,
            //   color: Colors.red,
            // ),
            ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.left,
        // ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(children: [
          SizedBox.expand(
            child: Image.network(
              movie.posterPath,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) return const SizedBox();
                return FadeIn(child: child);
              },
            ),
          ),
          const _CustomGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.0, 0.5],
              colors: [Colors.black54, Colors.transparent]),
          const _CustomGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.3],
              colors: [Colors.black54, Colors.transparent]),
          const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.4],
              colors: [Colors.black54, Colors.transparent]),
        ]),
      ),
    );
  }
}

class _MovieDescription extends StatelessWidget {
  const _MovieDescription({
    required this.movie,
    required this.size,
    required this.textStyles,
  });

  final Movie movie;
  final Size size;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              movie.posterPath,
              width: size.width * 0.3,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          //Description
          SizedBox(
            width: (size.width - 40) * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textStyles.titleLarge,
                ),
                Text(movie.overview)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _GenresChips extends StatelessWidget {
  const _GenresChips({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(children: [
        ...movie.genreIds.map(
          (genre) => Container(
            margin: const EdgeInsets.only(right: 10),
            child: Chip(
              label: Text(genre),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        )
      ]),
    );
  }
}

class _ActorByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorByMovie({
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider)[movieId];

    if (actorsByMovie == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actorsByMovie.length,
          itemBuilder: (context, index) {
            final actor = actorsByMovie[index];

            return FadeInRight(
              child: Container(
                padding: const EdgeInsets.all(8),
                width: 135,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //actor photo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        actor.profilePath,
                        height: 180,
                        width: 135,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // actorn name

                    const SizedBox(
                      height: 5,
                    ),
                    Text(actor.name),
                    Text(
                      actor.character ?? '',
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  // begin
  final AlignmentGeometry begin;
  // end
  final AlignmentGeometry end;
  // stops
  final List<double> stops;
  // colors
  final List<Color> colors;

  const _CustomGradient({
    required this.begin,
    required this.end,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
