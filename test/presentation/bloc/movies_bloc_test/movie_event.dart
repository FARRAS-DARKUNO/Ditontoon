part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
}

class PopularMovie extends MovieEvent {
  @override
  List<Object> get props => [];
}

class MovieWatchlist extends MovieEvent {
  @override
  List<Object> get props => [];
}

class WatchlistStatus extends MovieEvent {
  final int id;

  const WatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class NowPlayingMovie extends MovieEvent {
  @override
  List<Object> get props => [];
}

class DetailMovie extends MovieEvent {
  final int id;

  const DetailMovie(this.id);

  @override
  List<Object> get props => [id];
}

class TopRatedMovie extends MovieEvent {
  @override
  List<Object> get props => [];
}

class AddWatchlist extends MovieEvent {
  final MovieDetail movieDetail;

  const AddWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class RemoveFromWatchlist extends MovieEvent {
  final MovieDetail movieDetail;

  const RemoveFromWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class MovieRecommendation extends MovieEvent {
  final int id;

  const MovieRecommendation(this.id);
  @override
  List<Object> get props => [id];
}
