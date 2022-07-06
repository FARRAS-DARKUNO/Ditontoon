import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/series/remove_watchlist_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistSeries useCase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    useCase = RemoveWatchlistSeries(mockSeriesRepository);
  });

  test('should remove watchlist series from repository', () async {
    // arrange
    when(mockSeriesRepository.removeWatchlistSeries(testSeriesDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await useCase.execute(testSeriesDetail);
    // assert
    verify(mockSeriesRepository.removeWatchlistSeries(testSeriesDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
