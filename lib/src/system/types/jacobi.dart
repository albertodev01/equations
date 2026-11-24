import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/solver_utils.dart';

/// {@template jacobi_solver}
/// Solves a system of linear equations using the Jacobi iterative method.
/// The given input matrix, representing the system of linear equations, must
/// be square.
///
/// At each step, every component of the solution is computed from the
/// components of the previous step only.
///
/// ## Convergence
///
/// The method is guaranteed to converge if the [matrix] `A` is strictly
/// diagonally dominant. This is a sufficient condition, not a necessary one:
/// the method may converge for other matrices too. The elements on the main
/// diagonal must not be zero, because every step divides by them.
///
/// The [solve] method stops when the largest change of a component between
/// two steps is at most `precision * max(1, m)`, where `m` is the largest
/// absolute value of a component. It throws a [SystemSolverException] if the
/// method diverges or doesn't converge within [maxSteps] steps.
///
/// Example:
///
/// ```dart
/// final solver = JacobiSolver(
///   matrix: RealMatrix.fromData(
///     rows: 2,
///     columns: 2,
///     data: [[4, 1], [1, 3]], // Strictly diagonally dominant
///   ),
///   knownValues: [5, 4],
///   x0: [0, 0],
/// );
///
/// final solution = solver.solve();
/// // Returns: [1, 1] (approximately)
/// ```
/// {@endtemplate}
final class JacobiSolver extends SystemSolver {
  /// {@macro systems_constructor_intro}
  ///
  /// {@macro jacobi_solver}
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

  /// Returns whether the matrix is (weakly) diagonally dominant.
  ///
  /// See [SystemSolver.isDiagonallyDominant]. Only strict diagonal dominance
  /// guarantees that the Jacobi method converges.
  bool isDiagonallyDominant() => SystemSolver.isDiagonallyDominant(matrix);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is JacobiSolver) {
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

  @override
  List<double> solve() {
    const methodName = 'Jacobi method';
    final n = size;
    final a = matrix.flattenData;

    // Two buffers, swapped after each step: the new components are computed
    // from the previous ones only.
    var current = List<double>.of(x0, growable: false);
    var next = List<double>.filled(n, 0);

    for (var step = 0; step < maxSteps; ++step) {
      var maxChange = 0.0;
      var maxValue = 0.0;

      for (var i = 0; i < n; ++i) {
        final row = n * i;
        var sigma = 0.0;
        for (var j = 0; j < n; ++j) {
          if (j != i) {
            sigma += a[row + j] * current[j];
          }
        }

        final updated = (knownValues[i] - sigma) / a[row + i];
        maxChange = math.max(maxChange, (updated - current[i]).abs());
        maxValue = math.max(maxValue, updated.abs());
        next[i] = updated;
      }

      final previous = current;
      current = next;
      next = previous;

      if (hasConverged(
        maxChange: maxChange,
        maxValue: maxValue,
        precision: precision,
        methodName: methodName,
      )) {
        return current;
      }
    }

    throw notConvergedException(methodName, maxSteps);
  }
}
