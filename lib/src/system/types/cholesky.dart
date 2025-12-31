import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix_utils.dart';

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
/// - You need the fastest direct method (approximately twice as fast as LU)
/// - The matrix comes from a covariance matrix, normal equations, or similar
///   applications that naturally produce positive-definite matrices
///
/// ## Requirements
///
/// The input matrix must be:
/// - Square (n×n)
/// - Symmetric (A = A^T)
/// - Positive-definite (all eigenvalues > 0, or equivalently, x^T A x > 0 for
///   all x ≠ 0)
///
/// If the matrix is not positive-definite, a [SystemSolverException] will be
/// thrown during decomposition.
///
/// ## Performance
///
/// When applicable, the Cholesky decomposition is almost twice as efficient as
/// the LU decomposition for solving linear systems, making it the preferred
/// method for symmetric positive-definite matrices.
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
  ///     to `1.0e-10`).
  ///
  /// Throws a [SystemSolverException] if:
  ///   - The matrix is not square, or
  ///   - The matrix is not symmetric positive-definite.
  CholeskySolver({
    required super.matrix,
    required super.knownValues,
    super.precision,
  });

  @override
  List<double> solve() {
    final cholesky = matrix.choleskyDecomposition();

    // Solving Ly = b
    final L = cholesky.first.toListOfList();
    final b = knownValues;
    final y = forwardSubstitution(L, b);

    // Solving L^T x = y (where L^T is the transpose of L)
    final transposedL = cholesky[1].toListOfList();

    return backSubstitution(transposedL, y);
  }
}
