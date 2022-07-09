import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesWatchlistBloc seriesWatchlistBloc;
  late MockGetWatchlistSeries mockGetWatchlistSeries;
  late MockGetWatchlistSeriesStatus mockGetWatchlistSeriesStatus;
  late MockSaveWatchlistSeries mockSaveWatchlistSeries;
  late MockRemoveWatchlistSeries mockRemoveWatchlistSeries;

  setUp(() {
    mockGetWatchlistSeries = MockGetWatchlistSeries();
    mockGetWatchlistSeriesStatus = MockGetWatchlistSeriesStatus();
    mockSaveWatchlistSeries = MockSaveWatchlistSeries();
    mockRemoveWatchlistSeries = MockRemoveWatchlistSeries();
    seriesWatchlistBloc = SeriesWatchlistBloc(
        getWatchlistSeries: mockGetWatchlistSeries,
        getWatchlistSeriesStatus: mockGetWatchlistSeriesStatus,
        removeWatchlistSeries: mockRemoveWatchlistSeries,
        saveWatchlistSeries: mockSaveWatchlistSeries);
  });
  test('initial state should be empty', () {
    expect(seriesWatchlistBloc.state, SeriesWatchlistEmpty());
  });

  group('Series Watchlist Test', () {
    blocTest<SeriesWatchlistBloc, SeriesWatchlistState>(
      'Should emit [Loading, HasData] when series watchlist data is gotten successfully',
      build: () {
        when(mockGetWatchlistSeries.execute())
            .thenAnswer((_) async => Right([testWatchlistSeries]));
        return seriesWatchlistBloc;
      },
      act: (bloc) => bloc.add(SeriesWatchlist()),
      expect: () => [
        SeriesWatchlistLoading(),
        SeriesWatchlistHasData([testWatchlistSeries]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistSeries.execute());
        return SeriesWatchlist().props;
      },
    );

    blocTest<SeriesWatchlistBloc, SeriesWatchlistState>(
      'Should emit [Loading, Error] when get series watchlist is unsuccessful',
      build: () {
        when(mockGetWatchlistSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return seriesWatchlistBloc;
      },
      act: (bloc) => bloc.add(SeriesWatchlist()),
      expect: () => <SeriesWatchlistState>[
        SeriesWatchlistLoading(),
        const SeriesWatchlistError('Server Failure'),
      ],
      verify: (bloc) => SeriesWatchlistLoading(),
    );
  });

  group('Series Watchlist Status Test', () {
    blocTest<SeriesWatchlistBloc, SeriesWatchlistState>(
      'Should return true when series watchlist status is true',
      build: () {
        when(mockGetWatchlistSeriesStatus.execute(testSeriesDetail.id))
            .thenAnswer((_) async => true);
        return seriesWatchlistBloc;
      },
      act: (bloc) => bloc.add(SeriesWatchlistStatus(testSeriesDetail.id)),
      expect: () =>
          [SeriesWatchlistLoading(), const SeriesWatchlistHasStatus(true)],
      verify: (bloc) {
        verify(mockGetWatchlistSeriesStatus.execute(testSeriesDetail.id));
        return SeriesWatchlistStatus(testSeriesDetail.id).props;
      },
    );

    blocTest<SeriesWatchlistBloc, SeriesWatchlistState>(
      'Should return false when series watchlist status is false',
      build: () {
        when(mockGetWatchlistSeriesStatus.execute(testSeriesDetail.id))
            .thenAnswer((_) async => false);
        return seriesWatchlistBloc;
      },
      act: (bloc) => bloc.add(SeriesWatchlistStatus(testSeriesDetail.id)),
      expect: () => <SeriesWatchlistState>[
        SeriesWatchlistLoading(),
        const SeriesWatchlistHasStatus(false),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistSeriesStatus.execute(testSeriesDetail.id));
        return SeriesWatchlistStatus(testSeriesDetail.id).props;
      },
    );
  });

  group('Add Series Watchlist Test', () {
    blocTest<SeriesWatchlistBloc, SeriesWatchlistState>(
      'Should update watchlist status when series watchlist is successfully added',
      build: () {
        when(mockSaveWatchlistSeries.execute(testSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return seriesWatchlistBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistSeries(testSeriesDetail)),
      expect: () => [
        const SeriesWatchlistHasMessage('Added to Watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistSeries.execute(testSeriesDetail));
        return AddWatchlistSeries(testSeriesDetail).props;
      },
    );

    blocTest<SeriesWatchlistBloc, SeriesWatchlistState>(
      'Should return error message when series watchlist is unsuccessfully added',
      build: () {
        when(mockSaveWatchlistSeries.execute(testSeriesDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return seriesWatchlistBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistSeries(testSeriesDetail)),
      expect: () => [
        const SeriesWatchlistError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistSeries.execute(testSeriesDetail));
        return AddWatchlistSeries(testSeriesDetail).props;
      },
    );
  });

  group('Remove Series Watchlist Test', () {
    blocTest<SeriesWatchlistBloc, SeriesWatchlistState>(
      'Should update watchlist status when series watchlist is successfully removed',
      build: () {
        when(mockRemoveWatchlistSeries.execute(testSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        return seriesWatchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistSeries(testSeriesDetail)),
      expect: () => [
        const SeriesWatchlistHasMessage('Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistSeries.execute(testSeriesDetail));
        return RemoveFromWatchlistSeries(testSeriesDetail).props;
      },
    );

    blocTest<SeriesWatchlistBloc, SeriesWatchlistState>(
      'Should return error message when series watchlist is unsuccessfully removed',
      build: () {
        when(mockRemoveWatchlistSeries.execute(testSeriesDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return seriesWatchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistSeries(testSeriesDetail)),
      expect: () => [
        const SeriesWatchlistError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistSeries.execute(testSeriesDetail));
        return RemoveFromWatchlistSeries(testSeriesDetail).props;
      },
    );
  });
}
