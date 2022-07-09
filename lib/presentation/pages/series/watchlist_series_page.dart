import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-series';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<SeriesWatchlistBloc>().add(
            SeriesWatchlist(),
          ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<SeriesWatchlistBloc>().add(
          SeriesWatchlist(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('WatchlistSeriesPage'),
      appBar: AppBar(
        title: Text('TV Series Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<SeriesWatchlistBloc, SeriesWatchlistState>(
          builder: (context, state) {
            if (state is SeriesWatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SeriesWatchlistHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = state.series[index];
                  return SeriesCard(series);
                },
                itemCount: state.series.length,
              );
            } else if (state is SeriesWatchlistError) {
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
