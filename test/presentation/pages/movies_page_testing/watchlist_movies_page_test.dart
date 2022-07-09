import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie_page/watchlist_movies_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movies-dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late FakeMovieWatchlistBloc fakeMovieWatchlistBloc;

  setUp(() {
    fakeMovieWatchlistBloc = FakeMovieWatchlistBloc();
    registerFallbackValue(FakeMovieWatchlistEvent());
    registerFallbackValue(FakeMovieRecommendationState());
  });

  tearDown(() {
    fakeMovieWatchlistBloc.close();
  });

  Widget _createTestableWidget(Widget body) {
    return BlocProvider<MovieWatchlistBloc>(
      create: (_) => fakeMovieWatchlistBloc,
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
      when(() => fakeMovieWatchlistBloc.state)
          .thenReturn(MovieWatchlistLoading());

      final circularProgressIndicatorFinder =
          find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_createTestableWidget(WatchlistMoviesPage()));
      await tester.pump();

      expect(circularProgressIndicatorFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should showing AppBar, ListView, MovieCard, and WatchlistMoviesPage when data is gotten successfully',
    (WidgetTester tester) async {
      when(() => fakeMovieWatchlistBloc.state)
          .thenReturn(MovieWatchlistHasData(testMovieList));

      await tester.pumpWidget(_createTestableWidget(WatchlistMoviesPage()));
      await tester.pump();

      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MovieCard), findsOneWidget);
      expect(find.byKey(const Key('WatchlistMoviesPage')), findsOneWidget);
    },
  );

  testWidgets(
    'Should showing Error Message when error',
    (WidgetTester tester) async {
      const errorMessage = 'error message';

      when(() => fakeMovieWatchlistBloc.state)
          .thenReturn(const MovieWatchlistError(errorMessage));

      final textMessageKeyFinder = find.byKey(const Key('error_message'));
      await tester.pumpWidget(_createTestableWidget(WatchlistMoviesPage()));
      await tester.pump();

      expect(textMessageKeyFinder, findsOneWidget);
    },
  );
}
