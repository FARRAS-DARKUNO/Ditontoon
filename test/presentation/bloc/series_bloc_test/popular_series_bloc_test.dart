import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late PopularSeriesBloc popularSeriesBloc;
  late MockGetPopularSeries mockGetPopularSeries;

  setUp(() {
    mockGetPopularSeries = MockGetPopularSeries();
    popularSeriesBloc = PopularSeriesBloc(mockGetPopularSeries);
  });

  test("initial state should be empty", () {
    expect(popularSeriesBloc.state, PopularSeriesEmpty());
  });

  final tSeriesList = <Series>[];

  blocTest<PopularSeriesBloc, SeriesState>(
    'Should emit [Loading, HasData] when popular series data is gotten successfully',
    build: () {
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(PopularSeries()),
    expect: () => [PopularSeriesLoading(), PopularSeriesHasData(tSeriesList)],
    verify: (bloc) {
      verify(mockGetPopularSeries.execute());
    },
  );

  blocTest<PopularSeriesBloc, SeriesState>(
    'Should emit [Loading, Error] when get popular series is unsuccessful',
    build: () {
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(PopularSeries()),
    expect: () =>
        [PopularSeriesLoading(), const PopularSeriesError('Server Failure')],
    verify: (bloc) {
      verify(mockGetPopularSeries.execute());
    },
  );
}
