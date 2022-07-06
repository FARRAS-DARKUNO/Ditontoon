import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/domain/usecases/series/get_now_playing_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingSeries useCase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    useCase = GetNowPlayingSeries(mockSeriesRepository);
  });

  final tSeries = <Series>[];

  test('should get list series from the repository', () async {
    // arrange
    when(mockSeriesRepository.getNowPlayingSeries())
        .thenAnswer((_) async => Right(tSeries));
    // act
    final result = await useCase.execute();
    // assert
    expect(result, Right(tSeries));
  });
}
