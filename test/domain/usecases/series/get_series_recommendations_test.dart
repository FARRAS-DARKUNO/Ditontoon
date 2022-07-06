import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/domain/usecases/series/get_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeriesRecommendations useCase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    useCase = GetSeriesRecommendations(mockSeriesRepository);
  });

  final tId = 1;
  final tSeries = <Series>[];

  test('should get list of series recommendations from the repository',
      () async {
    // arrange
    when(mockSeriesRepository.getSeriesRecommendations(tId))
        .thenAnswer((_) async => Right(tSeries));
    // act
    final result = await useCase.execute(tId);
    // assert
    expect(result, Right(tSeries));
  });
}
