import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesRecommendationsBloc seriesRecommendationsBloc;
  late MockGetSeriesRecommendations mockGetSeriesRecommendations;

  setUp(() {
    mockGetSeriesRecommendations = MockGetSeriesRecommendations();
    seriesRecommendationsBloc =
        SeriesRecommendationsBloc(mockGetSeriesRecommendations);
  });

  test("initial state should be empty", () {
    expect(seriesRecommendationsBloc.state, SeriesRecommendationEmpty());
  });

  const tId = 1;
  final tSeriesList = <Series>[];

  blocTest<SeriesRecommendationsBloc, SeriesState>(
    'Should emit [Loading, HasData] when series recommendation data is gotten successfully',
    build: () {
      when(mockGetSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tSeriesList));
      return seriesRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const SeriesRecommendation(tId)),
    expect: () => [
      SeriesRecommendationLoading(),
      SeriesRecommendationHasData(tSeriesList)
    ],
    verify: (bloc) {
      verify(mockGetSeriesRecommendations.execute(tId));
    },
  );

  blocTest<SeriesRecommendationsBloc, SeriesState>(
    'Should emit [Loading, Error] when get series recommendation is unsuccessful',
    build: () {
      when(mockGetSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seriesRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const SeriesRecommendation(tId)),
    expect: () => [
      SeriesRecommendationLoading(),
      const SeriesRecommendationError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetSeriesRecommendations.execute(tId));
    },
  );

  blocTest<SeriesRecommendationsBloc, SeriesState>(
    'Should emit [Loading, Empty] when series recommendation data is empty',
    build: () {
      when(mockGetSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => const Right([]));
      return seriesRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const SeriesRecommendation(tId)),
    expect: () => <SeriesState>[
      SeriesRecommendationLoading(),
      const SeriesRecommendationHasData([]),
    ],
  );
}
