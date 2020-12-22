import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'LUDecomposition' class.", () {
    test("Making sure that the LU decomp. of a matrix is correct.", () async {
      final lu = LUDecomposition(equations: const [
        [4, 3],
        [6, 3]
      ], constants: [
        1,
        -3
      ]);

      final sol = lu.decompose();

      expect(sol.length, equals(2));
      expect(sol[0].flattenData, orderedEquals(<double>[1, 0, 1.5, 1]));
      expect(sol[1].flattenData, orderedEquals(<double>[4, 3, 0, -1.5]));
    });
  });
}
