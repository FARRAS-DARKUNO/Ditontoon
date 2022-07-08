import 'package:ditonton/domain/entities/movies-entities/movie.dart';
import 'package:ditonton/presentation/bloc/convert_search_bloc.dart';
import 'package:ditonton/presentation/pages/movie_page/search_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_helper.dart';

void main() {
  late FakeMovieSearchBloc fakeMovieSearchBloc;

  setUp(() {
    fakeMovieSearchBloc = FakeMovieSearchBloc();
    registerFallbackValue(FakeMovieSearchEvent());
    registerFallbackValue(FakeMovieSearchState());
  });

  tearDown(() {
    fakeMovieSearchBloc.close();
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieList = [tMovie];

  Widget _createTestableWidget(Widget body) {
    return BlocProvider<SearchBloc>(
      create: (_) => fakeMovieSearchBloc,
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
      when(() => fakeMovieSearchBloc.state).thenReturn(SearchLoading());

      final circularProgressIndicatorFinder =
          find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_createTestableWidget(SearchPage()));
      await tester.pump();

      expect(circularProgressIndicatorFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should showing AppBar, ListView, MovieCard, and MovieSearchPage when data is gotten successfully',
    (WidgetTester tester) async {
      when(() => fakeMovieSearchBloc.state)
          .thenReturn(SearchHasData(tMovieList));

      await tester.pumpWidget(_createTestableWidget(SearchPage()));
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MovieCard), findsOneWidget);
      expect(find.byKey(const Key('MovieSearchPage')), findsOneWidget);
    },
  );

  testWidgets(
    'Should showing Error Message when error',
    (WidgetTester tester) async {
      const errorMessage = 'error message';

      when(() => fakeMovieSearchBloc.state)
          .thenReturn(SearchError(errorMessage));

      final textMessageKeyFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_createTestableWidget(SearchPage()));
      await tester.pump();

      expect(textMessageKeyFinder, findsOneWidget);
    },
  );
}
