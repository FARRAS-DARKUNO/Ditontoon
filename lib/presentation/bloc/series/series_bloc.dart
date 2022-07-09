import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/domain/entities/series/series_detail.dart';
import 'package:ditonton/domain/usecases/series/get_now_playing_series.dart';
import 'package:ditonton/domain/usecases/series/get_popular_series.dart';
import 'package:ditonton/domain/usecases/series/get_series_detail.dart';
import 'package:ditonton/domain/usecases/series/get_series_recommendations.dart';
import 'package:ditonton/domain/usecases/series/get_top_rated_series.dart';
import 'package:ditonton/domain/usecases/series/get_watchlist_series.dart';
import 'package:ditonton/domain/usecases/series/get_watchlist_series_status.dart';
import 'package:ditonton/domain/usecases/series/remove_watchlist_series.dart';
import 'package:ditonton/domain/usecases/series/save_watchlist_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'series_event.dart';
part 'series_state.dart';

class NowPlayingSeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetNowPlayingSeries _getNowPlayingSeries;

  NowPlayingSeriesBloc(this._getNowPlayingSeries)
      : super(NowPlayingSeriesEmpty()) {
    on<NowPlayingSeries>((event, emit) async {
      emit(NowPlayingSeriesLoading());
      final result = await _getNowPlayingSeries.execute();

      result.fold(
        (failure) {
          emit(NowPlayingSeriesError(failure.message));
        },
        (result) {
          emit(NowPlayingSeriesHasData(result));
        },
      );
    });
  }
}

class PopularSeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetPopularSeries _getPopularSeries;

  PopularSeriesBloc(this._getPopularSeries) : super(PopularSeriesEmpty()) {
    on<PopularSeries>((event, emit) async {
      emit(PopularSeriesLoading());
      final result = await _getPopularSeries.execute();

      result.fold(
        (failure) {
          emit(PopularSeriesError(failure.message));
        },
        (result) {
          emit(PopularSeriesHasData(result));
        },
      );
    });
  }
}

class SeriesDetailBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetSeriesDetail _getSeriesDetail;

  SeriesDetailBloc(this._getSeriesDetail) : super(SeriesDetailEmpty()) {
    on<DetailSeries>((event, emit) async {
      final id = event.id;

      emit(SeriesDetailLoading());
      final result = await _getSeriesDetail.execute(id);

      result.fold(
        (failure) {
          emit(SeriesDetailError(failure.message));
        },
        (result) {
          emit(SeriesDetailHasData(result));
        },
      );
    });
  }
}

class SeriesRecommendationsBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetSeriesRecommendations _getSeriesRecommendations;

  SeriesRecommendationsBloc(this._getSeriesRecommendations)
      : super(SeriesRecommendationEmpty()) {
    on<SeriesRecommendation>((event, emit) async {
      final id = event.id;

      emit(SeriesRecommendationLoading());

      final result = await _getSeriesRecommendations.execute(id);

      result.fold((failure) {
        emit(SeriesRecommendationError(failure.message));
      }, (data) {
        emit(SeriesRecommendationHasData(data));
      });
    });
  }
}

class TopRatedSeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetTopRatedSeries _getTopRatedSeries;

  TopRatedSeriesBloc(this._getTopRatedSeries) : super(TopRatedSeriesEmpty()) {
    on<TopRatedSeries>((event, emit) async {
      emit(TopRatedSeriesLoading());
      final result = await _getTopRatedSeries.execute();

      result.fold(
        (failure) {
          emit(TopRatedSeriesError(failure.message));
        },
        (result) {
          emit(TopRatedSeriesHasData(result));
        },
      );
    });
  }
}

class SeriesWatchlistBloc extends Bloc<SeriesEvent, SeriesWatchlistState> {
  final GetWatchlistSeries getWatchlistSeries;
  final GetWatchlistSeriesStatus getWatchlistSeriesStatus;
  final SaveWatchlistSeries saveWatchlistSeries;
  final RemoveWatchlistSeries removeWatchlistSeries;

  SeriesWatchlistBloc({
    required this.getWatchlistSeries,
    required this.getWatchlistSeriesStatus,
    required this.saveWatchlistSeries,
    required this.removeWatchlistSeries,
  }) : super(SeriesWatchlistEmpty()) {
    on<SeriesWatchlist>((event, emit) async {
      emit(SeriesWatchlistLoading());

      final result = await getWatchlistSeries.execute();

      result.fold(
        (failure) {
          emit(SeriesWatchlistError(failure.message));
        },
        (data) {
          emit(SeriesWatchlistHasData(data));
        },
      );
    });

    on<SeriesWatchlistStatus>((event, emit) async {
      emit(SeriesWatchlistLoading());
      final result = await getWatchlistSeriesStatus.execute(event.id);

      emit(SeriesWatchlistHasStatus(result));
    });

    on<AddWatchlistSeries>((event, emit) async {
      final series = event.seriesDetail;
      final result = await saveWatchlistSeries.execute(series);

      result.fold((failure) {
        emit(SeriesWatchlistError(failure.message));
      }, (message) {
        emit(SeriesWatchlistHasMessage(message));
      });
    });

    on<RemoveFromWatchlistSeries>((event, emit) async {
      final series = event.seriesDetail;
      final result = await removeWatchlistSeries.execute(series);

      result.fold((failure) {
        emit(SeriesWatchlistError(failure.message));
      }, (message) {
        emit(SeriesWatchlistHasMessage(message));
      });
    });
  }
}
