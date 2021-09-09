import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'JacobiSolver' class.", () {
    test(
      'Making sure that the jacobi iterative method works properly with a '
      'well formed matrix.',
      () {
        final jacobi = JacobiSolver(
          equations: const [
            [2, 1],
            [5, 7],
          ],
          constants: [11, 13],
          x0: [1, 1],
        );

        // This is needed because we want to make sure that the "original" matrix
        // doesn't get side effects from the calculations (i.e. row swapping).
        final matrix = RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [2, 1],
            [5, 7],
          ],
        );

        // Checking the "state" of the object
        expect(jacobi.equations, equals(matrix));
        expect(jacobi.knownValues, orderedEquals(<double>[11, 13]));
        expect(jacobi.x0, orderedEquals(<double>[1, 1]));
        expect(jacobi.maxSteps, equals(30));
        expect(jacobi.precision, equals(1.0e-10));
        expect(jacobi.size, equals(2));
        expect(jacobi.hasSolution(), isTrue);

        // Solutions
        expect(jacobi.determinant(), equals(9));

        final solutions = jacobi.solve();
        expect(solutions[0], const MoreOrLessEquals(7.11, precision: 1.0e-2));
        expect(solutions[1], const MoreOrLessEquals(-3.22, precision: 1.0e-2));
      },
    );

    test(
      'Making sure that flat constructor produces the same object that '
      'a non-flattened constructor does',
      () {
        final matrix = JacobiSolver(
          equations: const [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
          ],
          constants: const [1, 2, 3],
          x0: [1, 2, 3],
        );

        final flatMatrix = JacobiSolver.flatMatrix(
          equations: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
          constants: const [1, 2, 3],
          x0: [1, 2, 3],
        );

        expect(matrix, equals(flatMatrix));
      },
    );

    test('Making sure that the string conversion works properly.', () {
      final solver = JacobiSolver(
        equations: const [
          [2, 1],
          [5, 7],
        ],
        constants: [11, 13],
        x0: [1, 1],
      );

      const toString = '[2.0, 1.0]\n'
          '[5.0, 7.0]';
      const toStringAugmented = '[2.0, 1.0 | 11.0]\n'
          '[5.0, 7.0 | 13.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test(
      'Making sure that the matrix is squared AND the dimension of the '
      'known values vector also matches the size of the matrix.',
      () {
        expect(
          () => JacobiSolver(
            equations: const [
              [1, 2],
              [4, 5],
            ],
            constants: [7, 8, 9],
            x0: [1, 2],
          ),
          throwsA(isA<SystemSolverException>()),
        );
      },
    );

    test(
      'Making sure that an exception is thrown when the length of the '
      'initial vector is different from the size of the NxN matrix.',
      () {
        expect(
          () => JacobiSolver(
            equations: const [
              [1, 2],
              [4, 5],
            ],
            constants: [7, 8],
            x0: [],
          ),
          throwsA(isA<SystemSolverException>()),
        );
      },
    );

    test(
      'Making sure that when the input is a flat matrix, the matrix must '
      'be squared.',
      () {
        expect(
          () => JacobiSolver.flatMatrix(
            equations: const [1, 2, 3, 4, 5],
            constants: [7, 8],
            x0: [1, 2],
          ),
          throwsA(isA<MatrixException>()),
        );

        expect(
          () => JacobiSolver.flatMatrix(
            equations: const [1, 2, 3, 4],
            constants: [7, 8],
            x0: [1],
          ),
          throwsA(isA<SystemSolverException>()),
        );
      },
    );

    test('Making sure that objects comparison works properly.', () {
      final jacobi = JacobiSolver(
        equations: const [
          [1, 2],
          [3, 4],
        ],
        constants: [0, -6],
        x0: [1, 2],
      );

      final jacobi2 = JacobiSolver(
        equations: const [
          [1, 2],
          [3, 4],
        ],
        constants: [0, -6],
        x0: [1, 2],
      );

      expect(jacobi, equals(jacobi2));
      expect(jacobi == jacobi2, isTrue);
      expect(jacobi.hashCode, equals(jacobi2.hashCode));
    });
  });
}
