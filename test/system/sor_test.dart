import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'SORSolver' class.", () {
    test(
        'Making sure that the sor iterative method works properly with a'
        ' well formed matrix.', () {
      final sor = SORSolver(
        equations: const [
          [3, -1, 1],
          [-1, 3, -1],
          [1, -1, 3],
        ],
        constants: [-1, 7, -7],
        w: 1.25,
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
      expect(sor.equations, equals(matrix));
      expect(sor.knownValues, orderedEquals(<double>[-1, 7, -7]));
      expect(sor.w, equals(1.25));
      expect(sor.maxSteps, equals(30));
      expect(sor.precision, equals(1.0e-10));
      expect(sor.size, equals(3));

      // Solutions
      expect(sor.determinant(), equals(20));

      final solutions = sor.solve();
      expect(solutions[0], const MoreOrLessEquals(1, precision: 1.0e-2));
      expect(solutions[1], const MoreOrLessEquals(2, precision: 1.0e-2));
      expect(solutions[2], const MoreOrLessEquals(-2, precision: 1.0e-2));
    });

    test(
        'Making sure that flat constructor produces the same object that '
        'a non-flattened constructor does', () {
      final matrix = SORSolver(
        equations: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
        constants: const [1, 2, 3],
        w: 1.5,
      );

      final flatMatrix = SORSolver.flatMatrix(
        equations: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
        constants: const [1, 2, 3],
        w: 1.5,
      );

      expect(matrix, equals(flatMatrix));
    });

    test('Making sure that the string conversion works properly.', () {
      final solver = SORSolver(
        equations: const [
          [3, -1, 1],
          [-1, 3, -1],
          [1, -1, 3],
        ],
        constants: [-1, 7, -7],
        w: 1.25,
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
        'known values vector also matches the size of the matrix.', () {
      expect(
        () => SORSolver(
          equations: const [
            [1, 2],
            [4, 5],
          ],
          constants: [
            7,
            8,
            9,
          ],
          w: 2,
        ),
        throwsA(isA<MatrixException>()),
      );
    });

    test(
        'Making sure that when the input is a flat matrix, the matrix must '
        'be squared.', () {
      expect(
        () => SORSolver.flatMatrix(
          equations: const [1, 2, 3, 4, 5],
          constants: [7, 8],
          w: 1.25,
        ),
        throwsA(isA<MatrixException>()),
      );
    });

    test('Making sure that objects comparison works properly.', () {
      final sor = SORSolver(
        equations: const [
          [1, 2],
          [3, 4],
        ],
        constants: [0, -6],
        w: 2,
      );

      final sor2 = SORSolver(
        equations: const [
          [1, 2],
          [3, 4],
        ],
        constants: [0, -6],
        w: 2,
      );

      expect(sor, equals(sor2));
      expect(sor == sor2, isTrue);
      expect(sor.hashCode, equals(sor2.hashCode));
    });
  });
}
