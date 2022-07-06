import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper_series.dart';
import 'package:ditonton/data/models/series/series_table.dart';

abstract class SeriesLocalDataSource {
  Future<String> insertWatchListSeries(SeriesTable series);
  Future<String> removeWatchListSeries(SeriesTable series);
  Future<SeriesTable?> getSeriesById(int id);
  Future<List<SeriesTable>> getWatchListSeries();
}

class SeriesLocalDataSourceImpl implements SeriesLocalDataSource {
  final DatabaseHelperSeries databaseHelperSeries;

  SeriesLocalDataSourceImpl({required this.databaseHelperSeries});

  @override
  Future<String> insertWatchListSeries(SeriesTable series) async {
    try {
      await databaseHelperSeries.insertWatchlistSeries(series);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchListSeries(SeriesTable series) async {
    try {
      await databaseHelperSeries.removeWatchlistSeries(series);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<SeriesTable?> getSeriesById(int id) async {
    final result = await databaseHelperSeries.getSeriesById(id);
    if (result != null) {
      return SeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<SeriesTable>> getWatchListSeries() async {
    final result = await databaseHelperSeries.getWatchlistSeries();
    return result.map((e) => SeriesTable.fromMap(e)).toList();
  }
}
