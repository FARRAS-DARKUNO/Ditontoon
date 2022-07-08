import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie_page/popular_movies_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movies-dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late FakePopularMovieBloc fakePopularMovieBloc;

  setUp(() {
    fakePopularMovieBloc = FakePopularMovieBloc();
    registerFallbackValue(FakePopularMovieEvent());
    registerFallbackValue(FakePopularMovieState());
  });

  tearDown(() {
    fakePopularMovieBloc.close();
  });

  Widget _createTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>(
      create: (_) => fakePopularMovieBloc,
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
      when(() => fakePopularMovieBloc.state).thenReturn(PopularMovieLoading());

      final circularProgressIndicatorFinder =
          find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_createTestableWidget(PopularMoviesPage()));
      await tester.pump();

      expect(circularProgressIndicatorFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should showing AppBar, ListView, MovieCard, and PopularMoviesPage when data is gotten successfully',
    (WidgetTester tester) async {
      when(() => fakePopularMovieBloc.state)
          .thenReturn(PopularMovieHasData(testMovieList));
      await tester.pumpWidget(_createTestableWidget(PopularMoviesPage()));
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MovieCard), findsOneWidget);
      expect(find.byKey(const Key('PopularMoviesPage')), findsOneWidget);
    },
  );
}
