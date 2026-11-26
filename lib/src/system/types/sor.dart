import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/solver_utils.dart';

/// {@template sor_solver}
/// Solves a system of linear equations using the Successive Over-Relaxation
/// (SOR) iterative method.
///
/// A theorem due to Kahan (1958) shows that SOR fails to converge if `w` is not
/// in the (0, 2) range. The optimal value of `w` depends on the spectral radius
/// of the iteration matrix:
///
/// - For `w = 1`: SOR reduces to the Gauss-Seidel method
/// - For `0 < w < 1`: Under-relaxation (slower convergence, more stable)
/// - For `1 < w < 2`: Over-relaxation (faster convergence when `w` is close to
///   the optimal value, slower when it's too large)
///
/// The method is guaranteed to converge for any `w` in (0, 2) if the matrix is
/// symmetric positive-definite. The elements on the main diagonal must not be
/// zero, because every step divides by them.
///
/// ## When to use
///
/// SOR is particularly effective for:
/// - Large, sparse systems
/// - Systems with diagonally dominant matrices
/// - When you need faster convergence than Gauss-Seidel
///
/// ## Example
///
/// ```dart
/// final matrix = RealMatrix.fromData(
///   rows: 3,
///   columns: 3,
///   data: [
///     [4, -1, 0],
///     [-1, 4, -1],
///     [0, -1, 4],
///   ],
/// );
///
/// final sor = SORSolver(
///   matrix: matrix,
///   knownValues: [1, 5, 0],
///   w: 1.03, // Close to the optimal relaxation factor for this matrix
///   precision: 1.0e-10,
///   maxSteps: 50,
/// );
///
/// final solution = sor.solve();
/// // Returns: [0.625, 1.5, 0.375] (approximately)
/// ```
/// {@endtemplate}
final class SORSolver extends SystemSolver {
  /// {@macro systems_constructor_intro}
  ///
  /// {@macro sor_solver}
  ///
  /// Parameters:
  ///   - [matrix] is the matrix containing the equations;
  ///   - [knownValues] is the vector with the known values;
  ///   - [w] is the relaxation factor (must be in the (0, 2) range);
  ///   - [x0] is the initial guess (defaults to the zero vector);
  ///   - [precision] determines how accurate the algorithm has to be (defaults
  ///     to `1.0e-10`);
  ///   - [maxSteps] is the maximum number of iterations (defaults to `1000`).
  ///
  /// The [solve] method stops when the largest change of a component between
  /// two steps is at most `precision * max(1, m)`, where `m` is the largest
  /// absolute value of a component. It throws a [SystemSolverException] if
  /// the method diverges or doesn't converge within [maxSteps] steps.
  ///
  /// Throws a [SystemSolverException] if:
  ///   - The matrix is not square, or
  ///   - The length of [knownValues] or [x0] doesn't match the matrix size, or
  ///   - The matrix, [knownValues] or [x0] contain NaN or infinite values, or
  ///   - [w] is not in the (0, 2) range, or
  ///   - The matrix has a zero on its main diagonal, or
  ///   - [maxSteps] is smaller than 1.
  new({
    required super.matrix,
    required super.knownValues,
    required this.w,
    List<double>? x0,
    super.precision,
    this.maxSteps = 1000,
  }) : x0 = x0 ?? List<double>.filled(knownValues.length, 0) {
    if (!(w > 0 && w < 2)) {
      throw const SystemSolverException(
        'The relaxation factor w must be in the range (0, 2) for convergence.',
      );
    }

    validateIterativeSolver(matrix: matrix, x0: this.x0, maxSteps: maxSteps);
  }

  /// The relaxation factor `w` (omega) that controls the convergence rate.
  ///
  /// The value must be in the range (0, 2) for convergence:
  /// - `w = 1`: Equivalent to Gauss-Seidel method
  /// - `0 < w < 1`: Under-relaxation (slower but more stable)
  /// - `1 < w < 2`: Over-relaxation (faster when close to the optimal value)
  ///
  /// The optimal value depends on the spectral radius of the iteration matrix.
  final double w;

  /// The initial vector `x`, needed to start the algorithm.
  final List<double> x0;

  /// The maximum number of iterations to be made by the algorithm.
  ///
  /// If the algorithm doesn't converge within this number of iterations,
  /// [solve] throws a [SystemSolverException].
  final int maxSteps;

  /// Returns whether the matrix is (weakly) diagonally dominant.
  ///
  /// See [SystemSolver.isDiagonallyDominant]. Strict diagonal dominance
  /// guarantees that SOR converges with `w = 1` (the Gauss-Seidel method), but
  /// not for every value of [w].
  bool isDiagonallyDominant() => SystemSolver.isDiagonallyDominant(matrix);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is SORSolver) {
      return super == other &&
          maxSteps == other.maxSteps &&
          w == other.w &&
          sameValues(x0, other.x0);
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
    matrix,
    Object.hashAll(knownValues),
    precision,
    maxSteps,
    w,
    Object.hashAll(x0),
  );

  @override
  List<double> solve() => sorIteration(
    matrix: matrix,
    knownValues: knownValues,
    x0: x0,
    w: w,
    precision: precision,
    maxSteps: maxSteps,
    methodName: 'SOR method',
  );
}
