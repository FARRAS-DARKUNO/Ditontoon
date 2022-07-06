import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/series/get_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeriesDetail useCase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    useCase = GetSeriesDetail(mockSeriesRepository);
  });

  final tId = 1;

  test('should get series detail from the repository', () async {
    // arrange
    when(mockSeriesRepository.getSeriesDetail(tId))
        .thenAnswer((_) async => Right(testSeriesDetail));
    // act
    final result = await useCase.execute(tId);
    // assert
    expect(result, Right(testSeriesDetail));
  });
}
