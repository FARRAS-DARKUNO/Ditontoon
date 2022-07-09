import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movies';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MovieWatchlistBloc>().add(
            MovieWatchlist(),
          ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<MovieWatchlistBloc>().add(
          MovieWatchlist(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('WatchlistMoviesPage'),
      appBar: AppBar(
        title: Text('Movies Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
          builder: (context, state) {
            if (state is MovieWatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieWatchlistHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movie[index];
                  return MovieCard(movie);
                },
                itemCount: state.movie.length,
              );
            } else if (state is MovieWatchlistError) {
              return Text(
                state.message,
                key: const Key('error_message'),
              );
            } else {
              return Text('');
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
