import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/domain/repositories/series_repository.dart';

class GetNowPlayingSeries {
  final SeriesRepository repository;

  GetNowPlayingSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getNowPlayingSeries();
  }
}
