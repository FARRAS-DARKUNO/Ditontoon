import 'package:ditonton/data/models/movies-model/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieDetailModel = MovieDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    budget: 1,
    genres: [],
    homepage: 'homepage',
    id: 1,
    imdbId: 'imdbId',
    originalLanguage: 'originalLanguage',
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    revenue: 1,
    runtime: 1,
    status: 'status',
    tagline: 'tagline',
    title: 'title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovieDetail = tMovieDetailModel.toEntity();
  final tMovieDetailJson = tMovieDetailModel.toJson();

  test('should be a subclass of Movie Detail entity', () {
    final result = tMovieDetailModel.toEntity();
    expect(result, tMovieDetail);
  });

  test('should be a json data of Movie Detail model', () {
    final result = tMovieDetailModel.toJson();
    expect(result, tMovieDetailJson);
  });
}
