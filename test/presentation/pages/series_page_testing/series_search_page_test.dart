import 'package:ditonton/domain/entities/series/series.dart';
import 'package:ditonton/presentation/bloc/convert_search/convert_search_bloc.dart';
import 'package:ditonton/presentation/pages/series/series_search_page.dart';
import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_helper.dart';

void main() {
  late FakeSeriesSearchBloc fakeSeriesSearchBloc;

  setUp(() {
    fakeSeriesSearchBloc = FakeSeriesSearchBloc();
    registerFallbackValue(FakeSeriesSearchEvent());
    registerFallbackValue(FakeSeriesSearchState());
  });

  tearDown(() {
    fakeSeriesSearchBloc.close();
  });

  final tSeries = Series(
    backdropPath: '/suopoADq0k8YZr4dQXcU6pToj6s.jpg',
    genreIds: [10765, 18, 10759, 9648],
    id: 1399,
    name: 'Dragon Kingdom',
    overview: "Empire attack NTAPS",
    popularity: 369.594,
    posterPath: '/u3bZgncwwcwcsWNhyveQzciwuidwchiw.jpg',
    voteAverage: 8.3,
    voteCount: 11504,
  );

  final tSeriesList = [tSeries];

  Widget _createTestableWidget(Widget body) {
    return BlocProvider<SeriesSearchBloc>(
      create: (_) => fakeSeriesSearchBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('Should showing Circular Progress Indicator when data is loading',
      (WidgetTester tester) async {
    when(() => fakeSeriesSearchBloc.state).thenReturn(SearchLoading());

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_createTestableWidget(SeriesSearchPage()));
    await tester.pump();

    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets(
      'Should showing AppBar, ListView, SeriesCard, and Series Search Page when data is gotten successfully',
      (WidgetTester tester) async {
    when(() => fakeSeriesSearchBloc.state)
        .thenReturn(SeriesSearchHasData(tSeriesList));
    await tester.pumpWidget(_createTestableWidget(SeriesSearchPage()));
    await tester.pump();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(SeriesCard), findsOneWidget);
    expect(find.byKey(const Key('Series Search Page')), findsOneWidget);
  });

  testWidgets('Should showing Error Message when error',
      (WidgetTester tester) async {
    const errorMessage = 'error message';

    when(() => fakeSeriesSearchBloc.state)
        .thenReturn(SearchError(errorMessage));

    final textMessageKeyFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(_createTestableWidget(SeriesSearchPage()));
    await tester.pump();

    expect(textMessageKeyFinder, findsOneWidget);
  });
}
