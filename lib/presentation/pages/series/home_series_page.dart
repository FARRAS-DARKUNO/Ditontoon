import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page/about_page.dart';
import 'package:ditonton/presentation/pages/series/popular_series_page.dart';
import 'package:ditonton/presentation/pages/series/series_detail_page.dart';
import 'package:ditonton/presentation/pages/series/series_search_page.dart';
import 'package:ditonton/presentation/pages/series/top_rated_series_page.dart';
import 'package:ditonton/presentation/pages/series/watchlist_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/series';

  @override
  _HomeSeriesPageState createState() => _HomeSeriesPageState();
}

class _HomeSeriesPageState extends State<HomeSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<NowPlayingSeriesBloc>(context, listen: false).add(
        NowPlayingSeries(),
      );
      BlocProvider.of<PopularSeriesBloc>(context, listen: false).add(
        PopularSeries(),
      );
      BlocProvider.of<TopRatedSeriesBloc>(context, listen: false).add(
        TopRatedSeries(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.tv_sharp),
              title: Text('TV-Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistSeriesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SeriesSearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing TV Series',
                style: kHeading6,
              ),
              BlocBuilder<NowPlayingSeriesBloc, SeriesState>(
                  builder: (context, state) {
                if (state is NowPlayingSeriesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NowPlayingSeriesHasData) {
                  final result = state.resultNowPlayingSeries;
                  return SeriesList(result);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                  title: 'Popular TV Series',
                  onTap: () {
                    Navigator.pushNamed(context, PopularSeriesPage.ROUTE_NAME);
                  }),
              BlocBuilder<PopularSeriesBloc, SeriesState>(
                  builder: (context, state) {
                if (state is PopularSeriesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularSeriesHasData) {
                  final result = state.resultPopularSeries;
                  return SeriesList(result);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                  title: 'Top Rated TV Series',
                  onTap: () => {
                        Navigator.pushNamed(
                            context, TopRatedSeriesPage.ROUTE_NAME),
                      }),
              BlocBuilder<TopRatedSeriesBloc, SeriesState>(
                  builder: (context, state) {
                if (state is TopRatedSeriesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedSeriesHasData) {
                  final result = state.resultTopRatedSeries;
                  return SeriesList(result);
                } else {
                  return Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
          ),
        ),
      ],
    );
  }
}

class SeriesList extends StatelessWidget {
  final List<Series> tvSeries;

  SeriesList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final series = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SeriesDetailPage.ROUTE_NAME,
                  arguments: series.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${series.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
