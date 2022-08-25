import 'package:equations/equations.dart';

/// Implementation of the "Gaussian elimination" algorithm, also known as "row
/// reduction", for solving a system of linear equations.
class GaussianElimination extends SystemSolver {
  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [matrix] is the matrix containing the equations;
  ///   - [knownValues] is the vector with the known values.
  ///
  /// Swaps rows/columns and uses back substitution to solve the system.
  GaussianElimination({
    required super.matrix,
    required super.knownValues,
    super.precision,
  });

  @override
  List<double> solve() {
    final n = knownValues.length;
    final A = matrix.toListOfList();
    final b = knownValues.toList();

    // Swapping rows and pivoting.
    for (var p = 0; p < n; ++p) {
      // Finding a pivot.
      var max = p;
      for (var i = p + 1; i < n; i++) {
        if (A[i][p].abs() > A[max][p].abs()) {
          max = i;
        }
      }

      // Swapping rows.
      final temp = A[p];
      A[p] = A[max];
      A[max] = temp;
      final t = b[p];
      b[p] = b[max];
      b[max] = t;

      // Making sure the matrix is not singular.
      if (A[p][p].abs() <= precision) {
        throw const SystemSolverException(
          'The matrix is singular or nearly singular.',
        );
      }

      // pivot within A and b.
      for (var i = p + 1; i < n; i++) {
        final alpha = A[i][p] / A[p][p];
        b[i] -= alpha * b[p];
        for (var j = p; j < n; j++) {
          A[i][j] -= alpha * A[p][j];
        }
      }
    }

    // Back substitution.
    return SystemSolver.backSubstitution(A, b);
  }
}
