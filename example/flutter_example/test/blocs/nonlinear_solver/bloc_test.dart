import 'package:bloc_test/bloc_test.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NonlinearBloc' bloc", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = NonlinearBloc(NonlinearType.singlePoint);

      expect(bloc.state, equals(const NonlinearNone()));
      expect(bloc.nonlinearType, equals(NonlinearType.singlePoint));
    });

    test('Making sure that there are 2 types of nonlinear equations', () {
      expect(NonlinearType.values.length, equals(2));
    });

    blocTest<NonlinearBloc, NonlinearState>(
      'Making sure that the bloc emits states',
      build: () => NonlinearBloc(NonlinearType.singlePoint),
      act: (bloc) => bloc.add(const NonlinearClean()),
      expect: () => const [NonlinearNone()],
      verify: (bloc) => bloc.state == const NonlinearNone(),
    );

    blocTest<NonlinearBloc, NonlinearState>(
      'Making sure that an exception is thrown if one (or more) input values '
      'are malformed strings',
      build: () => NonlinearBloc(NonlinearType.singlePoint),
      act: (bloc) => bloc.add(const SinglePointMethod(
        method: SinglePointMethods.newton,
        function: 'x - 2',
        initialGuess: '',
      )),
      expect: () => const [NonlinearError()],
      verify: (bloc) => bloc.state == const NonlinearError(),
    );

    blocTest<NonlinearBloc, NonlinearState>(
      'Making sure that nonlinear equations can be solved with Newton',
      build: () => NonlinearBloc(NonlinearType.singlePoint),
      act: (bloc) => bloc.add(const SinglePointMethod(
        method: SinglePointMethods.newton,
        function: 'x - 2',
        initialGuess: '1',
      )),
      verify: (bloc) {
        // Making sure that results are yielded
        expect(bloc.state, isA<NonlinearGuesses>());

        // The expected result
        const expected = Newton(
          function: 'x-2',
          x0: 1,
        );

        final stateResults = (bloc.state as NonlinearGuesses).nonlinearResults;
        final solutions = expected.solve();

        expect((bloc.state as NonlinearGuesses).nonLinear, isA<Newton>());
        expect(stateResults.efficiency, isNaN);
        expect(stateResults.convergence, isNaN);
        expect(stateResults.guesses, unorderedEquals(solutions.guesses));
      },
    );

    blocTest<NonlinearBloc, NonlinearState>(
      'Making sure that nonlinear equations can be solved with Steffensen',
      build: () => NonlinearBloc(NonlinearType.singlePoint),
      act: (bloc) => bloc.add(const SinglePointMethod(
        method: SinglePointMethods.steffensen,
        function: 'x - 2',
        initialGuess: '1',
      )),
      verify: (bloc) {
        // Making sure that results are yielded
        expect(bloc.state, isA<NonlinearGuesses>());

        final stateResults = (bloc.state as NonlinearGuesses).nonlinearResults;

        expect((bloc.state as NonlinearGuesses).nonLinear, isA<Steffensen>());
        expect(stateResults.efficiency, isNaN);
        expect(stateResults.convergence, isNaN);
        expect(stateResults.guesses.contains(2.0), isTrue);
      },
    );

    blocTest<NonlinearBloc, NonlinearState>(
      'Making sure that nonlinear equations can be solved with Bisection',
      build: () => NonlinearBloc(NonlinearType.bracketing),
      act: (bloc) => bloc.add(const BracketingMethod(
        method: BracketingMethods.bisection,
        function: 'x - 2',
        lowerBound: '1',
        upperBound: '3',
      )),
      verify: (bloc) {
        // Making sure that results are yielded
        expect(bloc.state, isA<NonlinearGuesses>());

        // The expected result
        const expected = Bisection(
          function: 'x-2',
          a: 1,
          b: 3,
        );

        final stateResults = (bloc.state as NonlinearGuesses).nonlinearResults;
        final solutions = expected.solve();

        expect((bloc.state as NonlinearGuesses).nonLinear, isA<Bisection>());
        expect(stateResults.efficiency, isNaN);
        expect(stateResults.convergence, isNaN);
        expect(stateResults.guesses, unorderedEquals(solutions.guesses));
      },
    );

    blocTest<NonlinearBloc, NonlinearState>(
      'Making sure that nonlinear equations can be solved with Brent',
      build: () => NonlinearBloc(NonlinearType.bracketing),
      act: (bloc) => bloc.add(const BracketingMethod(
        method: BracketingMethods.brent,
        function: 'x - 2',
        lowerBound: '1',
        upperBound: '3',
      )),
      verify: (bloc) {
        // Making sure that results are yielded
        expect(bloc.state, isA<NonlinearGuesses>());

        // The expected result
        const expected = Brent(
          function: 'x-2',
          a: 1,
          b: 3,
        );

        final stateResults = (bloc.state as NonlinearGuesses).nonlinearResults;
        final solutions = expected.solve();

        expect((bloc.state as NonlinearGuesses).nonLinear, isA<Brent>());
        expect(stateResults.efficiency, equals(1));
        expect(stateResults.convergence, equals(1));
        expect(stateResults.guesses, unorderedEquals(solutions.guesses));
      },
    );

    blocTest<NonlinearBloc, NonlinearState>(
      'Making sure that nonlinear equations can be solved with Secant',
      build: () => NonlinearBloc(NonlinearType.bracketing),
      act: (bloc) => bloc.add(const BracketingMethod(
        method: BracketingMethods.secant,
        function: 'x - 2',
        lowerBound: '1',
        upperBound: '3',
      )),
      verify: (bloc) {
        // Making sure that results are yielded
        expect(bloc.state, isA<NonlinearGuesses>());

        // The expected result
        const expected = Secant(
          function: 'x-2',
          firstGuess: 1,
          secondGuess: 3,
        );

        final stateResults = (bloc.state as NonlinearGuesses).nonlinearResults;
        final solutions = expected.solve();

        expect((bloc.state as NonlinearGuesses).nonLinear, isA<Secant>());
        expect(stateResults.efficiency, isNaN);
        expect(stateResults.convergence, isNaN);
        expect(stateResults.guesses, unorderedEquals(solutions.guesses));
      },
    );

    blocTest<NonlinearBloc, NonlinearState>(
      'Making sure that an exception is thrown if one (or more) input values '
      'are malformed strings',
      build: () => NonlinearBloc(NonlinearType.bracketing),
      act: (bloc) => bloc.add(const BracketingMethod(
        method: BracketingMethods.secant,
        function: 'abc',
        lowerBound: '1',
        upperBound: '3',
      )),
      expect: () => const [NonlinearError()],
      verify: (bloc) => bloc.state == const NonlinearError(),
    );
  });
}
