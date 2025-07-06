import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group("Testing the 'GaussianElimination' class.", () {
    test('Making sure that the gaussian elimination works properly with a '
        'well formed matrix. Trying with a 3x3 matrix.', () {
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

      // This is needed because we want to make sure that the "original"
      // matrix doesn't get side effects from the calculations (i.e. row
      // swapping).
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, -2],
          [2, -2, 1],
          [1, -1, 2],
        ],
      );

      // Checking the "state" of the object
      expect(gauss.matrix, equals(matrix));
      expect(gauss.knownValues, orderedEquals(<double>[-5, -5, -1]));
      expect(gauss.precision, equals(1.0e-10));
      expect(gauss.size, equals(3));
      expect(gauss.hasSolution(), isTrue);

      // Solutions
      expect(gauss.solve(), unorderedEquals(<double>[-3, 0, 1]));
      expect(gauss.determinant(), equals(-9));
    });

    test('Making sure that the string conversion works properly.', () {
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

    test('Making sure that the gaussian elimination works properly with a '
        'well formed matrix. Trying with a 2x2 matrix.', () {
      final gauss = GaussianElimination(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [3, -2],
            [1, -2],
          ],
        ),
        knownValues: [4, -8],
      );

      // This is needed because we want to make sure that the "original"
      // matrix doesn't get side effects from the calculations (i.e. row
      // swapping).
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [3, -2],
          [1, -2],
        ],
      );

      // Checking the "state" of the object
      expect(gauss.matrix, equals(matrix));
      expect(gauss.knownValues, orderedEquals(<double>[4, -8]));
      expect(gauss.precision, equals(1.0e-10));
      expect(gauss.size, equals(2));

      // Solutions
      expect(gauss.solve(), unorderedEquals(<double>[6, 7]));
      expect(gauss.determinant(), equals(-4));

      expect(gauss.knownValues, orderedEquals(const [4, -8]));
    });

    test('Making sure that a singular matrices throw an exception.', () {
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

      // Solutions
      expect(gauss.determinant(), equals(0));
      expect(gauss.solve, throwsA(isA<SystemSolverException>()));
    });

    test('Making sure that the matrix is squared because this method is only '
        "able to solve systems of 'N' equations in 'N' variables.", () {
      expect(
        () => GaussianElimination(
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

    test('Making sure that the matrix is square AND the dimension of the '
        'known values vector also matches the size of the matrix.', () {
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

    test('Making sure that objects comparison works properly.', () {
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

    test('Batch tests', () {
      final systems = [
        GaussianElimination(
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
        GaussianElimination(
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
        GaussianElimination(
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
        ).solve(),
      ];

      const solutions = <List<double>>[
        [1, 1, 1],
        [10, 2.5, -4],
        [5, -2, 3],
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
