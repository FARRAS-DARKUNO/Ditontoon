import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late NowPlayingSeriesBloc nowPlayingSeriesBloc;
  late MockGetNowPlayingSeries mockGetNowPlayingSeries;

  setUp(() {
    mockGetNowPlayingSeries = MockGetNowPlayingSeries();
    nowPlayingSeriesBloc = NowPlayingSeriesBloc(mockGetNowPlayingSeries);
  });

  test('initial state should be empty', () {
    expect(nowPlayingSeriesBloc.state, NowPlayingSeriesEmpty());
  });

  blocTest<NowPlayingSeriesBloc, SeriesState>(
    'Should emit [Loading, HasData] when now playing series data is gotten successfully',
    build: () {
      when(mockGetNowPlayingSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(NowPlayingSeries()),
    expect: () => <SeriesState>[
      NowPlayingSeriesLoading(),
      NowPlayingSeriesHasData(testSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingSeries.execute());
      return NowPlayingSeries().props;
    },
  );

  blocTest<NowPlayingSeriesBloc, SeriesState>(
    'Should emit [Loading, Error] when get now playing series is unsuccessful',
    build: () {
      when(mockGetNowPlayingSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(NowPlayingSeries()),
    expect: () => <SeriesState>[
      NowPlayingSeriesLoading(),
      const NowPlayingSeriesError('Server Failure'),
    ],
    verify: (bloc) => NowPlayingSeriesLoading(),
  );
}
