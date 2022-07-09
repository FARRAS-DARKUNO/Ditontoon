part of 'series_bloc.dart';

abstract class SeriesEvent extends Equatable {
  const SeriesEvent();
}

class RemoveFromWatchlistSeries extends SeriesEvent {
  final SeriesDetail seriesDetail;

  const RemoveFromWatchlistSeries(this.seriesDetail);

  @override
  List<Object> get props => [seriesDetail];
}

class NowPlayingSeries extends SeriesEvent {
  @override
  List<Object> get props => [];
}

class SeriesRecommendation extends SeriesEvent {
  final int id;

  const SeriesRecommendation(this.id);
  @override
  List<Object> get props => [id];
}

class SeriesWatchlist extends SeriesEvent {
  @override
  List<Object> get props => [];
}

class SeriesWatchlistStatus extends SeriesEvent {
  final int id;

  const SeriesWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class PopularSeries extends SeriesEvent {
  @override
  List<Object> get props => [];
}

class TopRatedSeries extends SeriesEvent {
  @override
  List<Object> get props => [];
}

class DetailSeries extends SeriesEvent {
  final int id;

  const DetailSeries(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlistSeries extends SeriesEvent {
  final SeriesDetail seriesDetail;

  const AddWatchlistSeries(this.seriesDetail);

  @override
  List<Object> get props => [seriesDetail];
}
