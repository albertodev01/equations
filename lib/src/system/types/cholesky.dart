import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:equations/src/system/system.dart';

/// Implementation of the "Cholesky decomposition" algorithm for solving a
/// system of linear equations. It only works with Hermitian, positive-definite
/// matrices.
class CholeskyDecomposition extends SystemSolver {
  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [equations] is the matrix containing the equations
  ///   - [constants] is the vector with the known values
  ///
  /// The matrix must be Hermitian and positive-definite.
  CholeskyDecomposition({
    required List<List<double>> equations,
    required List<double> constants,
  }) : super(A: equations, b: constants, size: constants.length);

  /// TODO
  List<List<double>> decompose() {
    // Starting the method
    final L = List<List<double>>.generate(size, (row) {
      return List<double>.generate(size, (col) => 0);
    }, growable: false);

    L[0][0] = math.sqrt(equations(0, 0));

    for (var i = 1; i < size; ++i) {
      L[i][0] = equations(i, 0) / L[1][1];
    }

    for (var j = 1; j < size; ++j) {
      L[j][j] = equations(j, j);

      for (var k = 0; k < j - 1; ++k) {
        L[j][j] -= L[j][k] * L[j][k];
      }

      if (L[j][j] <= 0) {
        throw const SystemSolverException("Couldn't complete the decomposition "
            "because the square root of a negative number has been found.");
      }

      L[j][j] = math.sqrt(L[j][j]);

      for (var i = j + 1; i < size; ++i) {
        L[i][j] = equations(i, j);
        for (var k = 0; k < j - 1; ++k) {
          L[i][j] -= L[i][k] * L[j][k];
        }
        L[i][j] = L[i][j] / L[j][j];
      }
    }

    return L;
  }

  @override
  List<double> solve() {
    final solutions = <double>[];

    // Exit immediately if the matrix doesn't satisfy the initial conditions
    if (equations(0, 0) <= 0) {
      throw const SystemSolverException("The matrix is not positive-definite.");
    }

    // Returning the results
    return solutions;
  }
}
