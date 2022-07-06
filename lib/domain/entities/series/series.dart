import 'package:equatable/equatable.dart';

class Series extends Equatable {
  String? backdropPath;
  List<int>? genreIds;
  int id;
  String? name;
  String? overview;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;

  Series({
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  Series.watchlist({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  @override
  List<Object?> get props => [
        backdropPath,
        genreIds,
        id,
        name,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount
      ];
}
