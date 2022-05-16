import 'package:bloc_test/bloc_test.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'PolynomialBloc' bloc", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = PolynomialBloc(PolynomialType.linear);

      expect(bloc.state, equals(const PolynomialNone()));
      expect(bloc.polynomialType, equals(PolynomialType.linear));
    });

    test('Making sure that there are 4 types of polynomial equations', () {
      expect(PolynomialType.values.length, equals(4));
    });

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that the bloc emits states',
      build: () => PolynomialBloc(PolynomialType.linear),
      act: (bloc) => bloc.add(const PolynomialClean()),
      expect: () => const [PolynomialNone()],
      verify: (bloc) => bloc.state == const PolynomialNone(),
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that the bloc handles errors',
      build: () => PolynomialBloc(PolynomialType.linear),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['1'],
        ),
      ),
      expect: () => const [PolynomialError()],
      verify: (bloc) => bloc.state == const PolynomialError(),
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that the bloc handles invalid polynomial types',
      build: () => PolynomialBloc(PolynomialType.linear),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['0', '1'],
        ),
      ),
      expect: () => const [PolynomialError()],
      verify: (bloc) => bloc.state == const PolynomialError(),
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that an exception is thrown if the type of polynomial is '
      "'Linear' and the params list length is not 2",
      build: () => PolynomialBloc(PolynomialType.linear),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['1'],
        ),
      ),
      expect: () => const [PolynomialError()],
      verify: (bloc) => bloc.state == const PolynomialNone(),
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that an exception is thrown if the type of polynomial is '
      "'Linear' and the params list length is not 3",
      build: () => PolynomialBloc(PolynomialType.quadratic),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['1', '2'],
        ),
      ),
      expect: () => const [PolynomialError()],
      verify: (bloc) => bloc.state == const PolynomialNone(),
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that an exception is thrown if the type of polynomial is '
      "'Linear' and the params list length is not 4",
      build: () => PolynomialBloc(PolynomialType.cubic),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['1', '2', '3'],
        ),
      ),
      expect: () => const [PolynomialError()],
      verify: (bloc) => bloc.state == const PolynomialNone(),
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that an exception is thrown if the type of polynomial is '
      "'Linear' and the params list length is not 5",
      build: () => PolynomialBloc(PolynomialType.quartic),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['1', '2', '3', '4'],
        ),
      ),
      expect: () => const [PolynomialError()],
      verify: (bloc) => bloc.state == const PolynomialNone(),
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that an exception is thrown if one (or more) coefficients '
      'are malformed strings',
      build: () => PolynomialBloc(PolynomialType.quadratic),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['x', 'x', 'x'],
        ),
      ),
      expect: () => const [PolynomialError()],
      verify: (bloc) => bloc.state == const PolynomialNone(),
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that linear polynomials can be solved',
      build: () => PolynomialBloc(PolynomialType.linear),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['1', '2'],
        ),
      ),
      verify: (bloc) {
        // Making sure that results are yielded
        expect(bloc.state, isA<PolynomialRoots>());

        // The expected result
        final expected = Algebraic.from(const [
          Complex.fromReal(1),
          Complex.fromReal(2),
        ]);

        final currentState = bloc.state as PolynomialRoots;
        expect(currentState.roots, unorderedEquals(expected.solutions()));
        expect(currentState.discriminant, equals(expected.discriminant()));
        expect(currentState.algebraic, equals(expected));
      },
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that quadratic polynomials can be solved',
      build: () => PolynomialBloc(PolynomialType.quadratic),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['1', '2', '3'],
        ),
      ),
      verify: (bloc) {
        // Making sure that results are yielded
        expect(bloc.state, isA<PolynomialRoots>());

        // The expected result
        final expected = Algebraic.from(const [
          Complex.fromReal(1),
          Complex.fromReal(2),
          Complex.fromReal(3),
        ]);

        final currentState = bloc.state as PolynomialRoots;
        expect(currentState.roots, unorderedEquals(expected.solutions()));
        expect(currentState.discriminant, equals(expected.discriminant()));
        expect(currentState.algebraic, equals(expected));
      },
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that cubic polynomials can be solved',
      build: () => PolynomialBloc(PolynomialType.cubic),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['1', '2', '3', '4'],
        ),
      ),
      verify: (bloc) {
        // Making sure that results are yielded
        expect(bloc.state, isA<PolynomialRoots>());

        // The expected result
        final expected = Algebraic.from(const [
          Complex.fromReal(1),
          Complex.fromReal(2),
          Complex.fromReal(3),
          Complex.fromReal(4),
        ]);

        final currentState = bloc.state as PolynomialRoots;
        expect(currentState.roots, unorderedEquals(expected.solutions()));
        expect(currentState.discriminant, equals(expected.discriminant()));
        expect(currentState.algebraic, equals(expected));
      },
    );

    blocTest<PolynomialBloc, PolynomialState>(
      'Making sure that quartic polynomials can be solved',
      build: () => PolynomialBloc(PolynomialType.quartic),
      act: (bloc) => bloc.add(
        const PolynomialSolve(
          coefficients: ['1', '2', '3', '4', '5'],
        ),
      ),
      verify: (bloc) {
        // Making sure that results are yielded
        expect(bloc.state, isA<PolynomialRoots>());

        // The expected result
        final expected = Algebraic.from(const [
          Complex.fromReal(1),
          Complex.fromReal(2),
          Complex.fromReal(3),
          Complex.fromReal(4),
          Complex.fromReal(5),
        ]);

        final currentState = bloc.state as PolynomialRoots;
        expect(currentState.roots, unorderedEquals(expected.solutions()));
        expect(currentState.discriminant, equals(expected.discriminant()));
        expect(currentState.algebraic, equals(expected));
      },
    );
  });
}
