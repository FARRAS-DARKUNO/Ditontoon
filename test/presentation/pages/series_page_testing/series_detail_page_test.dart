import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:ditonton/presentation/pages/series/series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late FakeSeriesDetailBloc fakeSeriesDetailBloc;
  late FakeSeriesWatchlistBloc fakeSeriesWatchlistBloc;
  late FakeSeriesRecommendationBloc fakeSeriesRecommendationBloc;

  setUp(() {
    fakeSeriesDetailBloc = FakeSeriesDetailBloc();
    registerFallbackValue(FakeSeriesDetailEvent());
    registerFallbackValue(FakeSeriesDetailState());
    fakeSeriesWatchlistBloc = FakeSeriesWatchlistBloc();
    registerFallbackValue(FakeSeriesWatchlistEvent());
    registerFallbackValue(FakeSeriesWatchlistState());
    fakeSeriesRecommendationBloc = FakeSeriesRecommendationBloc();
    registerFallbackValue(FakeSeriesRecommendationEvent());
    registerFallbackValue(FakeSeriesRecommendationState());
  });

  tearDown(() {
    fakeSeriesDetailBloc.close();
    fakeSeriesWatchlistBloc.close();
    fakeSeriesRecommendationBloc.close();
  });

  Widget _createTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SeriesDetailBloc>(
          create: (context) => fakeSeriesDetailBloc,
        ),
        BlocProvider<SeriesWatchlistBloc>(
          create: (context) => fakeSeriesWatchlistBloc,
        ),
        BlocProvider<SeriesRecommendationsBloc>(
          create: (context) => fakeSeriesRecommendationBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tId = 1;

  testWidgets(
    'Should showing Circular Progress Indicator when data is loading',
    (WidgetTester tester) async {
      when(() => fakeSeriesDetailBloc.state).thenReturn(SeriesDetailLoading());
      when(() => fakeSeriesWatchlistBloc.state)
          .thenReturn(SeriesWatchlistLoading());
      when(() => fakeSeriesRecommendationBloc.state)
          .thenReturn(SeriesRecommendationLoading());

      final circularProgressIndicatorFinder =
          find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_createTestableWidget(SeriesDetailPage(
        id: tId,
      )));
      await tester.pump();

      expect(circularProgressIndicatorFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should showing Watchlist, Overview, Recommendations, and DetailContent when data is gotten successfully',
    (WidgetTester tester) async {
      when(() => fakeSeriesDetailBloc.state)
          .thenReturn(SeriesDetailHasData(testSeriesDetail));
      when(() => fakeSeriesRecommendationBloc.state)
          .thenReturn(SeriesRecommendationHasData(testSeriesList));
      when(() => fakeSeriesWatchlistBloc.state)
          .thenReturn(SeriesWatchlistHasData(testSeriesList));

      await tester.pumpWidget(_createTestableWidget(SeriesDetailPage(id: tId)));
      await tester.pump();

      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Recommendations'), findsOneWidget);
      expect(find.byKey(const Key('SeriesDetailContent')), findsOneWidget);
    },
  );
}
