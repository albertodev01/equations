import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix_utils.dart';

/// {@template lu_solver}
/// Solves a system of linear equations using the LU decomposition method.
///
/// The LU decomposition factors a square matrix A into the product of a lower
/// triangular matrix L and an upper triangular matrix U: A = LU. This allows
/// the system Ax = b to be solved in two steps:
///
/// 1. **Forward substitution**: Solve Ly = b for y
/// 2. **Back substitution**: Solve Ux = y for x
///
/// ## When to Use
///
/// LU decomposition is particularly useful when:
/// - You need to solve multiple systems with the same coefficient matrix A
/// - The matrix A is not symmetric positive-definite (use Cholesky instead)
/// - You want a direct method that doesn't require iteration
///
/// ## Requirements
///
/// The input matrix must be:
/// - Square (n×n)
/// - Non-singular (determinant ≠ 0)
/// - The matrix should not have zeros on the main diagonal after pivoting
///
/// ## Example
///
/// ```dart
/// final solver = LUSolver(
///   matrix: RealMatrix.fromData(
///     rows: 3,
///     columns: 3,
///     data: [
///       [2, 1, 1],
///       [4, -6, 0],
///       [-2, 7, 2],
///     ],
///   ),
///   knownValues: [5, -2, 9],
/// );
///
/// final solution = solver.solve();
/// // Returns: [1, 1, 2]
/// ```
/// {@endtemplate}
final class LUSolver extends SystemSolver with RealMatrixUtils {
  /// {@macro systems_constructor_intro}
  ///
  /// {@macro lu_solver}
  ///
  ///  - [matrix] is the matrix containing the equations;
  ///  - [knownValues] is the vector with the known values.
  LUSolver({required super.matrix, required super.knownValues});

  @override
  List<double> solve() {
    if (!hasSolution()) {
      throw const SystemSolverException(
        'The system has no solution: the matrix is singular (determinant = 0).',
      );
    }

    final lu = matrix.luDecomposition();
    final L = lu[0];
    final U = lu[1];
    final P = lu[2];

    // Apply permutation to known values: Pb
    final bPermuted = List<double>.generate(
      knownValues.length,
      (i) {
        // Find j such that P[i, j] = 1, then (Pb)[i] = b[j]
        for (var j = 0; j < knownValues.length; j++) {
          if (P(i, j) == 1.0) {
            return knownValues[j];
          }
        }
        return knownValues[i]; // fallback (shouldn't happen)
      },
      growable: false,
    );

    // Solving Ly = Pb
    final lList = L.toListOfList();
    final y = forwardSubstitution(lList, bPermuted);

    // Solving Ux = y
    final uList = U.toListOfList();

    return backSubstitution(uList, y);
  }
}
