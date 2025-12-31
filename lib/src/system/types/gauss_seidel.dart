import 'package:equations/equations.dart';

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
/// The method converges if the matrix is:
/// - Strictly diagonally dominant, or
/// - Symmetric positive-definite
///
/// For non-diagonally dominant matrices, convergence is not guaranteed but may
/// still occur.
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
/// ```
/// {@endtemplate}
final class GaussSeidelSolver extends SystemSolver {
  /// The maximum number of iterations to be made by the algorithm.
  ///
  /// If the algorithm doesn't converge within this number of iterations,
  /// it will return the best approximation found so far.
  final int maxSteps;

  /// {@macro systems_constructor_intro}
  ///
  /// {@macro gauss_seidel_solver}
  ///
  /// Parameters:
  ///   - [matrix] is the matrix containing the equations;
  ///   - [knownValues] is the vector with the known values;
  ///   - [precision] determines how accurate the algorithm has to be
  ///   - [maxSteps] the maximum number of iterations (defaults to `30`).
  GaussSeidelSolver({
    required super.matrix,
    required super.knownValues,
    super.precision,
    this.maxSteps = 30,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is GaussSeidelSolver) {
      return super == other && maxSteps == other.maxSteps;
    } else {
      return false;
    }
  }

  @override
  int get hashCode =>
      Object.hashAll([matrix, precision, ...knownValues, maxSteps]);

  @override
  List<double> solve() {
    // When 'w = 1', the SOR method simplifies to the Gauss-Seidel method.
    final sor = SORSolver(
      matrix: matrix,
      knownValues: knownValues,
      w: 1,
      precision: precision,
      maxSteps: maxSteps,
    );

    return sor.solve();
  }
}
