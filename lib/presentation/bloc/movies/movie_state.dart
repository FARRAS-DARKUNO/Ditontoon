part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class NowPlayingMovieEmpty extends MovieState {
  @override
  List<Object> get props => [];
}

class NowPlayingMovieLoading extends MovieState {}

class NowPlayingMovieError extends MovieState {
  final String message;

  const NowPlayingMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingMovieHasData extends MovieState {
  final List<Movie> resultNowPlayingMovie;

  const NowPlayingMovieHasData(this.resultNowPlayingMovie);

  @override
  List<Object> get props => [resultNowPlayingMovie];
}

class TopRatedMovieEmpty extends MovieState {}

class TopRatedMovieLoading extends MovieState {}

class TopRatedMovieError extends MovieState {
  final String message;

  const TopRatedMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedMovieHasData extends MovieState {
  final List<Movie> resultTopRatedMovie;

  const TopRatedMovieHasData(this.resultTopRatedMovie);

  @override
  List<Object> get props => [resultTopRatedMovie];
}

class MovieDetailEmpty extends MovieState {}

class MovieDetailLoading extends MovieState {}

class MovieDetailError extends MovieState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMovieEmpty extends MovieState {}

class PopularMovieLoading extends MovieState {}

class PopularMovieError extends MovieState {
  final String message;

  const PopularMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMovieHasData extends MovieState {
  final List<Movie> resultPopularMovie;

  const PopularMovieHasData(this.resultPopularMovie);

  @override
  List<Object> get props => [resultPopularMovie];
}

class MovieDetailHasData extends MovieState {
  final MovieDetail movieDetail;

  const MovieDetailHasData(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class MovieRecommendationEmpty extends MovieState {}

class MovieRecommendationLoading extends MovieState {}

class MovieRecommendationError extends MovieState {
  final String message;

  const MovieRecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieRecommendationHasData extends MovieState {
  final List<Movie> movie;

  const MovieRecommendationHasData(this.movie);

  @override
  List<Object> get props => [movie];
}

abstract class MovieWatchlistState extends Equatable {
  const MovieWatchlistState();

  @override
  List<Object?> get props => [];
}

class MovieWatchlistHasStatus extends MovieWatchlistState {
  final bool result;

  const MovieWatchlistHasStatus(this.result);

  @override
  List<Object?> get props => [result];
}

class MovieWatchlistHasMessage extends MovieWatchlistState {
  final String message;

  const MovieWatchlistHasMessage(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistHasData extends MovieWatchlistState {
  final List<Movie> movie;

  const MovieWatchlistHasData(this.movie);

  @override
  List<Object?> get props => [movie];
}

class MovieWatchlistEmpty extends MovieWatchlistState {}

class MovieWatchlistLoading extends MovieWatchlistState {}

class MovieWatchlistError extends MovieWatchlistState {
  final String message;

  const MovieWatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}
