import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:ditonton/presentation/pages/series/home_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late FakeNowPlayingSeriesBloc fakeNowPlayingSeriesBloc;
  late FakePopularSeriesBloc fakePopularSeriesBloc;
  late FakeTopRatedSeriesBloc fakeTopRatedSeriesBloc;

  setUp(() {
    fakeNowPlayingSeriesBloc = FakeNowPlayingSeriesBloc();
    registerFallbackValue(FakeNowPlayingSeriesEvent());
    registerFallbackValue(FakeNowPlayingSeriesState());
    fakePopularSeriesBloc = FakePopularSeriesBloc();
    registerFallbackValue(FakePopularSeriesEvent());
    registerFallbackValue(FakePopularSeriesState());
    fakeTopRatedSeriesBloc = FakeTopRatedSeriesBloc();
    registerFallbackValue(FakeTopRatedSeriesEvent());
    registerFallbackValue(FakeTopRatedSeriesState());
  });

  tearDown(() {
    fakeNowPlayingSeriesBloc.close();
    fakePopularSeriesBloc.close();
    fakeTopRatedSeriesBloc.close();
  });

  Widget _createTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingSeriesBloc>(
          create: (context) => fakeNowPlayingSeriesBloc,
        ),
        BlocProvider<PopularSeriesBloc>(
          create: (context) => fakePopularSeriesBloc,
        ),
        BlocProvider<TopRatedSeriesBloc>(
          create: (context) => fakeTopRatedSeriesBloc,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets(
    'Page should showing ListView of NowPlayingSeries, PopularSeries, and TopRatedSeries when state is HasData',
    (WidgetTester tester) async {
      when(() => fakeNowPlayingSeriesBloc.state)
          .thenReturn(NowPlayingSeriesHasData(testSeriesList));
      when(() => fakePopularSeriesBloc.state)
          .thenReturn(PopularSeriesHasData(testSeriesList));
      when(() => fakeTopRatedSeriesBloc.state)
          .thenReturn(TopRatedSeriesHasData(testSeriesList));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_createTestableWidget(HomeSeriesPage()));

      expect(listViewFinder, findsWidgets);
    },
  );
}
