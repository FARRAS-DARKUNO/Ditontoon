import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie_page/top_rated_movies_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movies-dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late FakeTopRatedMovieBloc fakeTopRatedMovieBloc;

  setUp(() {
    fakeTopRatedMovieBloc = FakeTopRatedMovieBloc();
    registerFallbackValue(FakeTopRatedMovieEvent());
    registerFallbackValue(FakeNowPlayingMovieState());
  });

  tearDown(() {
    fakeTopRatedMovieBloc.close();
  });

  Widget _createTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>(
      create: (_) => fakeTopRatedMovieBloc,
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
      when(() => fakeTopRatedMovieBloc.state)
          .thenReturn(TopRatedMovieLoading());

      final circularProgressIndicatorFinder =
          find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_createTestableWidget(TopRatedMoviesPage()));
      await tester.pump();

      expect(circularProgressIndicatorFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should display AppBar, ListView, MovieCard, and TopRatedMoviesPage when data is gotten successfully',
    (WidgetTester tester) async {
      when(() => fakeTopRatedMovieBloc.state)
          .thenReturn(TopRatedMovieHasData(testMovieList));

      await tester.pumpWidget(_createTestableWidget(TopRatedMoviesPage()));
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MovieCard), findsOneWidget);
      expect(find.byKey(const Key('TopRatedMoviesPage')), findsOneWidget);
    },
  );
}
