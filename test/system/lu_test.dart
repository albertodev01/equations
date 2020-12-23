import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'LUSolver' class.", () {
    test(
        "Making sure that the LU decomposition properly works on a square "
        "matrix of a given dimension.", () async {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]
        ],
      );

      // Decomposition
      final lu = matrix.luDecomposition();
      expect(lu.length, equals(2));

      // Checking L
      final L = lu[0];
      expect(L.rowCount, equals(matrix.rowCount));
      expect(L.columnCount, equals(matrix.columnCount));
      expect(L.isSquareMatrix, isTrue);
      expect(L.flattenData, orderedEquals(<double>[1, 0, 0, 4, 1, 0, 7, 2, 1]));

      // Checking U
      final U = lu[1];
      expect(U.rowCount, equals(matrix.rowCount));
      expect(U.columnCount, equals(matrix.columnCount));
      expect(U.isSquareMatrix, isTrue);
      expect(
          U.flattenData, orderedEquals(<double>[1, 2, 3, 0, -3, -6, 0, 0, 0]));
    });

    test(
        "Making sure that the LUSolver computes the correct results of a "
        "system of linear equations.", () async {
      final luSolver = LUSolver(equations: const [
        [7, -2, 1],
        [14, -7, -3],
        [-7, 11, 18]
      ], constants: const [
        12,
        17,
        5
      ]);

      // This is needed because we want to make sure that the "original" matrix
      // doesn't get side effects from the calculations (i.e. row swapping).
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [7, -2, 1],
          [14, -7, -3],
          [-7, 11, 18]
        ],
      );

      // Checking solutions
      final results = luSolver.solve();
      expect(results, unorderedEquals(<double>[-1, 4, 3]));

      // Checking the "state" of the object
      expect(luSolver.equations, equals(matrix));
      expect(luSolver.knownValues, orderedEquals(<double>[12, 17, 5]));
      expect(luSolver.precision, equals(1.0e-10));
      expect(luSolver.size, equals(3));
    });

    test(
        "Making sure that the LU decomposition properly doesn't work when "
        "the matrix is not square.", () async {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
        ],
      );

      // Decomposition
      // ignore: unnecessary_lambdas
      expect(() => matrix.luDecomposition(), throwsA(isA<MatrixException>()));
    });
  });
}
