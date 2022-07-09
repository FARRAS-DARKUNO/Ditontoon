import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movies-entities/movie.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedMoviesBloc topRatedMoviesBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  test("initial state should be empty", () {
    expect(topRatedMoviesBloc.state, TopRatedMovieEmpty());
  });

  final tMovieList = <Movie>[];

  blocTest<TopRatedMoviesBloc, MovieState>(
    'Should emit [Loading, HasData] when top rated movies data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(TopRatedMovie()),
    expect: () => [TopRatedMovieLoading(), TopRatedMovieHasData(tMovieList)],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMoviesBloc, MovieState>(
    'Should emit [Loading, Error] when get top rated movies is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(TopRatedMovie()),
    expect: () =>
        [TopRatedMovieLoading(), const TopRatedMovieError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
