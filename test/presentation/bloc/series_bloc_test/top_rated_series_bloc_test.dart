import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedSeriesBloc topRatedSeriesBloc;
  late MockGetTopRatedSeries mockGetTopRatedSeries;

  setUp(() {
    mockGetTopRatedSeries = MockGetTopRatedSeries();
    topRatedSeriesBloc = TopRatedSeriesBloc(mockGetTopRatedSeries);
  });

  test("initial state should be empty", () {
    expect(topRatedSeriesBloc.state, TopRatedSeriesEmpty());
  });

  final tSeriesList = <Series>[];

  blocTest<TopRatedSeriesBloc, SeriesState>(
    'Should emit [Loading, HasData] when top rated series data is gotten successfully',
    build: () {
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(TopRatedSeries()),
    expect: () => [TopRatedSeriesLoading(), TopRatedSeriesHasData(tSeriesList)],
    verify: (bloc) {
      verify(mockGetTopRatedSeries.execute());
    },
  );

  blocTest<TopRatedSeriesBloc, SeriesState>(
    'Should emit [Loading, Error] when get top rated series is unsuccessful',
    build: () {
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(TopRatedSeries()),
    expect: () =>
        [TopRatedSeriesLoading(), const TopRatedSeriesError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTopRatedSeries.execute());
    },
  );
}
