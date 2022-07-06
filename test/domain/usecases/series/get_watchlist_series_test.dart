import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/series/get_watchlist_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistSeries useCase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    useCase = GetWatchlistSeries(mockSeriesRepository);
  });

  test('should get list of series from the repository', () async {
    // arrange
    when(mockSeriesRepository.getWatchlistSeries())
        .thenAnswer((_) async => Right(testSeriesList));
    // act
    final result = await useCase.execute();
    // assert
    expect(result, Right(testSeriesList));
  });
}
