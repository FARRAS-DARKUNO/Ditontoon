import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesDetailBloc seriesDetailBloc;
  late MockGetSeriesDetail mockGetSeriesDetail;

  setUp(() {
    mockGetSeriesDetail = MockGetSeriesDetail();
    seriesDetailBloc = SeriesDetailBloc(mockGetSeriesDetail);
  });

  test("initial state should be empty", () {
    expect(seriesDetailBloc.state, SeriesDetailEmpty());
  });

  const tId = 1;

  blocTest<SeriesDetailBloc, SeriesState>(
    'Should emit [Loading, HasData] when series detail data is gotten successfully',
    build: () {
      when(mockGetSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testSeriesDetail));
      return seriesDetailBloc;
    },
    act: (bloc) => bloc.add(const DetailSeries(tId)),
    expect: () =>
        [SeriesDetailLoading(), SeriesDetailHasData(testSeriesDetail)],
    verify: (bloc) {
      verify(mockGetSeriesDetail.execute(tId));
    },
  );

  blocTest<SeriesDetailBloc, SeriesState>(
    'Should emit [Loading, Error] when get series detail is unsuccessful',
    build: () {
      when(mockGetSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seriesDetailBloc;
    },
    act: (bloc) => bloc.add(const DetailSeries(tId)),
    expect: () =>
        [SeriesDetailLoading(), const SeriesDetailError('Server Failure')],
    verify: (bloc) {
      verify(mockGetSeriesDetail.execute(tId));
    },
  );
}
