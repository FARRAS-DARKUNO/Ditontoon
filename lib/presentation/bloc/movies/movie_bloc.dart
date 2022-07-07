import 'package:ditonton/domain/entities/movies/movie.dart';
import 'package:ditonton/domain/entities/movies/movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movies/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movies/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class NowPlayingMoviesBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMoviesBloc(this._getNowPlayingMovies)
      : super(NowPlayingMovieEmpty()) {
    on<NowPlayingMovie>((event, emit) async {
      emit(NowPlayingMovieLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(NowPlayingMovieError(failure.message));
        },
        (result) {
          emit(NowPlayingMovieHasData(result));
        },
      );
    });
  }
}

class PopularMoviesBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMoviesBloc(this._getPopularMovies) : super(PopularMovieEmpty()) {
    on<PopularMovie>((event, emit) async {
      emit(PopularMovieLoading());
      final result = await _getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(PopularMovieError(failure.message));
        },
        (result) {
          emit(PopularMovieHasData(result));
        },
      );
    });
  }
}

class TopRatedMoviesBloc extends Bloc<MovieEvent, MovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesBloc(this._getTopRatedMovies) : super(TopRatedMovieEmpty()) {
    on<TopRatedMovie>((event, emit) async {
      emit(TopRatedMovieLoading());
      final result = await _getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(TopRatedMovieError(failure.message));
        },
        (result) {
          emit(TopRatedMovieHasData(result));
        },
      );
    });
  }
}

class MovieDetailBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovieDetail _getMovieDetail;

  MovieDetailBloc(this._getMovieDetail) : super(MovieDetailEmpty()) {
    on<DetailMovie>((event, emit) async {
      final id = event.id;

      emit(MovieDetailLoading());
      final result = await _getMovieDetail.execute(id);

      result.fold(
        (failure) {
          emit(MovieDetailError(failure.message));
        },
        (result) {
          emit(MovieDetailHasData(result));
        },
      );
    });
  }
}

class MovieRecommendationsBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationsBloc(this._getMovieRecommendations)
      : super(MovieRecommendationEmpty()) {
    on<MovieRecommendation>((event, emit) async {
      final id = event.id;

      emit(MovieRecommendationLoading());

      final result = await _getMovieRecommendations.execute(id);

      result.fold(
        (failure) {
          emit(MovieRecommendationError(failure.message));
        },
        (data) {
          emit(MovieRecommendationHasData(data));
        },
      );
    });
  }
}

class MovieWatchlistBloc extends Bloc<MovieEvent, MovieWatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatus getWatchListStatus;
  final RemoveWatchlist removeWatchlist;
  final SaveWatchlist saveWatchlist;

  MovieWatchlistBloc({
    required this.getWatchlistMovies,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieWatchlistEmpty()) {
    on<MovieWatchlist>((event, emit) async {
      emit(MovieWatchlistLoading());

      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) {
          emit(MovieWatchlistError(failure.message));
        },
        (data) {
          emit(MovieWatchlistHasData(data));
        },
      );
    });

    on<WatchlistStatus>((event, emit) async {
      emit(MovieWatchlistLoading());
      final result = await getWatchListStatus.execute(event.id);

      emit(MovieWatchlistHasStatus(result));
    });

    on<AddWatchlist>((event, emit) async {
      final movie = event.movieDetail;
      final result = await saveWatchlist.execute(movie);

      result.fold((failure) {
        emit(MovieWatchlistError(failure.message));
      }, (message) {
        emit(MovieWatchlistHasMessage(message));
      });
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final movie = event.movieDetail;
      final result = await removeWatchlist.execute(movie);

      result.fold((failure) {
        emit(MovieWatchlistError(failure.message));
      }, (message) {
        emit(MovieWatchlistHasMessage(message));
      });
    });
  }
}
