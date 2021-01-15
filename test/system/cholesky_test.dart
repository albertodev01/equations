import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'CholeskyDecomposition' class.", () {
    test(
        "Making sure that the CholeskySolver computes the correct results of a "
        "system of linear equations.", () {
      final choleskySolver = CholeskySolver(equations: const [
        [6, 15, 55],
        [15, 55, 255],
        [55, 225, 979],
      ], constants: const [
        76,
        295,
        1259
      ]);

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
        expect(sol, MoreOrLessEquals(1.0, precision: 1.0e-1));
      }

      // Checking the "state" of the object
      expect(choleskySolver.equations, equals(matrix));
      expect(
          choleskySolver.knownValues, orderedEquals(<double>[76, 295, 1259]));
      expect(choleskySolver.precision, equals(1.0e-10));
      expect(choleskySolver.size, equals(3));
    });

    test("Making sure that the string conversion works properly.", () {
      final solver = CholeskySolver(equations: const [
        [-6, 15, 55],
        [15, 55, 255],
        [55, 225, 979],
      ], constants: const [
        76,
        295,
        1259,
      ]);

      final toString = "[-6.0, 15.0, 55.0]\n"
          "[15.0, 55.0, 255.0]\n"
          "[55.0, 225.0, 979.0]";
      final toStringAugmented = "[-6.0, 15.0, 55.0 | 76.0]\n"
          "[15.0, 55.0, 255.0 | 295.0]\n"
          "[55.0, 225.0, 979.0 | 1259.0]";

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test(
        "Making sure that an exception is thrown when the square root of a "
        "negative number is found while Cholesky-decomposing the matrix.", () {
      final solver = CholeskySolver(equations: const [
        [-6, 15, 55],
        [15, 55, 255],
        [55, 225, 979],
      ], constants: const [
        76,
        295,
        1259,
      ]);

      expect(solver.solve, throwsA(isA<SystemSolverException>()));
    });

    test(
        "Making sure that the matrix is squared because this method is only "
        "able to solve systems of 'N' equations in 'N' variables.", () {
      expect(
          () => CholeskySolver(equations: const [
                [1, 2, 3],
                [4, 5, 6],
              ], constants: [
                7,
                8,
              ]),
          throwsA(isA<MatrixException>()));
    });

    test(
        "Making sure that the matrix is squared AND the dimension of the "
        "known values vector also matches the size of the matrix.", () {
      expect(
          () => CholeskySolver(equations: const [
                [1, 2],
                [4, 5],
              ], constants: [
                7,
                8,
                9,
              ]),
          throwsA(isA<MatrixException>()));
    });

    test("Making sure that objects comparison works properly.", () {
      final gauss = GaussianElimination(equations: const [
        [1, 2],
        [3, 4],
      ], constants: [
        0,
        -6,
      ]);

      final gauss2 = GaussianElimination(equations: const [
        [1, 2],
        [3, 4],
      ], constants: [
        0,
        -6,
      ]);

      expect(gauss, equals(gauss2));
      expect(gauss == gauss2, isTrue);
      expect(gauss.hashCode, equals(gauss2.hashCode));
    });
  });
}
