import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/domain/usecases/series/search_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchSeries useCase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    useCase = SearchSeries(mockSeriesRepository);
  });

  final tSeries = <Series>[];
  final tQuery = 'Dragon Kingdom';

  test('should get list of series from the repository', () async {
    // arrange
    when(mockSeriesRepository.searchSeries(tQuery))
        .thenAnswer((_) async => Right(tSeries));
    // act
    final result = await useCase.execute(tQuery);
    // assert
    expect(result, Right(tSeries));
  });
}
