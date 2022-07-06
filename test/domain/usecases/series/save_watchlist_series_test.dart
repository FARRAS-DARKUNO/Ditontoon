import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/series/save_watchlist_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistSeries useCase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    useCase = SaveWatchlistSeries(mockSeriesRepository);
  });

  test('should save watchlist series to repository', () async {
    // arrange
    when(mockSeriesRepository.saveWatchlistSeries(testSeriesDetail))
        .thenAnswer((_) async => Right('Added from watchlist'));
    // act
    final result = await useCase.execute(testSeriesDetail);
    // assert
    verify(mockSeriesRepository.saveWatchlistSeries(testSeriesDetail));
    expect(result, Right('Added from watchlist'));
  });
}
