import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';
import 'solver_checks.dart';

void main() {
  group('LUSolver', () {
    test('Smoke test', () {
      final luSolver = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [7, -2, 1],
            [14, -7, -3],
            [-7, 11, 18],
          ],
        ),
        knownValues: const [12, 17, 5],
      );

      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [7, -2, 1],
          [14, -7, -3],
          [-7, 11, 18],
        ],
      );

      final results = luSolver.solve();
      expect(
        results.map((e) => e.roundToDouble()),
        unorderedEquals(<double>[-1, 4, 3]),
      );

      expect(luSolver.matrix, equals(matrix));
      expect(luSolver.knownValues, orderedEquals(<double>[12, 17, 5]));
      expect(luSolver.precision, equals(1.0e-10));
      expect(luSolver.size, equals(3));
      expect(luSolver.hasSolution(), isTrue);
    });

    test('String conversion test', () {
      final solver = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [7, -2, 1],
            [14, -7, -3],
            [-7, 11, 18],
          ],
        ),
        knownValues: const [12, 17, 5],
      );

      const toString =
          '[7.0, -2.0, 1.0]\n'
          '[14.0, -7.0, -3.0]\n'
          '[-7.0, 11.0, 18.0]';
      const toStringAugmented =
          '[7.0, -2.0, 1.0 | 12.0]\n'
          '[14.0, -7.0, -3.0 | 17.0]\n'
          '[-7.0, 11.0, 18.0 | 5.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test('Equality test', () {
      final lu = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
      );

      final lu2 = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
      );

      expect(lu, equals(lu2));
      expect(lu == lu2, isTrue);
      expect(lu2, equals(lu));
      expect(lu2 == lu, isTrue);
      expect(lu.hashCode, equals(lu2.hashCode));
    });

    test('Matrix validation test', () {
      expect(
        () => LUSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 3,
            data: const [
              [1, 2, 0],
              [3, 4, -6],
            ],
          ),
          knownValues: const [12, 17],
        ),
        throwsA(isA<SystemSolverException>()),
      );
      expect(
        () => LUSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [1, 2],
              [3, 4],
            ],
          ),
          knownValues: const [12, 17, 5],
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Singular matrix test', () {
      final luSolver = LUSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [-1, -1],
            [1, 1],
          ],
        ),
        knownValues: [-1 / 2, 2],
      );

      // The matrix has determinant = 0, so it should throw an exception
      expect(luSolver.determinant(), equals(0));
      expect(luSolver.solve, throwsA(isA<SystemSolverException>()));
    });

    group('Solver tests', () {
      void verifySolutions(
        LUSolver solver,
        List<double> expectedSolutions,
      ) {
        final solutions = solver.solve();
        for (var i = 0; i < solutions.length; ++i) {
          expect(
            solutions[i],
            MoreOrLessEquals(expectedSolutions[i], precision: 1.0e-1),
          );
        }
      }

      test('Test 1', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [25, 15, -5],
              [15, 18, 0],
              [-5, 0, 11],
            ],
          ),
          knownValues: [35, 33, 6],
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 2', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [1, 0, 1],
              [0, 2, 0],
              [1, 0, 3],
            ],
          ),
          knownValues: [6, 5, -2],
        );

        verifySolutions(solver, <double>[10, 2.5, -4]);
      });

      test('Test 3', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [1, 0, 0],
              [0, 1, 0],
              [0, 0, 1],
            ],
          ),
          knownValues: [5, -2, 3],
        );

        verifySolutions(solver, <double>[5, -2, 3]);
      });

      test('Test 4', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [2, 1],
              [1, 2],
            ],
          ),
          knownValues: [5, 4],
        );

        verifySolutions(solver, <double>[2, 1]);
      });

      test('Test 5', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [4, 2, 1],
              [2, 5, 2],
              [1, 2, 6],
            ],
          ),
          knownValues: [7, 9, 9],
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 6', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [3, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 7],
        );

        verifySolutions(solver, <double>[1, 2]);
      });

      test('Test 7', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 4,
            columns: 4,
            data: const [
              [1, 0, 0, 0],
              [0, 2, 0, 0],
              [0, 0, 3, 0],
              [0, 0, 0, 4],
            ],
          ),
          knownValues: [1, 4, 9, 16],
        );

        verifySolutions(solver, <double>[1, 2, 3, 4]);
      });

      test('Test 8', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [3, 1, 0],
              [1, 3, 1],
              [0, 1, 3],
            ],
          ),
          knownValues: [4, 5, 4],
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 9', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [4, 1, 0],
              [1, 3, 1],
              [0, 1, 2],
            ],
          ),
          knownValues: [-1, 5, 3],
        );

        verifySolutions(solver, <double>[-0.67, 1.67, 0.67]);
      });

      test('Test 10', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [0, 2, 1],
              [1, 1, 1],
              [2, 3, 4],
            ],
          ),
          knownValues: [5, 6, 13],
        );

        verifySolutions(solver, <double>[4, 3, -1]);
      });
    });

    group('Edge cases', () {
      test('Solves a 5x5 system whose determinant underflows to zero', () {
        final solver = LUSolver(
          matrix: RealMatrix.diagonal(
            rows: 5,
            columns: 5,
            diagonalValue: 1e-70,
          ),
          knownValues: List<double>.filled(5, 1e-70),
        );

        expect(solver.determinant(), equals(0));
        for (final value in solver.solve()) {
          expect(value, const MoreOrLessEquals(1));
        }
      });

      test('Throws when the matrix is singular', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [1, 2, 3],
              [4, 5, 6],
              [7, 8, 9],
            ],
          ),
          knownValues: [1, 2, 3],
        );

        expect(solver.solve, throwsA(isA<SystemSolverException>()));
        expect(
          () => solver.solveFor([1, 2, 3]),
          throwsA(isA<SystemSolverException>()),
        );
      });

      test('Stores the precision', () {
        final solver = LUSolver(
          matrix: RealMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [2],
            ],
          ),
          knownValues: [4],
          precision: 1e-6,
        );

        expect(solver.precision, equals(1e-6));
        expect(solver.solve(), orderedEquals(<double>[2]));
      });

      test('solveFor reuses the matrix with other known values', () {
        final matrix = RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [2, 1, 1],
            [4, -6, 0],
            [-2, 7, 2],
          ],
        );
        final solver = LUSolver(matrix: matrix, knownValues: [5, -2, 9]);

        final first = solver.solve();
        final second = solver.solveFor([4, -2, 7]);
        final third = solver.solveFor([0, 0, 0]);

        const expectedFirst = <double>[1, 1, 2];
        for (var i = 0; i < 3; ++i) {
          expect(first[i], MoreOrLessEquals(expectedFirst[i]));
          expect(second[i], const MoreOrLessEquals(1));
          expect(third[i], const MoreOrLessEquals(0));
        }

        // The known values of the solver are unchanged
        expect(solver.knownValues, orderedEquals(<double>[5, -2, 9]));
        expect(
          () => solver.solveFor([1, 2]),
          throwsA(isA<SystemSolverException>()),
        );
      });
    });

    group('solveFor', () {
      test('Matches GaussianElimination for many known values', () {
        final random = Random(3);
        final matrix = randomMatrix(8, random);
        final solver = LUSolver(
          matrix: matrix,
          knownValues: List<double>.filled(8, 1),
        );

        for (var k = 0; k < 20; ++k) {
          final knownValues = randomVector(8, random);
          final expected = GaussianElimination(
            matrix: matrix,
            knownValues: knownValues,
          ).solve();

          expectVectorClose(
            solver.solveFor(knownValues),
            expected,
            tolerance: 1e-10,
          );
        }
      });

      test('Works before solve and does not change the inputs', () {
        final solver = LUSolver(
          matrix: matrixOf([
            [0, 0, 4],
            [3, 1, 0],
            [0, 2, 1],
          ]),
          knownValues: [4, 4, 3],
        );
        final knownValues = <double>[8, 8, 6];

        expectVectorClose(solver.solveFor(knownValues), [2, 2, 2]);
        expect(knownValues, orderedEquals(<double>[8, 8, 6]));
        expectVectorClose(solver.solve(), [1, 1, 1]);
        expect(solver.solveFor([0, 0, 0]), everyElement(equals(0)));
      });

      test('Rejects invalid known values', () {
        final solver = LUSolver(
          matrix: matrixOf([
            [4, 1],
            [1, 3],
          ]),
          knownValues: [1, 2],
        );

        expect(() => solver.solveFor([]), throwsSolverException('size'));
        expect(() => solver.solveFor([1]), throwsSolverException('size'));
        for (final value in [double.nan, double.infinity]) {
          expect(
            () => solver.solveFor([1, value]),
            throwsSolverException('finite'),
          );
        }
      });

      test('Keeps throwing when the matrix is singular', () {
        final solver = LUSolver(
          matrix: matrixOf([
            [1, 2],
            [2, 4],
          ]),
          knownValues: [1, 2],
        );

        expect(solver.solve, throwsSolverException('singular'));
        expect(
          () => solver.solveFor([3, 6]),
          throwsSolverException('singular'),
        );
        expect(solver.solve, throwsSolverException('singular'));
      });
    });
  });
}
