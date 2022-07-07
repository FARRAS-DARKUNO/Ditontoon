import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/series/series_detail.dart';
import 'package:equatable/equatable.dart';

class SeriesDetailResponse extends Equatable {
  const SeriesDetailResponse({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.firstAirDate,
    required this.lastAirDate,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
  });

  final String backdropPath;
  final List<GenreModel> genres;
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final int voteCount;
  final String firstAirDate;
  final String lastAirDate;
  final int numberOfSeasons;
  final int numberOfEpisodes;

  factory SeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeriesDetailResponse(
        backdropPath: json["backdrop_path"] ?? 'none',
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        firstAirDate: json['first_air_date'],
        lastAirDate: json['last_air_date'],
        numberOfSeasons: json['number_of_seasons'],
        numberOfEpisodes: json['number_of_episodes'],
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "first_air_date": firstAirDate,
        "last_air_date": lastAirDate,
        "number_of_seasons": numberOfSeasons,
        "number_of_episodes": numberOfEpisodes,
      };

  SeriesDetail toEntity() {
    return SeriesDetail(
      backdropPath: backdropPath,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      firstAirDate: firstAirDate,
      lastAirDate: lastAirDate,
      numberOfSeasons: numberOfSeasons,
      numberOfEpisodes: numberOfEpisodes,
    );
  }

  @override
  List<Object?> get props => [
        backdropPath,
        genres,
        id,
        name,
        overview,
        posterPath,
        voteAverage,
        voteCount,
        firstAirDate,
        lastAirDate,
        numberOfSeasons,
        numberOfEpisodes,
      ];
}
