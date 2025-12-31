import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('CholeskySolver', () {
    test('Smoke test', () {
      final choleskySolver = CholeskySolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: [
            [6, 15, 55],
            [15, 55, 255],
            [55, 225, 979],
          ],
        ),
        knownValues: const [76, 295, 1259],
      );

      // This is needed because we want to make sure that the "original"
      // matrix doesn't get side effects from the calculations (i.e. row
      // swapping).
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [6, 15, 55],
          [15, 55, 255],
          [55, 225, 979],
        ],
      );

      final results = choleskySolver.solve();

      for (final sol in results) {
        expect(sol, const MoreOrLessEquals(1, precision: 1.0e-1));
      }

      // Checking the "state" of the object
      expect(choleskySolver.matrix, equals(matrix));
      expect(choleskySolver.hasSolution(), isTrue);
      expect(
        choleskySolver.knownValues,
        orderedEquals(const [76, 295, 1259]),
      );
      expect(choleskySolver.precision, equals(1.0e-10));
      expect(choleskySolver.size, equals(3));
    });

    test('String conversion', () {
      final solver = CholeskySolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [-6, 15, 55],
            [15, 55, 255],
            [55, 225, 979],
          ],
        ),
        knownValues: const [76, 295, 1259],
      );

      const toString =
          '[-6.0, 15.0, 55.0]\n'
          '[15.0, 55.0, 255.0]\n'
          '[55.0, 225.0, 979.0]';
      const toStringAugmented =
          '[-6.0, 15.0, 55.0 | 76.0]\n'
          '[15.0, 55.0, 255.0 | 295.0]\n'
          '[55.0, 225.0, 979.0 | 1259.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test('Throws exception if the matrix is not positive definite', () {
      final solver = CholeskySolver(
        matrix: RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [-6, 15, 55],
            [15, 55, 255],
            [55, 225, 979],
          ],
        ),
        knownValues: const [76, 295, 1259],
      );

      expect(solver.solve, throwsA(isA<SystemSolverException>()));
    });

    test('Throws exception if the matrix is not square', () {
      expect(
        () => CholeskySolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 3,
            data: const [
              [1, 2, 3],
              [4, 5, 6],
            ],
          ),
          knownValues: [7, 8],
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Throws exception if vector and matrix have different sizes', () {
      expect(
        () => CholeskySolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [1, 2],
              [3, 4],
            ],
          ),
          knownValues: [7, 8, 9],
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Object comparison', () {
      final cholesky = CholeskySolver(
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

      final cholesky2 = CholeskySolver(
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

      final different = CholeskySolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, -2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
      );

      expect(cholesky, equals(cholesky2));
      expect(cholesky == cholesky2, isTrue);
      expect(cholesky2, equals(cholesky));
      expect(cholesky2 == cholesky, isTrue);
      expect(cholesky.hashCode, equals(cholesky2.hashCode));
      expect(cholesky == different, isFalse);
      expect(cholesky.hashCode == different.hashCode, isFalse);
    });

    group('Solver tests', () {
      void verifySolutions(
        CholeskySolver solver,
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
        final solver = CholeskySolver(
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
        final solver = CholeskySolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [4, 12, -16],
              [12, 37, -43],
              [-16, -43, 98],
            ],
          ),
          knownValues: [9, 1, 0],
        );

        verifySolutions(solver, <double>[430.6944, -118.2222, 18.4444]);
      });

      test('Test 3', () {
        final solver = CholeskySolver(
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

      test('Test 4', () {
        final solver = CholeskySolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 2],
              [2, 3],
            ],
          ),
          knownValues: [10, 7],
        );

        verifySolutions(solver, <double>[2, 1]);
      });

      test('Test 5', () {
        final solver = CholeskySolver(
          matrix: RealMatrix.fromData(
            rows: 4,
            columns: 4,
            data: const [
              [9, 3, 0, 0],
              [3, 4, 1, 0],
              [0, 1, 5, 2],
              [0, 0, 2, 6],
            ],
          ),
          knownValues: [12, 8, 8, 8],
        );

        verifySolutions(solver, <double>[1, 1, 1, 1]);
      });

      test('Test 6', () {
        final solver = CholeskySolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [2.5, 1.0, 0.5],
              [1.0, 3.0, 1.5],
              [0.5, 1.5, 4.0],
            ],
          ),
          knownValues: [4.0, 5.5, 6.0],
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 7', () {
        final solver = CholeskySolver(
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
