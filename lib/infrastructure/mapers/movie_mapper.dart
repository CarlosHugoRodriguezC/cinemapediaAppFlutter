import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb.dart';

import '../../domain/entities/movie.dart';

class MovieMapper {
  static Movie movieDbToEntity(MovieMovieDB movieDb) => Movie(
        adult: movieDb.adult,
        backdropPath: movieDb.backdropPath != ''
            ? 'https://image.tmdb.org/t/p/w500/${movieDb.backdropPath}'
            : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
        genreIds: movieDb.genreIds.map((e) => e.toString()).toList(),
        id: movieDb.id,
        originalLanguage: movieDb.originalLanguage,
        originalTitle: movieDb.originalTitle,
        overview: movieDb.overview,
        popularity: movieDb.popularity,
        posterPath: movieDb.posterPath != ''
            ? 'https://image.tmdb.org/t/p/w500/${movieDb.posterPath}'
            : 'no-poster',
        releaseDate: movieDb.releaseDate,
        title: movieDb.title,
        video: movieDb.video,
        voteAverage: movieDb.voteAverage,
        voteCount: movieDb.voteCount,
      );

  static Movie movieDetailsToEntity(MovieDetails movieDb) => Movie(
        adult: movieDb.adult,
        backdropPath: movieDb.backdropPath != ''
            ? 'https://image.tmdb.org/t/p/w500/${movieDb.backdropPath}'
            : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
        genreIds: movieDb.genres.map((e) => e.name).toList(),
        id: movieDb.id,
        originalLanguage: movieDb.originalLanguage,
        originalTitle: movieDb.originalTitle,
        overview: movieDb.overview,
        popularity: movieDb.popularity,
        posterPath: movieDb.posterPath != ''
            ? 'https://image.tmdb.org/t/p/w500/${movieDb.posterPath}'
            : 'no-poster',
        releaseDate: movieDb.releaseDate,
        title: movieDb.title,
        video: movieDb.video,
        voteAverage: movieDb.voteAverage,
        voteCount: movieDb.voteCount,
      );
}
