import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix_utils.dart';

/// {@template gaussian_elimination}
/// Solves a system of linear equations using the Gaussian elimination
/// algorithm, also known as row reduction.
///
/// Gaussian elimination is a direct method that transforms the system `Ax = b`
/// into an upper triangular form through a series of row operations, then
/// solves the system using back substitution. This implementation uses
/// partial pivoting to improve numerical stability by selecting the largest
/// pivot element in each column.
///
/// ## When to Use
///
/// Gaussian elimination is a general-purpose solver that works for any
/// non-singular square matrix. It's particularly useful when:
///
/// - You need a direct method (no iteration required)
/// - The matrix isn't symmetric positive-definite (see[CholeskySolver] instead)
/// - You only need to solve one system (use [LUSolver] for multiple systems)
/// - You want a straightforward, well-understood algorithm
///
/// ## Performance Optimizations
///
/// This implementation is optimized for performance with the following
/// improvements:
///
/// - Uses flattened arrays for better cache locality
/// - Avoids unnecessary matrix copying
/// - Implements early termination for singular matrices
/// - Uses efficient memory access patterns
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
final class GaussianElimination extends SystemSolver with RealMatrixUtils {
  /// {@macro systems_constructor_intro}
  ///
  /// {@macro gaussian_elimination}
  ///
  /// Parameters:
  ///   - [matrix] is the matrix containing the equations
  ///   - [knownValues] is the vector with the known values;
  ///   - [precision] determines the tolerance for detecting singular matrices
  ///     (defaults to `1.0e-10`).
  ///
  /// The algorithm uses partial pivoting to swap rows/columns and back substitution
  /// to solve the system. Throws a [SystemSolverException] if the matrix is
  /// singular or nearly singular.
  GaussianElimination({
    required super.matrix,
    required super.knownValues,
    super.precision,
  });

  @override
  List<double> solve() {
    final n = knownValues.length;

    // Use flattened arrays for better cache performance
    final A = matrix.flattenData.toList(growable: false);
    final b = knownValues.toList(growable: false);

    // Row permutation array to track row swaps
    final pivot = List<int>.generate(n, (i) => i, growable: false);

    // Forward elimination with partial pivoting
    for (var p = 0; p < n; ++p) {
      // Find pivot with maximum absolute value in current column
      var maxRow = p;
      var maxVal = A[p * n + p].abs();

      for (var i = p + 1; i < n; i++) {
        final val = A[i * n + p].abs();
        if (val > maxVal) {
          maxVal = val;
          maxRow = i;
        }
      }

      // Early termination if matrix is singular
      if (maxVal <= precision) {
        throw const SystemSolverException(
          'The matrix is singular or nearly singular.',
        );
      }

      // Swap rows if necessary
      if (maxRow != p) {
        // Swap pivot array
        final tempPivot = pivot[p];
        pivot[p] = pivot[maxRow];
        pivot[maxRow] = tempPivot;

        // Swap matrix rows
        for (var j = 0; j < n; j++) {
          final temp = A[p * n + j];
          A[p * n + j] = A[maxRow * n + j];
          A[maxRow * n + j] = temp;
        }

        // Swap vector elements
        final temp = b[p];
        b[p] = b[maxRow];
        b[maxRow] = temp;
      }

      // Cache the pivot element to avoid repeated access
      final pivotElement = A[p * n + p];

      // Eliminate column below pivot
      for (var i = p + 1; i < n; i++) {
        final alpha = A[i * n + p] / pivotElement;

        // Early termination if elimination factor is too large (numerical
        // instability)
        if (alpha.abs() > 1e6) {
          throw const SystemSolverException(
            'Numerical instability detected during elimination.',
          );
        }

        b[i] -= alpha * b[p];

        // Eliminate elements in current row
        for (var j = p; j < n; j++) {
          A[i * n + j] -= alpha * A[p * n + j];
        }
      }
    }

    // Back substitution using flattened array
    return _backSubstitutionOptimized(A, b, n);
  }

  /// Optimized back substitution that works with flattened arrays
  List<double> _backSubstitutionOptimized(
    List<double> A,
    List<double> b,
    int n,
  ) {
    final solutions = List<double>.generate(n, (_) => 0, growable: false);

    for (var i = n - 1; i >= 0; --i) {
      solutions[i] = b[i];
      for (var j = i + 1; j < n; ++j) {
        solutions[i] -= A[i * n + j] * solutions[j];
      }

      // Check for division by zero
      if (A[i * n + i].abs() <= precision) {
        throw const SystemSolverException(
          'Singular matrix detected during back substitution.',
        );
      }

      solutions[i] /= A[i * n + i];
    }

    return solutions;
  }
}
