import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'CholeskyDecomposition' class.", () {
    test(
        "Making sure that Cholesky decomposition properly works on a square "
        "matrix of a given dimension.", () async {
      final matrix = RealMatrix.fromData(rows: 3, columns: 3, data: const [
        [25, 15, -5],
        [15, 18, 0],
        [-5, 0, 11]
      ]);

      // Decomposition
      final cholesky = matrix.choleskyDecomposition();
      expect(cholesky.length, equals(2));

      // Checking L
      final L = cholesky[0];
      expect(
          L.flattenData, orderedEquals(<double>[5, 0, 0, 3, 3, 0, -1, 1, 3]));
      expect(L.rowCount, equals(matrix.rowCount));
      expect(L.columnCount, equals(matrix.columnCount));
      expect(L.isSquareMatrix, isTrue);

      // Checking Lt
      final transposedL = cholesky[1];
      expect(transposedL.flattenData,
          orderedEquals(<double>[5, 3, -1, 0, 3, 1, 0, 0, 3]));
      expect(transposedL.rowCount, equals(matrix.rowCount));
      expect(transposedL.columnCount, equals(matrix.columnCount));
      expect(transposedL.isSquareMatrix, isTrue);
    });

    test(
        "Making sure that the CholeskySolver computes the correct results of a "
        "system of linear equations.", () async {
      final choleskySolver = CholeskySolver(equations: const [
        [6, 15, 55],
        [15, 55, 255],
        [55, 225, 979]
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
          [55, 225, 979]
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
  });
}
