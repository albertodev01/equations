import 'package:equations/equations.dart';

/// TODO
class LUDecomposition extends SystemSolver {
  /// TODO
  LUDecomposition({
    required List<List<double>> equations,
    required List<double> constants,
  }) : super(A: equations, b: constants, size: constants.length);

  /// TODO
  List<RealMatrix> decompose() {
    // Creating L and U matrices
    final L = List<List<double>>.generate(size, (row) {
      return List<double>.generate(size, (col) => 0);
    }, growable: false);
    final U = List<List<double>>.generate(size, (row) {
      return List<double>.generate(size, (col) => 0);
    }, growable: false);

    // Computing L and U
    for (var i = 0; i < size; ++i) {
      for (var k = i; k < size; k++) {
        // Summation of L(i, j) * U(j, k)
        var sum = 0.0;
        for (var j = 0; j < i; j++) {
          sum += (L[i][j] * U[j][k]);
        }

        // Evaluating U(i, k)
        U[i][k] = equations(i, k) - sum;
      }

      // Lower Triangular
      for (var k = i; k < size; k++) {
        if (i == k) {
          L[i][i] = 1; // Diagonal as 1
        } else {
          // Summation of L(k, j) * U(j, i)
          var sum = 0.0;
          for (var j = 0; j < i; j++) sum += (L[k][j] * U[j][i]);

          // Evaluating L(k, i)
          L[k][i] = (equations(k, i) - sum) / U[i][i];
        }
      }
    }

    return [
      RealMatrix.fromData(rows: size, columns: size, data: L),
      RealMatrix.fromData(rows: size, columns: size, data: U),
    ];
  }

  @override
  List<double> solve() {
    return [];
  }
}
