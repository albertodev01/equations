import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('GaussianElimination', () {
    test('Smoke test', () {
      final gauss = GaussianElimination(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [1, 2, -2],
            [2, -2, 1],
            [1, -1, 2],
          ],
        ),
        knownValues: [-5, -5, -1],
      );

      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, -2],
          [2, -2, 1],
          [1, -1, 2],
        ],
      );

      expect(gauss.matrix, equals(matrix));
      expect(gauss.knownValues, orderedEquals(<double>[-5, -5, -1]));
      expect(gauss.precision, equals(1.0e-10));
      expect(gauss.size, equals(3));
      expect(gauss.hasSolution(), isTrue);

      final solutions = gauss.solve();
      expect(solutions, unorderedEquals(<double>[-3, 0, 1]));
      expect(gauss.determinant(), equals(-9));
    });

    test('String conversion test', () {
      final solver = GaussianElimination(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [1, 2, -2],
            [2, -2, 1],
            [1, -1, 2],
          ],
        ),
        knownValues: const [-1, 7, -7],
      );

      const toString =
          '[1.0, 2.0, -2.0]\n'
          '[2.0, -2.0, 1.0]\n'
          '[1.0, -1.0, 2.0]';
      const toStringAugmented =
          '[1.0, 2.0, -2.0 | -1.0]\n'
          '[2.0, -2.0, 1.0 | 7.0]\n'
          '[1.0, -1.0, 2.0 | -7.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test('Matrix validation test', () {
      expect(
        () => GaussianElimination(
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

    test('Singular matrix test', () {
      final gauss = GaussianElimination(
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

      expect(gauss.determinant(), equals(0));
      expect(gauss.solve, throwsA(isA<SystemSolverException>()));
    });

    test('Matrix validation test', () {
      expect(
        () => GaussianElimination(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
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
      final gauss = GaussianElimination(
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

      final gauss2 = GaussianElimination(
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

      expect(gauss, equals(gauss2));
      expect(gauss == gauss2, isTrue);
      expect(gauss2, equals(gauss));
      expect(gauss2 == gauss, isTrue);
      expect(gauss.hashCode, equals(gauss2.hashCode));
    });

    group('Solver tests', () {
      void verifySolutions(
        GaussianElimination solver,
        List<double> expectedSolutions,
      ) {
        final solutions = solver.solve();

        // For Gaussian elimination, solutions might be in any order
        expect(solutions.length, equals(expectedSolutions.length));
        for (var i = 0; i < solutions.length; ++i) {
          expect(
            solutions[i],
            MoreOrLessEquals(expectedSolutions[i], precision: 1.0e-1),
          );
        }
      }

      test('Test 1', () {
        final solver = GaussianElimination(
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
        final solver = GaussianElimination(
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
        final solver = GaussianElimination(
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
        final solver = GaussianElimination(
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
        final solver = GaussianElimination(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [2, 1, 0],
              [1, 2, 1],
              [0, 1, 2],
            ],
          ),
          knownValues: [3, 4, 3],
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 6', () {
        final solver = GaussianElimination(
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
        final solver = GaussianElimination(
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
        final solver = GaussianElimination(
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

      test('Test 9', () {
        final solver = GaussianElimination(
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
  });
}
