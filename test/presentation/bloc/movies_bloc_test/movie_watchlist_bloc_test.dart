import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movies-dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieWatchlistBloc = MovieWatchlistBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchListStatus: mockGetWatchListStatus,
      removeWatchlist: mockRemoveWatchlist,
      saveWatchlist: mockSaveWatchlist,
    );
  });

  test('initial state should be empty ', () {
    expect(movieWatchlistBloc.state, MovieWatchlistEmpty());
  });

  group('Movie Watchlist Test', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [Loading, HasData] when movie watchlist data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlist()),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistHasData([testWatchlistMovie]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
        return MovieWatchlist().props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [Loading, Error] when get movie watchlist is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlist()),
      expect: () => <MovieWatchlistState>[
        MovieWatchlistLoading(),
        const MovieWatchlistError('Server Failure'),
      ],
      verify: (bloc) => MovieWatchlistLoading(),
    );
  });

  group('Movie Watchlist Status Test', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should return true when movie watchlist status is true',
      build: () {
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(WatchlistStatus(testMovieDetail.id)),
      expect: () =>
          [MovieWatchlistLoading(), const MovieWatchlistHasStatus(true)],
      verify: (bloc) {
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        return WatchlistStatus(testMovieDetail.id).props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        'Should return false when movie watchlist status is false',
        build: () {
          when(mockGetWatchListStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);
          return movieWatchlistBloc;
        },
        act: (bloc) => bloc.add(WatchlistStatus(testMovieDetail.id)),
        expect: () => <MovieWatchlistState>[
              MovieWatchlistLoading(),
              const MovieWatchlistHasStatus(false),
            ],
        verify: (bloc) {
          verify(mockGetWatchListStatus.execute(testMovieDetail.id));
          return WatchlistStatus(testMovieDetail.id).props;
        });
  });

  group('Add Movie Watchlist Test', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should update watchlist status when movie watchlist is successfully added',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      expect: () => [
        const MovieWatchlistHasMessage('Added to Watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        return AddWatchlist(testMovieDetail).props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should return error message when movie watchlist is unsuccessfully added',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      expect: () => [
        const MovieWatchlistError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        return AddWatchlist(testMovieDetail).props;
      },
    );
  });

  group('Remove Movie Watchlist Test', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should update watchlist status when movie watchlist is successfully removed',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        const MovieWatchlistHasMessage('Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        return RemoveFromWatchlist(testMovieDetail).props;
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should return error message when movie watchlist is unsuccessfully removed',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => Left(DatabaseFailure('can\'t add data to watchlist')));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        const MovieWatchlistError('can\'t add data to watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        return RemoveFromWatchlist(testMovieDetail).props;
      },
    );
  });
}
