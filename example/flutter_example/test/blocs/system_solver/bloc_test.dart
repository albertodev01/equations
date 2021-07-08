import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group("Testing the 'SystemBloc' bloc", () {
    test('Making sure that the initial state of the bloc is correct', () {
      final bloc = SystemBloc(SystemType.rowReduction);

      expect(bloc.state, equals(const SystemNone()));
      expect(bloc.systemType, equals(SystemType.rowReduction));
    });

    test('Making sure that there are 3 types of system solvers', () {
      expect(SystemType.values.length, equals(3));
    });

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc works when solving row reduction system',
      build: () => SystemBloc(SystemType.rowReduction),
      act: (bloc) => bloc.add(const RowReductionMethod(
        matrix: ['3', '-5', '1', '-4'],
        knownValues: ['4', '-1'],
        size: 2,
      )),
      verify: (bloc) {
        expect(bloc.state, isA<SystemGuesses>());

        // Checking solutions
        final solutions = (bloc.state as SystemGuesses).solution;
        expect(solutions[0], const MoreOrLessEquals(3, precision: 1.0e-1));
        expect(solutions[1], const MoreOrLessEquals(1, precision: 1.0e-1));
      },
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc throws if the matrix is singular (row red.)',
      build: () => SystemBloc(SystemType.rowReduction),
      act: (bloc) => bloc.add(
        const RowReductionMethod(
          matrix: ['1', '2', '1', '2'],
          knownValues: ['4', '-1'],
          size: 2,
        ),
      ),
      expect: () => const [
        SingularSystemError(),
      ],
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc throws on malformed input data',
      build: () => SystemBloc(SystemType.rowReduction),
      act: (bloc) => bloc.add(const RowReductionMethod(
        matrix: ['1', 'a', 'x', ''],
        knownValues: ['4', '-1'],
        size: 2,
      )),
      expect: () => const [
        SystemError(),
      ],
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc works when solving systems using LU',
      build: () => SystemBloc(SystemType.factorization),
      act: (bloc) => bloc.add(const FactorizationMethod(
        matrix: ['3', '-5', '1', '-4'],
        knownValues: ['4', '-1'],
        size: 2,
      )),
      verify: (bloc) {
        expect(bloc.state, isA<SystemGuesses>());
        expect(
          (bloc.state as SystemGuesses).systemSolver.hasSolution(),
          isTrue,
        );

        // Checking solutions
        final solutions = (bloc.state as SystemGuesses).solution;
        expect(solutions[0], const MoreOrLessEquals(3, precision: 1.0e-1));
        expect(solutions[1], const MoreOrLessEquals(1, precision: 1.0e-1));
      },
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc works when solving systems using Cholesky',
      build: () => SystemBloc(SystemType.factorization),
      act: (bloc) => bloc.add(const FactorizationMethod(
        matrix: ['6', '15', '15', '55'],
        knownValues: ['5', '10'],
        method: FactorizationMethods.cholesky,
        size: 2,
      )),
      verify: (bloc) {
        expect(bloc.state, isA<SystemGuesses>());
        expect(
          (bloc.state as SystemGuesses).systemSolver.hasSolution(),
          isTrue,
        );

        // Checking solutions
        final solutions = (bloc.state as SystemGuesses).solution;
        expect(
          solutions[0],
          const MoreOrLessEquals(25 / 21, precision: 1.0e-5),
        );
        expect(
          solutions[1],
          const MoreOrLessEquals(-1 / 7, precision: 1.0e-5),
        );
      },
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc throws if the matrix is singular (factor.)',
      build: () => SystemBloc(SystemType.factorization),
      act: (bloc) => bloc.add(const FactorizationMethod(
        matrix: ['1', '2', '1', '2'],
        knownValues: ['4', '-1'],
        size: 2,
      )),
      expect: () => const [
        SingularSystemError(),
      ],
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc throws on malformed input data',
      build: () => SystemBloc(SystemType.factorization),
      act: (bloc) => bloc.add(const FactorizationMethod(
        matrix: ['1', '2', '3', ''],
        knownValues: ['2', '0'],
        size: 2,
      )),
      expect: () => const [
        SystemError(),
      ],
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc works when solving systems using SOR',
      build: () => SystemBloc(SystemType.iterative),
      act: (bloc) => bloc.add(const IterativeMethod(
        matrix: ['3', '-5', '1', '-4'],
        knownValues: ['4', '-1'],
        size: 2,
      )),
      verify: (bloc) {
        expect(bloc.state, isA<SystemGuesses>());
        expect(
          (bloc.state as SystemGuesses).systemSolver.hasSolution(),
          isTrue,
        );

        // Checking solutions
        final solutions = (bloc.state as SystemGuesses).solution;
        expect(solutions[0], const MoreOrLessEquals(3, precision: 1.0e-1));
        expect(solutions[1], const MoreOrLessEquals(1, precision: 1.0e-1));
      },
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc works when solving systems using Gauss-Seidel',
      build: () => SystemBloc(SystemType.iterative),
      act: (bloc) => bloc.add(const IterativeMethod(
        matrix: ['3', '-5', '1', '-4'],
        knownValues: ['4', '-1'],
        method: IterativeMethods.gaussSeidel,
        size: 2,
      )),
      verify: (bloc) {
        expect(bloc.state, isA<SystemGuesses>());
        expect(
          (bloc.state as SystemGuesses).systemSolver.hasSolution(),
          isTrue,
        );

        // Checking solutions
        final solutions = (bloc.state as SystemGuesses).solution;
        expect(solutions[0], const MoreOrLessEquals(3, precision: 1.0e-1));
        expect(solutions[1], const MoreOrLessEquals(1, precision: 1.0e-1));
      },
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc works when solving systems using Jacobi',
      build: () => SystemBloc(SystemType.iterative),
      act: (bloc) => bloc.add(const IterativeMethod(
        matrix: ['3', '-5', '1', '-4'],
        knownValues: ['4', '-1'],
        method: IterativeMethods.jacobi,
        jacobiInitialVector: ['4', '-1'],
        size: 2,
      )),
      verify: (bloc) {
        expect(bloc.state, isA<SystemGuesses>());
        expect(
          (bloc.state as SystemGuesses).systemSolver.hasSolution(),
          isTrue,
        );

        // Checking solutions
        final solutions = (bloc.state as SystemGuesses).solution;
        expect(solutions[0], const MoreOrLessEquals(3, precision: 1.0e-1));
        expect(solutions[1], const MoreOrLessEquals(1, precision: 1.0e-1));
      },
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc can emit errors with iterative methods',
      build: () => SystemBloc(SystemType.iterative),
      act: (bloc) => bloc.add(const IterativeMethod(
        matrix: ['3', 'x', '1', '-4'],
        knownValues: ['4', 'aa'],
        method: IterativeMethods.jacobi,
        jacobiInitialVector: ['4', '-1'],
        size: 2,
      )),
      expect: () => const [
        SystemError(),
      ],
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc throws if the matrix is singular (iter.)',
      build: () => SystemBloc(SystemType.iterative),
      act: (bloc) => bloc.add(const IterativeMethod(
        matrix: ['1', '2', '1', '2'],
        knownValues: ['4', '-1'],
        size: 2,
      )),
      expect: () => const [
        SingularSystemError(),
      ],
    );

    blocTest<SystemBloc, SystemState>(
      'Making sure that the bloc throws on malformed input data',
      build: () => SystemBloc(SystemType.factorization),
      act: (bloc) => bloc.add(const FactorizationMethod(
        matrix: ['1', '2', '3', ''],
        knownValues: ['2', '0'],
        size: 2,
      )),
      expect: () => const [
        SystemError(),
      ],
    );
  });
}
