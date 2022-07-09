import 'package:ditonton/data/models/series/series_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeriesDetailModel = SeriesDetailResponse(
    backdropPath: 'backdropPath',
    genres: [],
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
    firstAirDate: 'firstAirDate',
    lastAirDate: 'lastAirDate',
    numberOfSeasons: 1,
    numberOfEpisodes: 1,
  );

  final tSeriesDetail = tSeriesDetailModel.toEntity();
  final tSeriesDetailJson = tSeriesDetailModel.toJson();

  test('should be a subclass of Series Detail entity', () {
    final result = tSeriesDetailModel.toEntity();
    expect(result, tSeriesDetail);
  });

  test('should be a json data of Series Detail model', () {
    final result = tSeriesDetailModel.toJson();
    expect(result, tSeriesDetailJson);
  });
}
