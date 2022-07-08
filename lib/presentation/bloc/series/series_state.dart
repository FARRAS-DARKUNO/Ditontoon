part of 'series_bloc.dart';

abstract class SeriesState extends Equatable {
  const SeriesState();

  @override
  List<Object> get props => [];
}

class NowPlayingSeriesEmpty extends SeriesState {}

class NowPlayingSeriesLoading extends SeriesState {}

class NowPlayingSeriesError extends SeriesState {
  final String message;

  const NowPlayingSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingSeriesHasData extends SeriesState {
  final List<Series> resultNowPlayingSeries;

  const NowPlayingSeriesHasData(this.resultNowPlayingSeries);

  @override
  List<Object> get props => [resultNowPlayingSeries];
}

class PopularSeriesEmpty extends SeriesState {}

class PopularSeriesLoading extends SeriesState {}

class PopularSeriesError extends SeriesState {
  final String message;

  const PopularSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularSeriesHasData extends SeriesState {
  final List<Series> resultPopularSeries;

  const PopularSeriesHasData(this.resultPopularSeries);

  @override
  List<Object> get props => [resultPopularSeries];
}

class TopRatedSeriesEmpty extends SeriesState {}

class TopRatedSeriesLoading extends SeriesState {}

class TopRatedSeriesError extends SeriesState {
  final String message;

  const TopRatedSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedSeriesHasData extends SeriesState {
  final List<Series> resultTopRatedSeries;

  const TopRatedSeriesHasData(this.resultTopRatedSeries);

  @override
  List<Object> get props => [resultTopRatedSeries];
}

class SeriesDetailEmpty extends SeriesState {}

class SeriesDetailLoading extends SeriesState {}

class SeriesDetailError extends SeriesState {
  final String message;

  const SeriesDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class SeriesDetailHasData extends SeriesState {
  final SeriesDetail seriesDetail;

  const SeriesDetailHasData(this.seriesDetail);

  @override
  List<Object> get props => [seriesDetail];
}

class SeriesRecommendationEmpty extends SeriesState {}

class SeriesRecommendationLoading extends SeriesState {}

class SeriesRecommendationError extends SeriesState {
  final String message;

  const SeriesRecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class SeriesRecommendationHasData extends SeriesState {
  final List<Series> series;

  const SeriesRecommendationHasData(this.series);

  @override
  List<Object> get props => [series];
}

abstract class SeriesWatchlistState extends Equatable {
  const SeriesWatchlistState();

  @override
  List<Object?> get props => [];
}

class SeriesWatchlistEmpty extends SeriesWatchlistState {}

class SeriesWatchlistLoading extends SeriesWatchlistState {}

class SeriesWatchlistHasMessage extends SeriesWatchlistState {
  final String message;

  const SeriesWatchlistHasMessage(this.message);

  @override
  List<Object> get props => [message];
}

class SeriesWatchlistHasData extends SeriesWatchlistState {
  final List<Series> series;

  const SeriesWatchlistHasData(this.series);

  @override
  List<Object?> get props => [series];
}

class SeriesWatchlistError extends SeriesWatchlistState {
  final String message;

  const SeriesWatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class SeriesWatchlistHasStatus extends SeriesWatchlistState {
  final bool result;

  const SeriesWatchlistHasStatus(this.result);

  @override
  List<Object?> get props => [result];
}
