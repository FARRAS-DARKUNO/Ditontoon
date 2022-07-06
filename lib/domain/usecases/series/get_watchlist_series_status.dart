import 'package:ditonton/domain/repositories/series_repository.dart';

class GetWatchlistSeriesStatus {
  final SeriesRepository repository;

  GetWatchlistSeriesStatus(this.repository);

  Future<bool> execute(int id) {
    return repository.isAddedToWatchlistSeries(id);
  }
}
