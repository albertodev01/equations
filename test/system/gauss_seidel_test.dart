import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'GaussSeidelSolver' class.", () {
    test(
      'Making sure that the sor iterative method works properly with a '
      'well formed matrix.',
      () {
        final gaussSeidel = GaussSeidelSolver(
          equations: const [
            [3, -1, 1],
            [-1, 3, -1],
            [1, -1, 3],
          ],
          constants: [-1, 7, -7],
        );

        // This is needed because we want to make sure that the "original" matrix
        // doesn't get side effects from the calculations (i.e. row swapping).
        final matrix = RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, -1, 1],
            [-1, 3, -1],
            [1, -1, 3],
          ],
        );

        // Checking the "state" of the object
        expect(gaussSeidel.matrix, equals(matrix));
        expect(gaussSeidel.knownValues, orderedEquals(<double>[-1, 7, -7]));
        expect(gaussSeidel.maxSteps, equals(30));
        expect(gaussSeidel.precision, equals(1.0e-10));
        expect(gaussSeidel.size, equals(3));
        expect(gaussSeidel.hasSolution(), isTrue);

        // Solutions
        expect(gaussSeidel.determinant(), equals(20));

        final solutions = gaussSeidel.solve();
        expect(solutions.first, const MoreOrLessEquals(1, precision: 1.0e-2));
        expect(solutions[1], const MoreOrLessEquals(2, precision: 1.0e-2));
        expect(solutions[2], const MoreOrLessEquals(-2, precision: 1.0e-2));
      },
    );

    test(
      'Making sure that flat constructor produces the same object that '
      'a non-flattened constructor does',
      () {
        final matrix = GaussSeidelSolver(
          equations: const [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
          ],
          constants: const [1, 2, 3],
        );

        final flatMatrix = GaussSeidelSolver.flatMatrix(
          equations: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
          constants: const [1, 2, 3],
        );

        expect(matrix, equals(flatMatrix));
      },
    );

    test('Making sure that the string conversion works properly.', () {
      final solver = GaussSeidelSolver(
        equations: const [
          [3, -1, 1],
          [-1, 3, -1],
          [1, -1, 3],
        ],
        constants: const [-1, 7, -7],
      );

      const toString = '[3.0, -1.0, 1.0]\n'
          '[-1.0, 3.0, -1.0]\n'
          '[1.0, -1.0, 3.0]';
      const toStringAugmented = '[3.0, -1.0, 1.0 | -1.0]\n'
          '[-1.0, 3.0, -1.0 | 7.0]\n'
          '[1.0, -1.0, 3.0 | -7.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test(
      'Making sure that the matrix is squared AND the dimension of the '
      'known values vector also matches the size of the matrix.',
      () {
        expect(
          () => GaussSeidelSolver(
            equations: const [
              [1, 2],
              [4, 5],
            ],
            constants: [7, 8, 9],
          ),
          throwsA(isA<MatrixException>()),
        );
      },
    );

    test(
      'Making sure that when the input is a flat matrix, the matrix must '
      'be squared.',
      () {
        expect(
          () => GaussSeidelSolver.flatMatrix(
            equations: const [1, 2, 3, 4, 5],
            constants: [7, 8],
          ),
          throwsA(isA<MatrixException>()),
        );
      },
    );

    test('Making sure that objects comparison works properly.', () {
      final gaussSeidel = GaussSeidelSolver(
        equations: const [
          [1, 2],
          [3, 4],
        ],
        constants: [0, -6],
      );

      final gaussSeidel2 = GaussSeidelSolver(
        equations: const [
          [1, 2],
          [3, 4],
        ],
        constants: [0, -6],
      );

      expect(gaussSeidel, equals(gaussSeidel2));
      expect(gaussSeidel == gaussSeidel2, isTrue);
      expect(gaussSeidel2, equals(gaussSeidel));
      expect(gaussSeidel2 == gaussSeidel, isTrue);
      expect(gaussSeidel.hashCode, equals(gaussSeidel2.hashCode));
    });

    test('Batch tests', () {
      final systems = [
        GaussSeidelSolver(
          equations: const [
            [25, 15, -5],
            [15, 18, 0],
            [-5, 0, 11],
          ],
          constants: [35, 33, 6],
        ).solve(),
        GaussSeidelSolver(
          equations: const [
            [1, 0, 1],
            [0, 2, 0],
            [1, 0, 3],
          ],
          constants: [6, 5, -2],
        ).solve(),
        GaussSeidelSolver(
          equations: const [
            [1, 0, 0],
            [0, 1, 0],
            [0, 0, 1],
          ],
          constants: [5, -2, 3],
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
