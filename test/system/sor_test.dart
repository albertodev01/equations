import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'SORSolver' class.", () {
    test(
        "Making sure that the sor iterative method works properly with a "
        "well formed matrix.", () {
      final sor = SORSolver(
        equations: const [
          [3, -1, 1],
          [-1, 3, -1],
          [1, -1, 3]
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
          [1, -1, 3]
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
      expect(solutions[0], MoreOrLessEquals(1, precision: 1.0e-2));
      expect(solutions[1], MoreOrLessEquals(2, precision: 1.0e-2));
      expect(solutions[2], MoreOrLessEquals(-2, precision: 1.0e-2));
    });

    test(
        "Making sure that the matrix is squared AND the dimension of the "
        "known values vector also matches the size of the matrix.", () {
      expect(
          () => SORSolver(equations: const [
                [1, 2],
                [4, 5]
              ], constants: [
                7,
                8,
                9
              ], w: 2),
          throwsA(isA<MatrixException>()));
    });

    test("Making sure that objects comparison works properly.", () {
      final sor = SORSolver(equations: const [
        [1, 2],
        [3, 4]
      ], constants: [
        0,
        -6
      ], w: 2);

      final sor2 = SORSolver(equations: const [
        [1, 2],
        [3, 4]
      ], constants: [
        0,
        -6
      ], w: 2);

      expect(sor, equals(sor2));
      expect(sor == sor2, isTrue);
      expect(sor.hashCode, equals(sor2.hashCode));
    });
  });
}
