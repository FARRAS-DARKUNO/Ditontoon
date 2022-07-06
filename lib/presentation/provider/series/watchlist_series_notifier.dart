import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/domain/usecases/series/get_watchlist_series.dart';
import 'package:flutter/material.dart';

class WatchlistSeriesNotifier extends ChangeNotifier {
  var _watchlistSeries = <Series>[];
  List<Series> get watchlistSeries => _watchlistSeries;

  var _watchlistSeriesState = RequestState.Empty;
  RequestState get watchlistSeriesState => _watchlistSeriesState;

  String _message = '';
  String get message => _message;

  final GetWatchlistSeries getWatchlistSeries;

  WatchlistSeriesNotifier({required this.getWatchlistSeries});

  Future<void> fetchWatchlistSeries() async {
    _watchlistSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistSeries.execute();
    result.fold(
      (failure) {
        _watchlistSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesData) {
        _watchlistSeriesState = RequestState.Loaded;
        _watchlistSeries = seriesData;
        notifyListeners();
      },
    );
  }
}
