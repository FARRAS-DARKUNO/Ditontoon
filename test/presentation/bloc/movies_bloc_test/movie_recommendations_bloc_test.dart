import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movies-entities/movie.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRecommendationsBloc movieRecommendationsBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc =
        MovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  test("initial state should be empty", () {
    expect(movieRecommendationsBloc.state, MovieRecommendationEmpty());
  });

  const tId = 1;
  final tMovieList = <Movie>[];

  blocTest<MovieRecommendationsBloc, MovieState>(
    'Should emit [Loading, HasData] when movie recommendation data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovieList));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const MovieRecommendation(tId)),
    expect: () =>
        [MovieRecommendationLoading(), MovieRecommendationHasData(tMovieList)],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieRecommendationsBloc, MovieState>(
    'Should emit [Loading, Error] when get movie recommendation is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const MovieRecommendation(tId)),
    expect: () => [
      MovieRecommendationLoading(),
      const MovieRecommendationError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieRecommendationsBloc, MovieState>(
    'Should emit [Loading, Empty] when movie recommendation data is empty',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => const Right([]));
      return movieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const MovieRecommendation(tId)),
    expect: () => <MovieState>[
      MovieRecommendationLoading(),
      const MovieRecommendationHasData([]),
    ],
  );
}
