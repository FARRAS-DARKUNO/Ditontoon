import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/series/series_detail_model.dart';
import 'package:ditonton/data/models/series/series_model.dart';
import 'package:ditonton/data/repositories/series_repository_impl.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/series/series_dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesRepositoryImpl seriesRepository;
  late MockSeriesRemoteDataSource mockSeriesRemoteDataSource;
  late MockSeriesLocalDataSource mockSeriesLocalDataSource;

  setUp(() {
    mockSeriesRemoteDataSource = MockSeriesRemoteDataSource();
    mockSeriesLocalDataSource = MockSeriesLocalDataSource();
    seriesRepository = SeriesRepositoryImpl(
      remoteDataSource: mockSeriesRemoteDataSource,
      localDataSource: mockSeriesLocalDataSource,
    );
  });

  final tSeriesModel = SeriesModel(
    backdropPath: '/suopoADq0k8YZr4dQXcU6pToj6s.jpg',
    genreIds: [10765, 18, 10759, 9648],
    id: 1399,
    name: 'Game of Thrones',
    overview:
        "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
    popularity: 369.594,
    posterPath: '/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg',
    voteAverage: 8.3,
    voteCount: 11504,
  );

  final tSeries = Series(
    backdropPath: '/suopoADq0k8YZr4dQXcU6pToj6s.jpg',
    genreIds: [10765, 18, 10759, 9648],
    id: 1399,
    name: 'Game of Thrones',
    overview:
        "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
    popularity: 369.594,
    posterPath: '/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg',
    voteAverage: 8.3,
    voteCount: 11504,
  );

  final tSeriesModelList = <SeriesModel>[tSeriesModel];
  final tSeriesList = <Series>[tSeries];

  group('Now Playing Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getNowPlayingSeries())
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await seriesRepository.getNowPlayingSeries();
      // assert
      verify(mockSeriesRemoteDataSource.getNowPlayingSeries());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getNowPlayingSeries())
          .thenThrow(ServerException());
      // act
      final result = await seriesRepository.getNowPlayingSeries();
      // assert
      verify(mockSeriesRemoteDataSource.getNowPlayingSeries());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getNowPlayingSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await seriesRepository.getNowPlayingSeries();
      // assert
      verify(mockSeriesRemoteDataSource.getNowPlayingSeries());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular Series', () {
    test('should return series list when call to data source is success',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getPopularSeries())
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await seriesRepository.getPopularSeries();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getPopularSeries())
          .thenThrow(ServerException());
      // act
      final result = await seriesRepository.getPopularSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getPopularSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await seriesRepository.getPopularSeries();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Series', () {
    test('should return series list when call to data source is successful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getTopRatedSeries())
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await seriesRepository.getTopRatedSeries();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getTopRatedSeries())
          .thenThrow(ServerException());
      // act
      final result = await seriesRepository.getTopRatedSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getTopRatedSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await seriesRepository.getTopRatedSeries();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Series Detail', () {
    final tId = 1;
    final tSeriesResponse = SeriesDetailResponse(
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
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

    test(
        'should return Series data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getSeriesDetail(tId))
          .thenAnswer((_) async => tSeriesResponse);
      // act
      final result = await seriesRepository.getSeriesDetail(tId);
      // assert
      verify(mockSeriesRemoteDataSource.getSeriesDetail(tId));
      expect(result, equals(Right(testSeriesDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getSeriesDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await seriesRepository.getSeriesDetail(tId);
      // assert
      verify(mockSeriesRemoteDataSource.getSeriesDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getSeriesDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await seriesRepository.getSeriesDetail(tId);
      // assert
      verify(mockSeriesRemoteDataSource.getSeriesDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Series Recommendations', () {
    final tSeriesList = <SeriesModel>[];
    final tId = 1;

    test('should return series list data when the call is successful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getSeriesRecommendations(tId))
          .thenAnswer((_) async => tSeriesList);
      // act
      final result = await seriesRepository.getSeriesRecommendations(tId);
      // assert
      verify(mockSeriesRemoteDataSource.getSeriesRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tSeriesList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getSeriesRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await seriesRepository.getSeriesRecommendations(tId);
      // assert
      verify(mockSeriesRemoteDataSource.getSeriesRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.getSeriesRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await seriesRepository.getSeriesRecommendations(tId);
      // assert
      verify(mockSeriesRemoteDataSource.getSeriesRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search Series', () {
    final tQuery = 'game of thrones';

    test('should return series list when call to data source is successful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.searchSeries(tQuery))
          .thenAnswer((_) async => tSeriesModelList);
      // act
      final result = await seriesRepository.searchSeries(tQuery);
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.searchSeries(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await seriesRepository.searchSeries(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockSeriesRemoteDataSource.searchSeries(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await seriesRepository.searchSeries(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist series', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockSeriesLocalDataSource.insertWatchListSeries(testSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result =
          await seriesRepository.saveWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return Database Failure when saving unsuccessful', () async {
      // arrange
      when(mockSeriesLocalDataSource.insertWatchListSeries(testSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result =
          await seriesRepository.saveWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist series', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockSeriesLocalDataSource.removeWatchListSeries(testSeriesTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result =
          await seriesRepository.removeWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return Database Failure when remove unsuccessful', () async {
      // arrange
      when(mockSeriesLocalDataSource.removeWatchListSeries(testSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result =
          await seriesRepository.removeWatchlistSeries(testSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist series status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockSeriesLocalDataSource.getSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await seriesRepository.isAddedToWatchlistSeries(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist series', () {
    test('should return list of Series', () async {
      // arrange
      when(mockSeriesLocalDataSource.getWatchListSeries())
          .thenAnswer((_) async => [testSeriesTable]);
      // act
      final result = await seriesRepository.getWatchlistSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistSeries]);
    });
  });
}
