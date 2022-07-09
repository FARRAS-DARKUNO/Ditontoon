import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:ditonton/presentation/pages/series/watchlist_series_page.dart';
import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late FakeSeriesWatchlistBloc fakeSeriesWatchlistBloc;

  setUp(() {
    fakeSeriesWatchlistBloc = FakeSeriesWatchlistBloc();
    registerFallbackValue(FakeSeriesWatchlistEvent());
    registerFallbackValue(FakeSeriesWatchlistState());
  });

  tearDown(() {
    fakeSeriesWatchlistBloc.close();
  });
  Widget _createTestableWidget(Widget body) {
    return BlocProvider<SeriesWatchlistBloc>(
      create: (_) => fakeSeriesWatchlistBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets(
    'Should showing Circular Progress Indicator when data is loading',
    (WidgetTester tester) async {
      when(() => fakeSeriesWatchlistBloc.state)
          .thenReturn(SeriesWatchlistLoading());

      final circularProgressIndicatorFinder =
          find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_createTestableWidget(WatchlistSeriesPage()));
      await tester.pump();

      expect(circularProgressIndicatorFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should showing AppBar, ListView, SeriesCard, and WatchlistSeriesPage when data is gotten successfully',
    (WidgetTester tester) async {
      when(() => fakeSeriesWatchlistBloc.state)
          .thenReturn(SeriesWatchlistHasData(testSeriesList));

      await tester.pumpWidget(_createTestableWidget(WatchlistSeriesPage()));
      await tester.pump();

      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(SeriesCard), findsOneWidget);
      expect(find.byKey(const Key('WatchlistSeriesPage')), findsOneWidget);
    },
  );

  testWidgets(
    'Should showing Error Message when error',
    (WidgetTester tester) async {
      const errorMessage = 'error message';

      when(() => fakeSeriesWatchlistBloc.state)
          .thenReturn(const SeriesWatchlistError(errorMessage));

      final textMessageKeyFinder = find.byKey(const Key('error_message'));
      await tester.pumpWidget(_createTestableWidget(WatchlistSeriesPage()));
      await tester.pump();

      expect(textMessageKeyFinder, findsOneWidget);
    },
  );
}
