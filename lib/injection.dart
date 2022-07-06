import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/db/database_helper_series.dart';
import 'package:ditonton/data/datasources/movies-data/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movies-data/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/series/series_local_data_source.dart';
import 'package:ditonton/data/datasources/series/series_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/series_repository_impl.dart';
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
import 'package:ditonton/presentation/provider/moovies-provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/moovies-provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/moovies-provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/moovies-provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/moovies-provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/moovies-provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/series/popular_series_notifier.dart';
import 'package:ditonton/presentation/provider/series/series_detail_notifier.dart';
import 'package:ditonton/presentation/provider/series/series_list_notifier.dart';
import 'package:ditonton/presentation/provider/series/series_search_notifier.dart';
import 'package:ditonton/presentation/provider/series/top_rated_series_notifier.dart';
import 'package:ditonton/presentation/provider/series/watchlist_series_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // movies provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  // movies use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // movies repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // movies data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // movies helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // tv series provider
  locator.registerFactory(
    () => SeriesListNotifier(
      getNowPlayingSeries: locator(),
      getPopularSeries: locator(),
      getTopRatedSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesDetailNotifier(
      getSeriesDetail: locator(),
      getSeriesRecommendations: locator(),
      getWatchlistSeriesStatus: locator(),
      saveWatchlistSeries: locator(),
      removeWatchlistSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularSeriesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedSeriesNotifier(
      getTopRatedSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesSearchNotifier(
      searchSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistSeriesNotifier(
      getWatchlistSeries: locator(),
    ),
  );

  //tv series use case
  locator.registerLazySingleton(() => GetNowPlayingSeries(locator()));
  locator.registerLazySingleton(() => GetPopularSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedSeries(locator()));
  locator.registerLazySingleton(() => GetSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistSeriesStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistSeries(locator()));

  //tv series repository
  locator.registerLazySingleton<SeriesRepository>(
    () => SeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // tv series data sources
  locator.registerLazySingleton<SeriesRemoteDataSource>(
      () => SeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<SeriesLocalDataSource>(
      () => SeriesLocalDataSourceImpl(databaseHelperSeries: locator()));

  //tv series helper
  locator.registerLazySingleton<DatabaseHelperSeries>(
      () => DatabaseHelperSeries());

  // external
  locator.registerLazySingleton(() => http.Client());
}
