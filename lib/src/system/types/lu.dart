import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix_utils.dart';
import 'package:equations/src/system/utils/solver_utils.dart';

/// {@template lu_solver}
/// Solves a system of linear equations using the LU decomposition method.
///
/// The LU decomposition with partial pivoting factors a square matrix `A` into
/// the product `PA = LU`, where `P` is a permutation matrix, `L` is a lower
/// triangular matrix with ones on the diagonal and `U` is an upper triangular
/// matrix. This allows the system `Ax = b` to be solved in two steps:
///
/// 1. **Forward substitution**: Solve `Ly = Pb` for `y`
/// 2. **Back substitution**: Solve `Ux = y` for `x`
///
/// The factorization is computed the first time it's needed and then reused,
/// so [solveFor] can solve other systems with the same matrix (and different
/// known values) in `O(n^2)` operations instead of `O(n^3)`.
///
/// ## When to Use
///
/// LU decomposition is particularly useful when:
/// - You need to solve multiple systems with the same coefficient matrix `A`
///   (see [solveFor])
/// - The matrix `A` is not symmetric positive-definite (otherwise, use
///   [CholeskySolver])
/// - You want a direct method that doesn't require iteration
///
/// ## Requirements
///
/// The input matrix must be square (`n x n`) and non-singular. The [solve]
/// and [solveFor] methods throw a [SystemSolverException] if the matrix is
/// singular or nearly singular.
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
///
/// // Reuses the factorization of the matrix
/// final other = solver.solveFor([4, -2, 7]);
/// // Returns: [1, 1, 1]
/// ```
/// {@endtemplate}
final class LUSolver extends SystemSolver with RealMatrixUtils {
  /// {@macro systems_constructor_intro}
  ///
  /// {@macro lu_solver}
  ///
  /// Parameters:
  ///   - [matrix] is the matrix containing the equations;
  ///   - [knownValues] is the vector with the known values;
  ///   - [precision] determines the tolerance for detecting singular matrices
  ///     (defaults to `1.0e-10`). An element on the diagonal of `U` is
  ///     considered zero when its absolute value is at most `precision` times
  ///     the largest absolute value in the matrix.
  new({
    required super.matrix,
    required super.knownValues,
    super.precision,
  });

  /// The `L` and `U` factors (as lists of rows) and the row permutation of
  /// `PA = LU`, computed once and reused by [solveFor].
  late final ({
    List<List<double>> lower,
    List<List<double>> upper,
    List<int> permutation,
  })
  _factors = _factorize();

  /// Computes the LU factorization of [matrix] and makes sure that the matrix
  /// is not singular.
  ({
    List<List<double>> lower,
    List<List<double>> upper,
    List<int> permutation,
  })
  _factorize() {
    final lu = matrix.luDecomposition();
    final upper = lu[1];
    final permutationMatrix = lu[2];
    final n = size;

    final tolerance = precision * maxAbsValue(matrix.flattenData);
    for (var i = 0; i < n; ++i) {
      if (upper(i, i).abs() <= tolerance) {
        throw const SystemSolverException(
          'The matrix is singular or nearly singular.',
        );
      }
    }
    final permutation = List<int>.generate(
      n,
      (i) => Iterable<int>.generate(
        n,
      ).firstWhere((j) => permutationMatrix(i, j) == 1),
      growable: false,
    );

    return (
      lower: lu.first.toListOfList(),
      upper: upper.toListOfList(),
      permutation: permutation,
    );
  }

  @override
  List<double> solve() => solveFor(knownValues);

  /// Solves the system `Ax = b`, where `A` is [matrix] and `b` is
  /// [knownValues], and returns the `x` vector.
  ///
  /// The LU factorization of [matrix] is computed only once, so calling this
  /// method many times with different known values is much faster than
  /// creating a new [LUSolver] for each of them.
  ///
  /// Throws a [SystemSolverException] if:
  ///   - The length of [knownValues] is not [size], or
  ///   - [knownValues] contains NaN or infinite values, or
  ///   - The matrix is singular or nearly singular.
  List<double> solveFor(List<double> knownValues) {
    if (knownValues.length != size) {
      throw const SystemSolverException(
        'The known values vector must have the same size as the matrix.',
      );
    }

    if (!knownValues.every((value) => value.isFinite)) {
      throw const SystemSolverException(
        'The known values vector must contain only finite values.',
      );
    }

    final factors = _factors;
    final permuted = factors.permutation
        .map((j) => knownValues[j])
        .toList(growable: false);

    // Ly = Pb
    final y = forwardSubstitution(factors.lower, permuted);
    // Ux = y
    return backSubstitution(factors.upper, y);
  }
}
