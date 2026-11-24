import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/solver_utils.dart';

/// {@template gaussian_elimination}
/// Solves a system of linear equations using the Gaussian elimination
/// algorithm, also known as row reduction.
///
/// Gaussian elimination is a direct method that transforms the system `Ax = b`
/// into an upper triangular form through a series of row operations, then
/// solves the system using back substitution. This implementation uses
/// partial pivoting to improve numerical stability: at each step, the rows are
/// swapped so that the pivot is the element with the largest absolute value in
/// its column (below the diagonal).
///
/// ## When to Use
///
/// Gaussian elimination is a general-purpose solver that works for any
/// non-singular square matrix. It's particularly useful when:
///
/// - You need a direct method (no iteration required)
/// - The matrix isn't symmetric positive-definite (see [CholeskySolver]
///   instead)
/// - You only need to solve one system (use [LUSolver.solveFor] to solve
///   multiple systems with the same matrix)
/// - You want a straightforward, well-understood algorithm
///
/// ## Example
///
/// ```dart
/// final matrix = RealMatrix.fromData(
///   rows: 3,
///   columns: 3,
///   data: [
///     [2, 1, 1],
///     [4, -6, 0],
///     [-2, 7, 2],
///   ],
/// );
///
/// final solver = GaussianElimination(
///   matrix: matrix,
///   knownValues: [5, -2, 9],
/// );
///
/// final solution = solver.solve();
/// // Returns: [1, 1, 2]
/// ```
/// {@endtemplate}
final class GaussianElimination extends SystemSolver {
  /// {@macro systems_constructor_intro}
  ///
  /// {@macro gaussian_elimination}
  ///
  /// Parameters:
  ///   - [matrix] is the matrix containing the equations;
  ///   - [knownValues] is the vector with the known values;
  ///   - [precision] determines the tolerance for detecting singular matrices
  ///     (defaults to `1.0e-10`). A pivot is considered zero when its absolute
  ///     value is at most `precision` times the largest absolute value in the
  ///     matrix.
  ///
  /// The [solve] method throws a [SystemSolverException] if the matrix is
  /// singular or nearly singular.
  new({
    required super.matrix,
    required super.knownValues,
    super.precision,
  });

  @override
  List<double> solve() {
    final n = size;
    final a = matrix.flattenData.toList(growable: false);
    final b = knownValues.toList(growable: false);
    final tolerance = precision * maxAbsValue(a);

    // Forward elimination with partial pivoting
    for (var p = 0; p < n; ++p) {
      var pivotRow = p;
      var pivotAbs = a[n * p + p].abs();
      for (var i = p + 1; i < n; ++i) {
        final value = a[n * i + p].abs();
        if (value > pivotAbs) {
          pivotAbs = value;
          pivotRow = i;
        }
      }

      if (pivotAbs <= tolerance) {
        throw const SystemSolverException(
          'The matrix is singular or nearly singular.',
        );
      }

      if (pivotRow != p) {
        for (var j = p; j < n; ++j) {
          final temp = a[n * p + j];
          a[n * p + j] = a[n * pivotRow + j];
          a[n * pivotRow + j] = temp;
        }

        final temp = b[p];
        b[p] = b[pivotRow];
        b[pivotRow] = temp;
      }

      final pivot = a[n * p + p];
      for (var i = p + 1; i < n; ++i) {
        final factor = a[n * i + p] / pivot;
        if (factor == 0) {
          continue;
        }

        b[i] -= factor * b[p];
        for (var j = p + 1; j < n; ++j) {
          a[n * i + j] -= factor * a[n * p + j];
        }
      }
    }

    final solutions = List<double>.filled(n, 0);
    for (var i = n - 1; i >= 0; --i) {
      var sum = b[i];
      for (var j = i + 1; j < n; ++j) {
        sum -= a[n * i + j] * solutions[j];
      }
      solutions[i] = sum / a[n * i + i];
    }

    return solutions;
  }
}
