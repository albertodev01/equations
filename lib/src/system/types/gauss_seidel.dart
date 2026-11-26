import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/solver_utils.dart';

/// {@template gauss_seidel_solver}
/// Solves a system of linear equations using the Gauss-Seidel iterative method.
///
/// The Gauss-Seidel method is an iterative algorithm that solves the system
/// `Ax = b` by iteratively updating each component of the solution vector. It
/// uses the most recently computed values immediately, which typically leads
/// to faster convergence than the Jacobi method.
///
/// Gauss-Seidel is equivalent to the [SORSolver] with relaxation factor
/// `w = 1`. The SOR method generalizes Gauss-Seidel by introducing a relaxation
/// parameter.
///
/// ## Convergence
///
/// The method is guaranteed to converge if the matrix is:
/// - Strictly diagonally dominant, or
/// - Symmetric positive-definite
///
/// For other matrices, convergence is not guaranteed but may still occur. The
/// elements on the main diagonal must not be zero, because every step divides
/// by them.
///
/// The [solve] method stops when the largest change of a component between
/// two steps is at most `precision * max(1, m)`, where `m` is the largest
/// absolute value of a component. It throws a [SystemSolverException] if the
/// method diverges or doesn't converge within [maxSteps] steps.
///
/// ## When to Use
///
/// Gauss-Seidel is particularly effective for:
/// - Large, sparse systems
/// - Systems with diagonally dominant matrices
/// - When you need faster convergence than Jacobi but don't want to tune a
///   relaxation factor (use SOR if you need even faster convergence)
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
/// final solver = GaussSeidelSolver(
///   matrix: matrix,
///   knownValues: [1, 5, 0],
///   precision: 1.0e-10,
///   maxSteps: 50,
/// );
///
/// final solution = solver.solve();
/// // Returns: [0.625, 1.5, 0.375] (approximately)
/// ```
/// {@endtemplate}
final class GaussSeidelSolver extends SystemSolver {
  /// {@macro systems_constructor_intro}
  ///
  /// {@macro gauss_seidel_solver}
  ///
  /// Parameters:
  ///   - [matrix] is the matrix containing the equations;
  ///   - [knownValues] is the vector with the known values;
  ///   - [x0] is the initial guess (defaults to the zero vector);
  ///   - [precision] determines how accurate the algorithm has to be (defaults
  ///     to `1.0e-10`);
  ///   - [maxSteps] is the maximum number of iterations (defaults to `1000`).
  ///
  /// Throws a [SystemSolverException] if:
  ///   - The matrix is not square, or
  ///   - The length of [knownValues] or [x0] doesn't match the matrix size, or
  ///   - The matrix, [knownValues] or [x0] contain NaN or infinite values, or
  ///   - The matrix has a zero on its main diagonal, or
  ///   - [maxSteps] is smaller than 1.
  new({
    required super.matrix,
    required super.knownValues,
    List<double>? x0,
    super.precision,
    this.maxSteps = 1000,
  }) : x0 = x0 ?? List<double>.filled(knownValues.length, 0) {
    validateIterativeSolver(matrix: matrix, x0: this.x0, maxSteps: maxSteps);
  }

  /// The initial vector `x`, needed to start the algorithm.
  final List<double> x0;

  /// The maximum number of iterations to be made by the algorithm.
  ///
  /// If the algorithm doesn't converge within this number of iterations,
  /// [solve] throws a [SystemSolverException].
  final int maxSteps;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is GaussSeidelSolver) {
      return super == other &&
          maxSteps == other.maxSteps &&
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
    Object.hashAll(x0),
  );

  // When 'w = 1', the SOR method simplifies to the Gauss-Seidel method.
  @override
  List<double> solve() => sorIteration(
    matrix: matrix,
    knownValues: knownValues,
    x0: x0,
    w: 1,
    precision: precision,
    maxSteps: maxSteps,
    methodName: 'Gauss-Seidel method',
  );
}
