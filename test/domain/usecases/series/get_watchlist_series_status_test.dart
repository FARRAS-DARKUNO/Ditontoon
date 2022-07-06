import 'package:ditonton/domain/usecases/series/get_watchlist_series_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistSeriesStatus useCase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    useCase = GetWatchlistSeriesStatus(mockSeriesRepository);
  });

  test('should get watchlist series status from repository', () async {
    // arrange
    when(mockSeriesRepository.isAddedToWatchlistSeries(1))
        .thenAnswer((_) async => true);
    // act
    final result = await useCase.execute(1);
    // assert
    expect(result, true);
  });
}
