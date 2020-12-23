import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'CholeskyDecomposition' class.", () {
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
