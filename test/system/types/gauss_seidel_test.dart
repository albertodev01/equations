import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

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
      expect(gaussSeidel.maxSteps, equals(30));
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
  });
}
