import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie_page/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movies-dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late FakeMovieDetailBloc fakeDetailMovieBloc;
  late FakeMovieWatchlistBloc fakeWatchlistMovieBloc;
  late FakeMovieRecommendationBloc fakeRecommendationMovieBloc;

  setUp(() {
    fakeDetailMovieBloc = FakeMovieDetailBloc();
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
    fakeWatchlistMovieBloc = FakeMovieWatchlistBloc();
    registerFallbackValue(FakeMovieWatchlistEvent());
    registerFallbackValue(FakeMovieWatchlistState());
    fakeRecommendationMovieBloc = FakeMovieRecommendationBloc();
    registerFallbackValue(FakeMovieRecommendationEvent());
    registerFallbackValue(FakeMovieRecommendationState());
  });

  tearDown(() {
    fakeDetailMovieBloc.close();
    fakeRecommendationMovieBloc.close();
    fakeWatchlistMovieBloc.close();
  });

  Widget _createTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (context) => fakeDetailMovieBloc,
        ),
        BlocProvider<MovieWatchlistBloc>(
          create: (context) => fakeWatchlistMovieBloc,
        ),
        BlocProvider<MovieRecommendationsBloc>(
          create: (context) => fakeRecommendationMovieBloc,
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
      when(() => fakeDetailMovieBloc.state).thenReturn(MovieDetailLoading());
      when(() => fakeWatchlistMovieBloc.state)
          .thenReturn(MovieWatchlistLoading());
      when(() => fakeRecommendationMovieBloc.state)
          .thenReturn(MovieRecommendationLoading());

      final circularProgressIndicatorFinder =
          find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_createTestableWidget(MovieDetailPage(
        id: tId,
      )));
      await tester.pump();

      expect(circularProgressIndicatorFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should showing Watchlist, Overview, Recommendations, and DetailContent when data is gotten successfully',
    (WidgetTester tester) async {
      when(() => fakeDetailMovieBloc.state)
          .thenReturn(MovieDetailHasData(testMovieDetail));
      when(() => fakeWatchlistMovieBloc.state)
          .thenReturn(MovieWatchlistHasData(testMovieList));
      when(() => fakeRecommendationMovieBloc.state)
          .thenReturn(MovieRecommendationHasData(testMovieList));

      await tester.pumpWidget(_createTestableWidget(MovieDetailPage(id: tId)));
      await tester.pump();

      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Recommendations'), findsOneWidget);
      expect(find.byKey(const Key('DetailContent')), findsOneWidget);
    },
  );
}
