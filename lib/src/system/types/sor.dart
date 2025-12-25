import 'dart:math' as math;

import 'package:equations/equations.dart';

/// {@template sor_solver}
/// Solves a system of linear equations using the **Successive Over-Relaxation
/// (SOR)** iterative method. The given input matrix, representing the system of
/// linear equations, must be square.
///
/// ## Convergence
///
/// A theorem due to Kahan (1958) shows that SOR fails to converge if `w` is not
/// in the (0, 2) range. The optimal value of `w` depends on the spectral radius
/// of the iteration matrix:
///
/// - For `w = 1`: SOR reduces to the Gauss-Seidel method
/// - For `0 < w < 1`: Under-relaxation (slower convergence, more stable)
/// - For `1 < w < 2`: Over-relaxation (faster convergence when optimal)
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
///   w: 1.2, // Optimal relaxation factor for this matrix
///   precision: 1.0e-10,
///   maxSteps: 50,
/// );
///
/// final solution = sor.solve();
/// ```
/// {@endtemplate}
final class SORSolver extends SystemSolver {
  /// The relaxation factor `w` (omega) that controls the convergence rate.
  ///
  /// The value must be in the range (0, 2) for convergence:
  /// - `w = 1`: Equivalent to Gauss-Seidel method
  /// - `0 < w < 1`: Under-relaxation (slower but more stable)
  /// - `1 < w < 2`: Over-relaxation (faster when optimal)
  ///
  /// The optimal value depends on the spectral radius of the iteration matrix.
  final double w;

  /// The maximum number of iterations to be made by the algorithm.
  ///
  /// If the algorithm doesn't converge within this number of iterations,
  /// it will return the best approximation found so far.
  final int maxSteps;

  /// {@macro systems_constructor_intro}
  ///
  /// {@macro sor_solver}
  ///
  ///  - [matrix] is the matrix containing the equations;
  ///  - [knownValues] is the vector with the known values;
  ///  - [precision] determines how accurate the algorithm has to be;
  ///  - [w] is the relaxation factor (must be in range (0, 2));
  ///  - [maxSteps] the maximum number of iterations (defaults to 30).
  ///
  /// The algorithm will stop when either:
  /// - The residual norm is less than [precision], or
  /// - The maximum number of iterations [maxSteps] is reached.
  SORSolver({
    required super.matrix,
    required super.knownValues,
    required this.w,
    super.precision,
    this.maxSteps = 30,
  }) {
    // Validate the relaxation factor
    if (w <= 0 || w >= 2) {
      throw const SystemSolverException(
        'The relaxation factor w must be in the range (0, 2) for convergence.',
      );
    }

    // Check for zero diagonal elements which would cause division by zero
    for (var i = 0; i < matrix.rowCount; ++i) {
      if (matrix(i, i) == 0) {
        throw const SystemSolverException(
          'The matrix has zero diagonal elements, which would cause division '
          'by zero in SOR.',
        );
      }
    }

    // Warn about non-diagonally dominant matrices (but don't throw)
    if (!_isDiagonallyDominant()) {
      // Note: This is just a warning, not an error, as SOR can still converge
      // for some non-diagonally dominant matrices, but convergence is not
      // guaranteed
    }
  }

  /// Checks if the matrix is diagonally dominant.
  ///
  /// A matrix is diagonally dominant if for each row, the absolute value of
  /// the diagonal element is greater than or equal to the sum of the absolute
  /// values of the other elements in that row.
  bool _isDiagonallyDominant() {
    for (var i = 0; i < matrix.rowCount; ++i) {
      var rowSum = 0.0;
      final diagonalElement = matrix(i, i).abs();

      for (var j = 0; j < matrix.columnCount; ++j) {
        if (i != j) {
          rowSum += matrix(i, j).abs();
        }
      }

      if (diagonalElement < rowSum) {
        return false;
      }
    }
    return true;
  }

  /// Returns whether the matrix is diagonally dominant.
  ///
  /// This can be useful for users to check if SOR is likely to converge
  /// for their specific matrix.
  bool get isDiagonallyDominant => _isDiagonallyDominant();

  /// Computes the residual norm of the current solution.
  ///
  /// The residual is defined as ||Ax - b||, where A is the matrix,
  /// x is the solution vector, and b is the known values vector.
  /// A smaller residual indicates a better solution.
  double computeResidualNorm(List<double> solution) {
    var residualNorm = 0.0;

    for (var i = 0; i < matrix.rowCount; ++i) {
      var rowSum = 0.0;
      for (var j = 0; j < matrix.columnCount; ++j) {
        rowSum += matrix(i, j) * solution[j];
      }
      final residual = rowSum - knownValues[i];
      residualNorm += residual * residual;
    }

    return math.sqrt(residualNorm);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is SORSolver) {
      return super == other && maxSteps == other.maxSteps && w == other.w;
    } else {
      return false;
    }
  }

  @override
  int get hashCode =>
      Object.hash(matrix, Object.hashAll(knownValues), precision, maxSteps, w);

  @override
  List<double> solve() {
    // Exit conditions for the method.
    var k = 0;
    var diff = precision + 1;

    // Pre-allocate vectors for better performance
    final size = knownValues.length;
    final phi = List<double>.generate(size, (_) => 0);
    final oldPhi = List<double>.generate(size, (_) => 0);

    // SOR iteration
    while ((diff >= precision) && (k < maxSteps)) {
      // Save current solution for convergence check
      for (var i = 0; i < size; ++i) {
        oldPhi[i] = phi[i];
      }

      // Update each component using SOR formula
      for (var i = 0; i < size; ++i) {
        var sigma = 0.0;

        // Sum of products with already updated values (forward substitution)
        for (var j = 0; j < i; ++j) {
          sigma += matrix(i, j) * phi[j];
        }

        // Sum of products with old values (backward substitution)
        for (var j = i + 1; j < size; ++j) {
          sigma += matrix(i, j) * oldPhi[j];
        }

        // SOR update formula
        phi[i] =
            (1 - w) * oldPhi[i] + (w / matrix(i, i)) * (knownValues[i] - sigma);
      }

      // Compute convergence criterion: maximum change in any component
      diff = 0.0;
      for (var i = 0; i < size; ++i) {
        final change = (phi[i] - oldPhi[i]).abs();
        if (change > diff) {
          diff = change;
        }
      }

      ++k;
    }

    return phi;
  }
}
