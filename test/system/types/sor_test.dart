import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('SORSolver', () {
    test('Smoke test', () {
      final sor = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, -1, 1],
            [-1, 3, -1],
            [1, -1, 3],
          ],
        ),
        knownValues: [-1, 7, -7],
        w: 1.25,
      );

      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [3, -1, 1],
          [-1, 3, -1],
          [1, -1, 3],
        ],
      );

      expect(sor.matrix, equals(matrix));
      expect(sor.knownValues, orderedEquals(<double>[-1, 7, -7]));
      expect(sor.w, equals(1.25));
      expect(sor.maxSteps, equals(30));
      expect(sor.precision, equals(1.0e-10));
      expect(sor.size, equals(3));
      expect(sor.hasSolution(), isTrue);

      expect(sor.determinant(), equals(20));

      final solutions = sor.solve();
      expect(solutions.first, const MoreOrLessEquals(1, precision: 1.0e-2));
      expect(solutions[1], const MoreOrLessEquals(2, precision: 1.0e-2));
      expect(solutions[2], const MoreOrLessEquals(-2, precision: 1.0e-2));
    });

    test('String conversion test', () {
      final solver = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, -1, 1],
            [-1, 3, -1],
            [1, -1, 3],
          ],
        ),
        knownValues: [-1, 7, -7],
        w: 1.25,
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
        () => SORSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 3,
            data: const [
              [1, 2, 4],
              [3, 4, 0],
            ],
          ),
          knownValues: [7, 8, 9],
          w: 1.5,
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Matrix validation test', () {
      expect(
        () => SORSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [1, 2],
              [3, 4],
            ],
          ),
          knownValues: [7, 8, 9],
          w: 1.5,
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Equality test', () {
      final sor = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
        w: 1,
      );

      final sor2 = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
        w: 1,
      );

      expect(sor, equals(sor2));
      expect(sor == sor2, isTrue);
      expect(sor2, equals(sor));
      expect(sor2 == sor, isTrue);
      expect(sor.hashCode, equals(sor2.hashCode));
    });

    test('Validation tests', () {
      // Test invalid relaxation factor
      expect(
        () => SORSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [1, 2],
              [3, 4],
            ],
          ),
          knownValues: [7, 8],
          w: 0, // Invalid: w <= 0
        ),
        throwsA(isA<SystemSolverException>()),
      );

      expect(
        () => SORSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [1, 2],
              [3, 4],
            ],
          ),
          knownValues: [7, 8],
          w: 2, // Invalid: w >= 2
        ),
        throwsA(isA<SystemSolverException>()),
      );

      // Test zero diagonal elements
      expect(
        () => SORSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [0, 2], // Zero diagonal element
              [3, 4],
            ],
          ),
          knownValues: [7, 8],
          w: 1.5,
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Diagonal dominance check', () {
      final diagonallyDominant = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [4, 1], // |4| > |1|
            [1, 5], // |5| > |1|
          ],
        ),
        knownValues: [7, 8],
        w: 1.5,
      );

      final notDiagonallyDominant = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2], // |1| < |2|
            [3, 4],
          ],
        ),
        knownValues: [7, 8],
        w: 1.5,
      );

      expect(diagonallyDominant.isDiagonallyDominant(), isTrue);
      expect(notDiagonallyDominant.isDiagonallyDominant(), isFalse);
    });

    test('Residual norm computation', () {
      final sor = SORSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [4, 1],
            [1, 3],
          ],
        ),
        knownValues: [5, 4],
        w: 1.5,
      );

      final solution = sor.solve();
      final residualNorm = sor.computeResidualNorm(solution);

      // The residual should be small for a good solution
      expect(residualNorm, lessThan(1e-8));
    });

    group('Solver tests', () {
      void verifySolutions(
        SORSolver solver,
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
        final solver = SORSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [3, -1, 1],
              [-1, 3, -1],
              [1, -1, 3],
            ],
          ),
          knownValues: [-1, 7, -7],
          w: 1.25,
        );

        verifySolutions(solver, <double>[1, 2, -2]);
      });

      test('Test 2', () {
        final solver = SORSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [4, -2, 0],
              [-2, 6, -5],
              [0, -5, 11],
            ],
          ),
          knownValues: [8, -29, 43],
          w: 1.2,
        );

        verifySolutions(solver, <double>[1, -2, 3]);
      });

      test('Test 3', () {
        final solver = SORSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [3, -1, 1],
              [-1, 3, -1],
              [1, -1, 3],
            ],
          ),
          knownValues: [-1, 7, -7],
          w: 1.65,
        );

        verifySolutions(solver, <double>[1, 2, -2]);
      });

      test('Test 4', () {
        final solver = SORSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 4],
          w: 1.5,
        );

        verifySolutions(solver, <double>[1, 1]);
      });

      test('Test 5', () {
        final solver = SORSolver(
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
          w: 1.3,
        );

        verifySolutions(solver, <double>[1, 2, 1]);
      });

      test('Test 6', () {
        final solver = SORSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [3, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 7],
          w: 1.4,
        );

        verifySolutions(solver, <double>[1, 2]);
      });

      test('Test 7', () {
        final solver = SORSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [5, 1, 0],
              [1, 5, 1],
              [0, 1, 5],
            ],
          ),
          knownValues: [6, 7, 6],
          w: 1.2,
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 8', () {
        final solver = SORSolver(
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
          w: 1.3,
        );

        verifySolutions(solver, <double>[1, 1, 1, 1]);
      });

      test('Test 9', () {
        final solver = SORSolver(
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
          w: 1.5,
        );

        verifySolutions(solver, <double>[-0.67, 1.67, 0.67]);
      });
    });
  });
}
