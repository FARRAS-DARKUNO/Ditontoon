import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/series/series_remote_data_source.dart';
import 'package:ditonton/data/models/series/series_detail_model.dart';
import 'package:ditonton/data/models/series/series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../helpers/test_helper.mocks.dart';
import '../../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late SeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = SeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Series', () {
    final tSeriesList = SeriesResponse.fromJson(
            json.decode(readJson('dummy_data/series/now_playing_series.json')))
        .seriesList;

    test('should return list of Series Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/series/now_playing_series.json'), 200));
      // act
      final result = await dataSource.getNowPlayingSeries();
      // assert
      expect(result, equals(tSeriesList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlayingSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Series', () {
    final tTvsList = SeriesResponse.fromJson(
            json.decode(readJson('dummy_data/series/popular_series.json')))
        .seriesList;

    test('should return list of series when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/series/popular_series.json'), 200));
      // act
      final result = await dataSource.getPopularSeries();
      // assert
      expect(result, tTvsList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Series', () {
    final tTvsList = SeriesResponse.fromJson(
            json.decode(readJson('dummy_data/series/top_rated_series.json')))
        .seriesList;

    test('should return list of series when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/series/top_rated_series.json'), 200));
      // act
      final result = await dataSource.getTopRatedSeries();
      // assert
      expect(result, tTvsList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get series detail', () {
    final tId = 1;
    final tSeriesDetail = SeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/series/series_detail.json')));

    test('should return series detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/series/series_detail.json'), 200));
      // act
      final result = await dataSource.getSeriesDetail(tId);
      // assert
      expect(result, equals(tSeriesDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getSeriesDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get series recommendations', () {
    final tSeriesList = SeriesResponse.fromJson(json
            .decode(readJson('dummy_data/series/series_recommendations.json')))
        .seriesList;
    final tId = 1;

    test('should return list of Series Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/series/series_recommendations.json'), 200));
      // act
      final result = await dataSource.getSeriesRecommendations(tId);
      // assert
      expect(result, equals(tSeriesList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getSeriesRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search series', () {
    final tvsResult = SeriesResponse.fromJson(json.decode(
            readJson('dummy_data/series/search_dragonkingdom_series.json')))
        .seriesList;
    final tQuery = 'Game of Thrones';

    test('should return list of series when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/series/search_dragonkingdom_series.json'),
              200));
      // act
      final result = await dataSource.searchSeries(tQuery);
      // assert
      expect(result, tvsResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchSeries(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
