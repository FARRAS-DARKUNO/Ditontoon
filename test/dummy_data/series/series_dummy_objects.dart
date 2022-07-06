import 'package:ditonton/data/models/series/series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/domain/entities/series/series_detail.dart';

final testSeries = Series(
    backdropPath: '/suopoADq0k8YZr4dQXcU6pToj6s.jpg',
    genreIds: [10765, 18, 10759, 9648],
    id: 1399,
    name: 'Dragon Kingdom',
    overview: 'Empire attack NTAPS',
    popularity: 369.594,
    posterPath: '/u3bZgncwwcwcsWNhyveQzciwuidwchiw.jpg',
    voteAverage: 8.3,
    voteCount: 11504);

final testSeriesList = [testSeries];

final testSeriesDetail = SeriesDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'name',
  overview: 'overview',
  posterPath: 'posterPath',
  voteAverage: 1,
  voteCount: 1,
  firstAirDate: 'firstAirDate',
  lastAirDate: 'lastAirDate',
  numberOfSeasons: 1,
  numberOfEpisodes: 1,
);

final testWatchlistSeries = Series.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testSeriesTable = SeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
