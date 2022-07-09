import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-series';

  @override
  _PopularSeriesPageState createState() => _PopularSeriesPageState();
}

class _PopularSeriesPageState extends State<PopularSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularSeriesBloc>().add(
            PopularSeries(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('PopularSeriesPage'),
      appBar: AppBar(
        title: Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularSeriesBloc, SeriesState>(
          builder: (context, state) {
            if (state is PopularSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularSeriesHasData) {
              final result = state.resultPopularSeries;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = result[index];
                  return SeriesCard(series);
                },
                itemCount: result.length,
              );
            } else {
              return Text('Failed');
            }
          },
        ),
      ),
    );
  }
}
