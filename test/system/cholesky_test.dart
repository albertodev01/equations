import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'CholeskyDecomposition' class.", () {
    test(
      'Making sure that the CholeskySolver computes the correct results of a '
      'system of linear equations.',
      () {
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

        // This is needed because we want to make sure that the "original" matrix
        // doesn't get side effects from the calculations (i.e. row swapping).
        final matrix = RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [6, 15, 55],
            [15, 55, 255],
            [55, 225, 979],
          ],
        );

        // Checking solutions
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
      },
    );

    test('Making sure that the string conversion works properly.', () {
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

      const toString = '[-6.0, 15.0, 55.0]\n'
          '[15.0, 55.0, 255.0]\n'
          '[55.0, 225.0, 979.0]';
      const toStringAugmented = '[-6.0, 15.0, 55.0 | 76.0]\n'
          '[15.0, 55.0, 255.0 | 295.0]\n'
          '[55.0, 225.0, 979.0 | 1259.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test(
      'Making sure that an exception is thrown when the square root of a '
      'negative number is found while Cholesky-decomposing the matrix.',
      () {
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
      },
    );

    test(
      'Making sure that the matrix is square because this method is only '
      "able to solve systems of 'N' equations in 'N' variables.",
      () {
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
          throwsA(isA<MatrixException>()),
        );
      },
    );

    test(
      'Making sure that the matrix is square AND the dimension of the '
      'known values vector also matches the size of the matrix.',
      () {
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
          throwsA(isA<MatrixException>()),
        );
      },
    );

    test('Making sure that objects comparison works properly.', () {
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

    test('Batch tests', () {
      final systems = [
        CholeskySolver(
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
        ).solve(),
        CholeskySolver(
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
        ).solve(),
        CholeskySolver(
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
        ).solve(),
      ];

      const solutions = <List<double>>[
        [1, 1, 1],
        [430.6944, -118.2222, 18.4444],
        [10, 2.5, -4],
      ];

      for (var i = 0; i < systems.length; ++i) {
        for (var j = 0; j < 2; ++j) {
          expect(
            systems[i][j],
            MoreOrLessEquals(solutions[i][j], precision: 1.0e-4),
          );
        }
      }
    });
  });
}
