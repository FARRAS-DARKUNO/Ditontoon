import 'package:ditonton/presentation/bloc/movies/movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie_page/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movies-dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late FakeNowPlayingMovieBloc fakeNowPlayingMovieBloc;
  late FakePopularMovieBloc fakePopularMovieBloc;
  late FakeTopRatedMovieBloc fakeTopRatedMovieBloc;

  setUp(() {
    fakeNowPlayingMovieBloc = FakeNowPlayingMovieBloc();
    registerFallbackValue(FakeNowPlayingMovieEvent());
    registerFallbackValue(FakeNowPlayingMovieState());
    fakePopularMovieBloc = FakePopularMovieBloc();
    registerFallbackValue(FakePopularMovieEvent());
    registerFallbackValue(FakePopularMovieState());
    fakeTopRatedMovieBloc = FakeTopRatedMovieBloc();
    registerFallbackValue(FakeTopRatedMovieEvent());
    registerFallbackValue(FakeTopRatedMovieState());
  });

  tearDown(() {
    fakeNowPlayingMovieBloc.close();
    fakePopularMovieBloc.close();
    fakeTopRatedMovieBloc.close();
  });

  Widget _createTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMoviesBloc>(
          create: (context) => fakeNowPlayingMovieBloc,
        ),
        BlocProvider<PopularMoviesBloc>(
          create: (context) => fakePopularMovieBloc,
        ),
        BlocProvider<TopRatedMoviesBloc>(
          create: (context) => fakeTopRatedMovieBloc,
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
    'Page should showing ListView of NowPlayingMovies, PopularMovies, and TopRatedMovies when state is HasData',
    (WidgetTester tester) async {
      when(() => fakeNowPlayingMovieBloc.state)
          .thenReturn(NowPlayingMovieHasData(testMovieList));
      when(() => fakePopularMovieBloc.state)
          .thenReturn(PopularMovieHasData(testMovieList));
      when(() => fakeTopRatedMovieBloc.state)
          .thenReturn(TopRatedMovieHasData(testMovieList));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_createTestableWidget(HomeMoviePage()));

      expect(listViewFinder, findsWidgets);
    },
  );
}
