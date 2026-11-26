import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';
import 'solver_checks.dart';

void main() {
  group('GaussSeidelSolver', () {
    test('Smoke test', () {
      final gaussSeidel = GaussSeidelSolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: [
            [3, -1, 1],
            [-1, 3, -1],
            [1, -1, 3],
          ],
        ),
        knownValues: [-1, 7, -7],
      );

      // This is needed because we want to make sure that the "original"
      // matrix doesn't get side effects from the calculations (i.e. row
      // swapping).
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [3, -1, 1],
          [-1, 3, -1],
          [1, -1, 3],
        ],
      );

      expect(gaussSeidel.matrix, equals(matrix));
      expect(gaussSeidel.knownValues, orderedEquals(<double>[-1, 7, -7]));
      expect(gaussSeidel.maxSteps, equals(1000));
      expect(gaussSeidel.precision, equals(1.0e-10));
      expect(gaussSeidel.size, equals(3));
      expect(gaussSeidel.hasSolution(), isTrue);

      expect(gaussSeidel.determinant(), equals(20));

      final solutions = gaussSeidel.solve();
      expect(solutions.first, const MoreOrLessEquals(1, precision: 1.0e-2));
      expect(solutions[1], const MoreOrLessEquals(2, precision: 1.0e-2));
      expect(solutions[2], const MoreOrLessEquals(-2, precision: 1.0e-2));
    });

    test('String conversion test', () {
      final solver = GaussSeidelSolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: [
            [3, -1, 1],
            [-1, 3, -1],
            [1, -1, 3],
          ],
        ),
        knownValues: const [-1, 7, -7],
      );

      const toString =
          '[3.0, -1.0, 1.0]\n'
          '[-1.0, 3.0, -1.0]\n'
          '[1.0, -1.0, 3.0]';
      const toStringAugmented =
          '[3.0, -1.0, 1.0 | -1.0]\n'
          '[-1.0, 3.0, -1.0 | 7.0]\n'
          '[1.0, -1.0, 3.0 | -7.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test('Matrix validation test', () {
      expect(
        () => GaussSeidelSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: [
              [1, 2],
              [4, 5],
            ],
          ),
          knownValues: [7, 8, 9],
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Equality test', () {
      final gaussSeidel = GaussSeidelSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [1, 2],
            [4, 5],
          ],
        ),
        knownValues: [0, -6],
      );

      final gaussSeidel2 = GaussSeidelSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [1, 2],
            [4, 5],
          ],
        ),
        knownValues: [0, -6],
      );

      expect(gaussSeidel, equals(gaussSeidel2));
      expect(gaussSeidel == gaussSeidel2, isTrue);
      expect(gaussSeidel2, equals(gaussSeidel));
      expect(gaussSeidel2 == gaussSeidel, isTrue);
      expect(gaussSeidel.hashCode, equals(gaussSeidel2.hashCode));
    });

    group('Solver tests', () {
      void verifySolutions(
        GaussSeidelSolver solver,
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
        final solver = GaussSeidelSolver(
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
        final solver = GaussSeidelSolver(
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
        final solver = GaussSeidelSolver(
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
        final solver = GaussSeidelSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 4],
        );

        verifySolutions(solver, <double>[1, 1]);
      });

      test('Test 5', () {
        final solver = GaussSeidelSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [4, -1, 0],
              [-1, 4, -1],
              [0, -1, 4],
            ],
          ),
          knownValues: [2, 6, 2],
        );

        verifySolutions(solver, <double>[1, 2, 1]);
      });

      test('Test 6', () {
        final solver = GaussSeidelSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [6, 1, 0],
              [1, 6, 1],
              [0, 1, 6],
            ],
          ),
          knownValues: [7, 8, 7],
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 7', () {
        final solver = GaussSeidelSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [3, 1],
              [1, 3],
            ],
          ),
          knownValues: [-2, -4],
        );

        verifySolutions(solver, <double>[-0.25, -1.25]);
      });

      test('Test 8', () {
        final solver = GaussSeidelSolver(
          matrix: RealMatrix.fromData(
            rows: 4,
            columns: 4,
            data: const [
              [4, 1, 0, 0],
              [1, 4, 1, 0],
              [0, 1, 4, 1],
              [0, 0, 1, 4],
            ],
          ),
          knownValues: [5, 6, 6, 5],
        );

        verifySolutions(solver, <double>[1, 1, 1, 1]);
      });

      test('Test 9', () {
        final solver = GaussSeidelSolver(
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
    });

    group('Edge cases', () {
      test('Throws at construction when the diagonal has a zero', () {
        expect(
          () => GaussSeidelSolver(
            matrix: RealMatrix.fromData(
              rows: 2,
              columns: 2,
              data: const [
                [0, 1],
                [1, 0],
              ],
            ),
            knownValues: [1, 1],
          ),
          throwsA(isA<SystemSolverException>()),
        );
      });

      test('Uses the initial guess', () {
        GaussSeidelSolver build(List<double>? x0) => GaussSeidelSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 4],
          x0: x0,
        );

        expect(build(null).x0, orderedEquals(<double>[0, 0]));
        expect(build([0, 0]), equals(build(null)));
        expect(build([0, 0]).hashCode, equals(build(null).hashCode));
        expect(build([1, 1]), isNot(equals(build(null))));
        expect(() => build([1, 2, 3]), throwsA(isA<SystemSolverException>()));
      });

      test("Throws when the method doesn't converge within maxSteps", () {
        final solver = GaussSeidelSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 4],
          maxSteps: 2,
        );

        expect(
          solver.solve,
          throwsA(
            isA<SystemSolverException>().having(
              (e) => e.message,
              'message',
              contains('Gauss-Seidel method did not converge'),
            ),
          ),
        );
      });
    });

    group('Convergence', () {
      test(
        'Converges for positive-definite matrices that Jacobi cannot solve',
        () {
          final matrix = matrixOf([
            [1, 0.9, 0.9],
            [0.9, 1, 0.9],
            [0.9, 0.9, 1],
          ]);

          expect(
            JacobiSolver(matrix: matrix, knownValues: [2.8, 2.8, 2.8]).solve,
            throwsSolverException('Jacobi'),
          );

          final solver = GaussSeidelSolver(
            matrix: matrix,
            knownValues: [2.8, 2.8, 2.8],
          );
          final solution = solver.solve();
          expectVectorClose(solution, [1, 1, 1]);
        },
      );

      test('Gives the same results as SOR with w = 1', () {
        final random = Random(9);

        for (var n = 1; n <= 8; ++n) {
          final matrix = randomDominantSpdMatrix(n, random);
          final knownValues = randomVector(n, random);
          final x0 = randomVector(n, random);

          expect(
            GaussSeidelSolver(
              matrix: matrix,
              knownValues: knownValues,
              x0: x0,
            ).solve(),
            orderedEquals(
              SORSolver(
                matrix: matrix,
                knownValues: knownValues,
                w: 1,
                x0: x0,
              ).solve(),
            ),
          );
        }
      });

      test('Counts the steps correctly', () {
        GaussSeidelSolver identity(int maxSteps) => GaussSeidelSolver(
          matrix: matrixOf([
            [1, 0],
            [0, 1],
          ]),
          knownValues: [3, -4],
          maxSteps: maxSteps,
        );

        expect(identity(1).solve, throwsSolverException('within 1 steps'));
        expect(identity(2).solve(), orderedEquals(<double>[3, -4]));
      });

      test('Converges slowly for weakly dominant matrices', () {
        // The 1D Poisson matrix of order 20 needs about 800 steps
        final matrix = poissonMatrix(20);
        final knownValues = List<double>.filled(20, 1);

        expect(
          GaussSeidelSolver(
            matrix: matrix,
            knownValues: knownValues,
            maxSteps: 500,
          ).solve,
          throwsSolverException('did not converge within 500 steps'),
        );

        final solver = GaussSeidelSolver(
          matrix: matrix,
          knownValues: knownValues,
        );
        expectSmallResidual(solver, solver.solve(), tolerance: 1e-9);
      });
    });

    group('Validation', () {
      test('Rejects invalid initial guesses and maxSteps', () {
        final matrix = matrixOf([
          [4, 1],
          [1, 3],
        ]);

        expect(
          () => GaussSeidelSolver(
            matrix: matrix,
            knownValues: [1, 2],
            x0: [double.nan, 0],
          ),
          throwsSolverException('finite'),
        );
        expect(
          () => GaussSeidelSolver(matrix: matrix, knownValues: [1, 2], x0: [0]),
          throwsSolverException('x0'),
        );
        expect(
          () => GaussSeidelSolver(
            matrix: matrix,
            knownValues: [1, 2],
            maxSteps: 0,
          ),
          throwsSolverException('maxSteps'),
        );
      });
    });
  });
}
