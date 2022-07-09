import 'package:ditonton/presentation/bloc/series/series_bloc.dart';
import 'package:ditonton/presentation/pages/series/top_rated_series_page.dart';
import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/series/series_dummy_objects.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late FakeTopRatedSeriesBloc fakeTopRatedSeriesBloc;

  setUp(() {
    fakeTopRatedSeriesBloc = FakeTopRatedSeriesBloc();
    registerFallbackValue(FakeTopRatedSeriesEvent());
    registerFallbackValue(FakeTopRatedSeriesState());
  });

  tearDown(() {
    fakeTopRatedSeriesBloc.close();
  });

  Widget _createTestableWidget(Widget body) {
    return BlocProvider<TopRatedSeriesBloc>(
      create: (_) => fakeTopRatedSeriesBloc,
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
      when(() => fakeTopRatedSeriesBloc.state)
          .thenReturn(TopRatedSeriesLoading());

      final circularProgressIndicatorFinder =
          find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_createTestableWidget(TopRatedSeriesPage()));
      await tester.pump();

      expect(circularProgressIndicatorFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should display AppBar, ListView, SeriesCard, and TopRatedSeriesPage when data is gotten successfully',
    (WidgetTester tester) async {
      when(() => fakeTopRatedSeriesBloc.state)
          .thenReturn(TopRatedSeriesHasData(testSeriesList));
      await tester.pumpWidget(_createTestableWidget(TopRatedSeriesPage()));
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(SeriesCard), findsOneWidget);
      expect(find.byKey(const Key('TopRatedSeriesPage')), findsOneWidget);
    },
  );
}
