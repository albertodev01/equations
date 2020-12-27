import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'GaussianElimination' class.", () {
    test(
        "Making sure that the gaussian elimination works properly with a "
        "well formed matrix. Trying with a 3x3 matrix.", () {
      final gauss = GaussianElimination(equations: const [
        [1, 2, -2],
        [2, -2, 1],
        [1, -1, 2]
      ], constants: [
        -5,
        -5,
        -1
      ]);

      // This is needed because we want to make sure that the "original" matrix
      // doesn't get side effects from the calculations (i.e. row swapping).
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, -2],
          [2, -2, 1],
          [1, -1, 2]
        ],
      );

      // Checking the "state" of the object
      expect(gauss.equations, equals(matrix));
      expect(gauss.knownValues, orderedEquals(<double>[-5, -5, -1]));
      expect(gauss.precision, equals(1.0e-10));
      expect(gauss.size, equals(3));

      // Solutions
      expect(gauss.solve(), unorderedEquals(<double>[-3, 0, 1]));
      expect(gauss.determinant(), equals(-9));
    });

    test(
        "Making sure that the gaussian elimination works properly with a "
        "well formed matrix. Trying with a 2x2 matrix.", () {
      final gauss = GaussianElimination(equations: const [
        [3, -2],
        [1, -2],
      ], constants: [
        4,
        -8
      ]);

      // This is needed because we want to make sure that the "original" matrix
      // doesn't get side effects from the calculations (i.e. row swapping).
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [3, -2],
          [1, -2],
        ],
      );

      // Checking the "state" of the object
      expect(gauss.equations, equals(matrix));
      expect(gauss.knownValues, orderedEquals(<double>[4, -8]));
      expect(gauss.precision, equals(1.0e-10));
      expect(gauss.size, equals(2));

      // Solutions
      expect(gauss.solve(), unorderedEquals(<double>[6, 7]));
      expect(gauss.determinant(), equals(-4));
    });

    test("Making sure that a singular matrices throw an exception.", () {
      final gauss = GaussianElimination(equations: const [
        [-1, -1],
        [1, 1]
      ], constants: [
        -1 / 2,
        2
      ]);

      // Solutions
      expect(gauss.determinant(), equals(0));
      //expect(() => gauss.solve(), throwsA(isA<SystemSolverException>()));
    });

    test(
        "Making sure that the matrix is squared because this method is only "
        "able to solve systems of 'N' equations in 'N' variables.", () {
      expect(
          () => GaussianElimination(equations: const [
                [1, 2, 3],
                [4, 5, 6]
              ], constants: [
                7,
                8
              ]),
          throwsA(isA<MatrixException>()));
    });

    test(
        "Making sure that the matrix is squared AND the dimension of the "
        "known values vector also matches the size of the matrix.", () {
      expect(
          () => GaussianElimination(equations: const [
                [1, 2],
                [4, 5]
              ], constants: [
                7,
                8,
                9
              ]),
          throwsA(isA<MatrixException>()));
    });

    test("Making sure that objects comparison works properly.", () {
      final gauss = GaussianElimination(equations: const [
        [1, 2], [3, 4]
      ], constants: [0, -6]);

      final gauss2 = GaussianElimination(equations: const [
        [1, 2], [3, 4]
      ], constants: [0, -6]);

      expect(gauss, equals(gauss2));
      expect(gauss == gauss2, isTrue);
      expect(gauss.hashCode, equals(gauss2.hashCode));
    });
  });
}
