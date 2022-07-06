import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/domain/usecases/series/get_popular_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularSeries useCase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    useCase = GetPopularSeries(mockSeriesRepository);
  });

  final tSeries = <Series>[];

  group('Get Popular Series Test', () {
    test(
        'should get list of series from the repository when execute function is called',
        () async {
      // arrange
      when(mockSeriesRepository.getPopularSeries())
          .thenAnswer((_) async => Right(tSeries));
      // act
      final result = await useCase.execute();
      // assert
      expect(result, Right(tSeries));
    });
  });
}
