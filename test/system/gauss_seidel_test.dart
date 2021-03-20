import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'GaussSeidelSolver' class.", () {
    test(
        'Making sure that the sor iterative method works properly with a '
        'well formed matrix.', () {
      final sor = GaussSeidelSolver(
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
      expect(sor.equations, equals(matrix));
      expect(sor.knownValues, orderedEquals(<double>[-1, 7, -7]));
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

    test('Making sure that the string conversion works properly.', () {
      final solver = GaussSeidelSolver(equations: const [
        [3, -1, 1],
        [-1, 3, -1],
        [1, -1, 3],
      ], constants: const [
        -1,
        7,
        -7,
      ]);

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
          () => GaussSeidelSolver(equations: const [
                [1, 2],
                [4, 5],
              ], constants: [
                7,
                8,
                9,
              ]),
          throwsA(isA<MatrixException>()));
    });

    test('Making sure that objects comparison works properly.', () {
      final gaussSeidel = GaussSeidelSolver(equations: const [
        [1, 2],
        [3, 4],
      ], constants: [
        0,
        -6,
      ]);

      final gaussSeidel2 = GaussSeidelSolver(equations: const [
        [1, 2],
        [3, 4],
      ], constants: [
        0,
        -6,
      ]);

      expect(gaussSeidel, equals(gaussSeidel2));
      expect(gaussSeidel == gaussSeidel2, isTrue);
      expect(gaussSeidel.hashCode, equals(gaussSeidel2.hashCode));
    });
  });
}
