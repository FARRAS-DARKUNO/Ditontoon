import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/domain/entities/series/series_detail.dart';
import 'package:ditonton/domain/usecases/series/get_series_detail.dart';
import 'package:ditonton/domain/usecases/series/get_series_recommendations.dart';
import 'package:ditonton/domain/usecases/series/get_watchlist_series_status.dart';
import 'package:ditonton/domain/usecases/series/remove_watchlist_series.dart';
import 'package:ditonton/domain/usecases/series/save_watchlist_series.dart';
import 'package:flutter/material.dart';

class SeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetSeriesDetail getSeriesDetail;
  final GetSeriesRecommendations getSeriesRecommendations;
  final GetWatchlistSeriesStatus getWatchlistSeriesStatus;
  final SaveWatchlistSeries saveWatchlistSeries;
  final RemoveWatchlistSeries removeWatchlistSeries;

  SeriesDetailNotifier({
    required this.getSeriesDetail,
    required this.getSeriesRecommendations,
    required this.getWatchlistSeriesStatus,
    required this.saveWatchlistSeries,
    required this.removeWatchlistSeries,
  });

  late SeriesDetail _series;
  SeriesDetail get series => _series;

  RequestState _seriesState = RequestState.Empty;
  RequestState get seriesState => _seriesState;

  List<Series> _seriesRecommendations = [];
  List<Series> get seriesRecommendations => _seriesRecommendations;

  RequestState _seriesRecommendationState = RequestState.Empty;
  RequestState get seriesRecommendationState => _seriesRecommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlistSeries = false;
  bool get isAddedToSeriesWatchlist => _isAddedToWatchlistSeries;

  String _seriesWatchlistMessage = '';
  String get seriesWatchlistMessage => _seriesWatchlistMessage;

  Future<void> fetchSeriesDetail(int id) async {
    _seriesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getSeriesDetail.execute(id);
    final recommendationResult = await getSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _seriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (series) {
        _seriesRecommendationState = RequestState.Loading;
        _series = series;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _seriesRecommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvSeries) {
            _seriesRecommendationState = RequestState.Loaded;
            _seriesRecommendations = tvSeries;
          },
        );
        _seriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> addWatchlistSeries(SeriesDetail series) async {
    final result = await saveWatchlistSeries.execute(series);

    await result.fold(
      (failure) async {
        _seriesWatchlistMessage = failure.message;
      },
      (successMessage) async {
        _seriesWatchlistMessage = successMessage;
      },
    );

    await loadWatchlistSeriesStatus(series.id);
  }

  Future<void> loadWatchlistSeriesStatus(int id) async {
    final result = await getWatchlistSeriesStatus.execute(id);
    _isAddedToWatchlistSeries = result;
    notifyListeners();
  }

  Future<void> removeFromWatchlistSeries(SeriesDetail series) async {
    final result = await removeWatchlistSeries.execute(series);

    await result.fold(
      (failure) async {
        _seriesWatchlistMessage = failure.message;
      },
      (successMessage) async {
        _seriesWatchlistMessage = successMessage;
      },
    );

    await loadWatchlistSeriesStatus(series.id);
  }
}
