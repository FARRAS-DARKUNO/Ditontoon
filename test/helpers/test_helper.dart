import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/db/database_helper_series.dart';
import 'package:ditonton/data/datasources/movies-data/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movies-data/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/series/series_local_data_source.dart';
import 'package:ditonton/data/datasources/series/series_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/series_repository.dart';
import 'package:ditonton/domain/usecases/movies-usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies-usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movies-usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movies-usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movies-usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movies-usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movies-usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movies-usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movies-usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/movies-usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/series/get_now_playing_series.dart';
import 'package:ditonton/domain/usecases/series/get_popular_series.dart';
import 'package:ditonton/domain/usecases/series/get_series_detail.dart';
import 'package:ditonton/domain/usecases/series/get_series_recommendations.dart';
import 'package:ditonton/domain/usecases/series/get_top_rated_series.dart';
import 'package:ditonton/domain/usecases/series/get_watchlist_series.dart';
import 'package:ditonton/domain/usecases/series/get_watchlist_series_status.dart';
import 'package:ditonton/domain/usecases/series/remove_watchlist_series.dart';
import 'package:ditonton/domain/usecases/series/save_watchlist_series.dart';
import 'package:ditonton/domain/usecases/series/search_series.dart';
import 'package:ditonton/presentation/bloc/convert_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetMovieRecommendations,
  GetMovieDetail,
  GetWatchlistMovies,
  GetWatchListStatus,
  RemoveWatchlist,
  SaveWatchlist,
  SearchMovies,
  SeriesRepository,
  SeriesRemoteDataSource,
  SeriesLocalDataSource,
  DatabaseHelperSeries,
  GetNowPlayingSeries,
  GetPopularSeries,
  GetTopRatedSeries,
  GetSeriesRecommendations,
  GetSeriesDetail,
  GetWatchlistSeries,
  GetWatchlistSeriesStatus,
  RemoveWatchlistSeries,
  SaveWatchlistSeries,
  SearchSeries,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}

class FakeMovieSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class FakeMovieSearchEvent extends Fake implements SearchEvent {}

class FakeMovieSearchState extends Fake implements SearchState {}

class FakeNowPlayingMovieBloc extends MockBloc<MovieEvent, MovieState>
    implements NowPlayingMoviesBloc {}

class FakeNowPlayingMovieEvent extends Fake implements MovieEvent {}

class FakeNowPlayingMovieState extends Fake implements MovieState {}

class FakePopularMovieBloc extends MockBloc<MovieEvent, MovieState>
    implements PopularMoviesBloc {}

class FakePopularMovieEvent extends Fake implements MovieEvent {}

class FakePopularMovieState extends Fake implements MovieState {}

class FakeTopRatedMovieBloc extends MockBloc<MovieEvent, MovieState>
    implements TopRatedMoviesBloc {}

class FakeTopRatedMovieEvent extends Fake implements MovieEvent {}

class FakeTopRatedMovieState extends Fake implements MovieState {}

class FakeMovieDetailBloc extends MockBloc<MovieEvent, MovieState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieEvent {}

class FakeMovieDetailState extends Fake implements MovieState {}

class FakeMovieWatchlistBloc extends MockBloc<MovieEvent, MovieWatchlistState>
    implements MovieWatchlistBloc {}

class FakeMovieWatchlistEvent extends Fake implements MovieEvent {}

class FakeMovieWatchlistState extends Fake implements MovieWatchlistState {}

class FakeMovieRecommendationBloc extends MockBloc<MovieEvent, MovieState>
    implements MovieRecommendationsBloc {}

class FakeMovieRecommendationEvent extends Fake implements MovieEvent {}

class FakeMovieRecommendationState extends Fake implements MovieState {}

class FakeSeriesSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SeriesSearchBloc {}

class FakeSeriesSearchEvent extends Fake implements SearchEvent {}

class FakeSeriesSearchState extends Fake implements SearchState {}

class FakeNowPlayingSeriesBloc extends MockBloc<SeriesEvent, SeriesState>
    implements NowPlayingSeriesBloc {}

class FakeNowPlayingSeriesEvent extends Fake implements SeriesEvent {}

class FakeNowPlayingSeriesState extends Fake implements SeriesState {}

class FakePopularSeriesBloc extends MockBloc<SeriesEvent, SeriesState>
    implements PopularSeriesBloc {}

class FakePopularSeriesEvent extends Fake implements SeriesEvent {}

class FakePopularSeriesState extends Fake implements SeriesState {}

class FakeTopRatedSeriesBloc extends MockBloc<SeriesEvent, SeriesState>
    implements TopRatedSeriesBloc {}

class FakeTopRatedSeriesEvent extends Fake implements SeriesEvent {}

class FakeTopRatedSeriesState extends Fake implements SeriesState {}

class FakeSeriesDetailBloc extends MockBloc<SeriesEvent, SeriesState>
    implements SeriesDetailBloc {}

class FakeSeriesDetailEvent extends Fake implements SeriesEvent {}

class FakeSeriesDetailState extends Fake implements SeriesState {}

class FakeSeriesWatchlistBloc
    extends MockBloc<SeriesEvent, SeriesWatchlistState>
    implements SeriesWatchlistBloc {}

class FakeSeriesWatchlistEvent extends Fake implements SeriesEvent {}

class FakeSeriesWatchlistState extends Fake implements SeriesState {}

class FakeSeriesRecommendationBloc extends MockBloc<SeriesEvent, SeriesState>
    implements SeriesRecommendationsBloc {}

class FakeSeriesRecommendationEvent extends Fake implements SeriesEvent {}

class FakeSeriesRecommendationState extends Fake implements SeriesState {}
