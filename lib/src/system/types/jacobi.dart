import 'dart:math' as math;

import 'package:equations/equations.dart';

/// {@template jacobi_solver}
/// Solves a system of linear equations using the Jacobi iterative method.
/// The given input matrix, representing the system of linear equations, must
/// be square.
///
/// This algorithm only works with strictly diagonally dominant systems of
/// equations.
///
/// The Jacobi method solves the system Ax = b by iteratively updating each
/// component x_i using the formula:
///   x_i^(k+1) = (b_i - Σ_{j≠i} a_{ij} * x_j^(k)) / a_{ii}
///
/// where k is the iteration number. The method converges if the matrix A
/// is strictly diagonally dominant, meaning |a_{ii}| > Σ_{j≠i} |a_{ij}| for all i.
///
/// Example:
/// ```dart
/// final solver = JacobiSolver(
///   matrix: RealMatrix.fromData(
///     rows: 2,
///     columns: 2,
///     data: [[4, 1], [1, 3]], // Diagonally dominant
///   ),
///   knownValues: [5, 4],
///   x0: [0, 0],
/// );
///
/// final solution = solver.solve();
/// print('Solution: $solution');
/// ```
/// {@endtemplate}
final class JacobiSolver extends SystemSolver {
  /// The initial vector `x`, needed to start the algorithm.
  final List<double> x0;

  /// The maximum number of iterations to be made by the algorithm.
  final int maxSteps;

  /// {@macro systems_constructor_intro}
  ///
  /// {@macro jacobi_solver}
  ///
  ///  - [matrix] is the matrix containing the equations;
  ///  - [knownValues] is the vector with the known values;
  ///  - [x0] is the initial guess (which is a vector);
  ///  - [precision] tells how accurate the algorithm has to be;
  ///  - [maxSteps] the maximum number of iterations the algorithm.
  ///
  /// The [matrix] `A` must be strictly diagonally dominant for guaranteed
  /// convergence. The method will check for zero diagonal elements and throw
  /// an exception if found, as this would cause division by zero.
  ///
  /// For non-diagonally dominant matrices, convergence is not guaranteed,
  /// but the method will still attempt to solve the system.
  factory JacobiSolver({
    required RealMatrix matrix,
    required List<double> knownValues,
    required List<double> x0,
    int maxSteps = 30,
    double precision = 1.0e-10,
  }) {
    // Validate that the initial guess vector has the correct size
    if (x0.length != knownValues.length) {
      throw const SystemSolverException(
        'The length of the guesses vector '
        'must match the size of the square matrix.',
      );
    }

    // Check for zero diagonal elements which would cause division by zero
    for (var i = 0; i < matrix.rowCount; ++i) {
      if (matrix(i, i) == 0) {
        throw const SystemSolverException(
          'The matrix has zero diagonal elements, which would cause division '
          'by zero in Jacobi method.',
        );
      }
    }

    // Check diagonal dominance for convergence guarantee
    if (!_isDiagonallyDominant(matrix)) {
      // Note: Non-diagonally dominant matrices may still converge,
      // but convergence is not guaranteed
    }

    return JacobiSolver._(
      matrix: matrix,
      knownValues: knownValues,
      x0: x0,
      maxSteps: maxSteps,
      precision: precision,
    );
  }

  /// Creates a [JacobiSolver] object.
  JacobiSolver._({
    required super.matrix,
    required super.knownValues,
    required this.x0,
    super.precision,
    this.maxSteps = 30,
  });

  /// Checks if the matrix is diagonally dominant.
  ///
  /// A matrix A is diagonally dominant if for each row i:
  ///   |a_{ii}| ≥ Σ_{j≠i} |a_{ij}|
  ///
  /// This is a sufficient (but not necessary) condition for the Jacobi method
  /// to converge. Strict diagonal dominance (|a_{ii}| > Σ_{j≠i} |a_{ij}|)
  /// guarantees convergence.
  static bool _isDiagonallyDominant(RealMatrix matrix) {
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
  /// This can be useful for users to check if Jacobi is likely to converge
  /// for their specific matrix.
  bool get isDiagonallyDominant => _isDiagonallyDominant(matrix);

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

  /// Solves the system and returns both the solution and convergence information.
  ///
  /// Returns a map containing:
  /// - 'solution': the solution vector
  /// - 'iterations': number of iterations performed
  /// - 'converged': whether the method converged within maxSteps
  /// - 'finalResidual': the residual norm of the final solution
  Map<String, dynamic> solveWithInfo() {
    var k = 0;
    var diff = precision + 1;

    final size = knownValues.length;
    final solutions = List<double>.from(x0);
    final oldSolutions = List<double>.generate(size, (_) => 0);

    while ((diff >= precision) && (k < maxSteps)) {
      for (var i = 0; i < size; ++i) {
        oldSolutions[i] = solutions[i];
      }

      for (var i = 0; i < size; ++i) {
        var sigma = 0.0;
        for (var j = 0; j < size; ++j) {
          if (i != j) {
            sigma += matrix(i, j) * oldSolutions[j];
          }
        }
        solutions[i] = (knownValues[i] - sigma) / matrix(i, i);
      }

      diff = 0.0;
      for (var i = 0; i < size; ++i) {
        final change = (solutions[i] - oldSolutions[i]).abs();
        if (change > diff) {
          diff = change;
        }
      }

      ++k;
    }

    final finalResidual = computeResidualNorm(solutions);

    return {
      'solution': solutions,
      'iterations': k,
      'converged': k < maxSteps,
      'finalResidual': finalResidual,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is JacobiSolver) {
      // The lengths of the coefficients must match.
      if (x0.length != other.x0.length) {
        return false;
      }

      for (var i = 0; i < x0.length; ++i) {
        if (x0[i] != other.x0[i]) {
          return false;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return super == other && maxSteps == other.maxSteps;
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
  /// Solves the system of linear equations using the Jacobi iterative method.
  ///
  /// The method iterates until either:
  /// - The maximum change in any component between iterations is less than [precision]
  /// - The maximum number of iterations [maxSteps] is reached
  ///
  /// Returns the solution vector x that satisfies Ax = b.
  List<double> solve() {
    // Exit conditions for the method.
    var k = 0;
    var diff = precision + 1;

    // Pre-allocate vectors for better performance
    final size = knownValues.length;
    final solutions = List<double>.from(x0);
    final oldSolutions = List<double>.generate(size, (_) => 0);

    // Jacobi iteration
    while ((diff >= precision) && (k < maxSteps)) {
      // Save current solution for convergence check
      for (var i = 0; i < size; ++i) {
        oldSolutions[i] = solutions[i];
      }

      // Update each component using Jacobi formula
      for (var i = 0; i < size; ++i) {
        var sigma = 0.0;

        // Sum of products with old values
        for (var j = 0; j < size; ++j) {
          if (i != j) {
            sigma += matrix(i, j) * oldSolutions[j];
          }
        }

        // Jacobi update formula
        solutions[i] = (knownValues[i] - sigma) / matrix(i, i);
      }

      // Compute convergence criterion: maximum change in any component
      diff = 0.0;
      for (var i = 0; i < size; ++i) {
        final change = (solutions[i] - oldSolutions[i]).abs();
        if (change > diff) {
          diff = change;
        }
      }

      ++k;
    }

    return solutions;
  }
}
