import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movies-entities/movie.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  test("initial state should be empty", () {
    expect(popularMoviesBloc.state, PopularMovieEmpty());
  });

  final tMovieList = <Movie>[];

  blocTest<PopularMoviesBloc, MovieState>(
    'Should emit [Loading, HasData] when popular movies data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(PopularMovie()),
    expect: () => [PopularMovieLoading(), PopularMovieHasData(tMovieList)],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );

  blocTest<PopularMoviesBloc, MovieState>(
    'Should emit [Loading, Error] when get popular movies is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(PopularMovie()),
    expect: () =>
        [PopularMovieLoading(), const PopularMovieError('Server Failure')],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );
}
