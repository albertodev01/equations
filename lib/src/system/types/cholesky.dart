import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix_utils.dart';
import 'package:equations/src/system/utils/solver_utils.dart';

/// {@template cholesky_solver}
/// Solves a system of linear equations using the Cholesky decomposition method.
///
/// The Cholesky decomposition factors a symmetric positive-definite matrix `A`
/// into the product of a lower triangular matrix `L` and its transpose:
/// `A = LL^T`. This allows the system `Ax = b` to be solved in two steps:
///
/// 1. **Forward substitution**: Solve `Ly = b` for `y`
/// 2. **Back substitution**: Solve `L^T x = y` for `x`
///
/// Cholesky decomposition is particularly useful when:
///
/// - The matrix `A` is symmetric and positive-definite
/// - You need the fastest direct method (when applicable, it needs about half
///   the operations of the LU decomposition)
/// - The matrix comes from a covariance matrix, normal equations, or similar
///   applications that naturally produce positive-definite matrices
///
/// ## Requirements
///
/// The input matrix must be:
/// - Square (`n x n`)
/// - Symmetric (`A = A^T`)
/// - Positive-definite (all eigenvalues > 0, or equivalently, `x^T A x > 0`
///   for all `x != 0`)
///
/// The constructor throws a [SystemSolverException] if the matrix is not
/// square or not symmetric. The [solve] method throws a
/// [SystemSolverException] if the matrix is not positive-definite.
///
/// ## Example
///
/// ```dart
/// final matrix = RealMatrix.fromData(
///   rows: 3,
///   columns: 3,
///   data: [
///     [4, 12, -16],
///     [12, 37, -43],
///     [-16, -43, 98],
///   ],
/// ); // Symmetric positive-definite matrix
///
/// final solver = CholeskySolver(
///   matrix: matrix,
///   knownValues: [1, 2, 3],
/// );
///
/// final solution = solver.solve();
/// // Returns: [28.5833..., -7.6666..., 1.3333...]
/// ```
/// {@endtemplate}
final class CholeskySolver extends SystemSolver with RealMatrixUtils {
  /// {@macro systems_constructor_intro}
  ///
  /// {@macro cholesky_solver}
  ///
  /// Parameters:
  ///   - [matrix] is the matrix containing the equations (must be symmetric
  ///     positive-definite);
  ///   - [knownValues] is the vector with the known values;
  ///   - [precision] determines the tolerance for numerical checks (defaults
  ///     to `1.0e-10`). Let `m` be the largest absolute value in the matrix:
  ///     the matrix is considered symmetric when `|a(i, j) - a(j, i)|` is at
  ///     most `precision * m` for every `i` and `j`, and nearly singular when
  ///     the square of an element on the diagonal of `L` is at most
  ///     `precision * m`.
  ///
  /// Throws a [SystemSolverException] if:
  ///   - The matrix is not square, or
  ///   - The matrix is not symmetric.
  new({
    required super.matrix,
    required super.knownValues,
    super.precision,
  }) {
    final n = size;
    final tolerance = precision * maxAbsValue(matrix.flattenData);

    for (var i = 0; i < n; ++i) {
      for (var j = i + 1; j < n; ++j) {
        if ((matrix(i, j) - matrix(j, i)).abs() > tolerance) {
          throw const SystemSolverException('The matrix must be symmetric.');
        }
      }
    }
  }

  @override
  List<double> solve() {
    final cholesky = matrix.choleskyDecomposition();
    final lower = cholesky.first;

    final tolerance = precision * maxAbsValue(matrix.flattenData);
    for (var i = 0; i < size; ++i) {
      final diagonal = lower(i, i);
      if (diagonal * diagonal <= tolerance) {
        throw const SystemSolverException(
          'The matrix is singular or nearly singular.',
        );
      }
    }

    // Ly = b
    final y = forwardSubstitution(lower.toListOfList(), knownValues);
    // L^T x = y
    return backSubstitution(cholesky[1].toListOfList(), y);
  }
}
