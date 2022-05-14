import 'dart:math' as math;
import 'package:equations/equations.dart';

/// Solves a system of linear equations using the Jacobi iterative method.
/// The given input matrix, representing the system of linear equations, must
/// be square.
///
/// This algorithm only works with strictly diagonally dominant systems of
/// equations.
class JacobiSolver extends SystemSolver {
  /// The initial guess `x` (a vector) needed to start the algorithm.
  final List<double> x0;

  /// The maximum number of iterations to be made by the algorithm.
  final int maxSteps;

  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [equations] is the matrix containing the equations
  ///   - [constants] is the vector with the known values
  ///   - [x0] is the initial guess (which is a vector)
  ///   - [precision] tells how accurate the algorithm has to be
  ///   - [maxSteps] the maximum number of iterations the algorithm
  ///
  /// `A` must be strictly diagonally dominant.
  factory JacobiSolver({
    required List<List<double>> equations,
    required List<double> constants,
    required List<double> x0,
    int maxSteps = 30,
    double precision = 1.0e-10,
  }) {
    // The initial vector with the guesses MUST have the same size as the matrix
    // of course
    if (x0.length != constants.length) {
      throw const SystemSolverException(
        'The length of the guesses vector '
        'must match the size of the square matrix.',
      );
    }

    return JacobiSolver._(
      equations: equations,
      constants: constants,
      x0: x0,
      maxSteps: maxSteps,
      precision: precision,
    );
  }

  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [equations] is the flattened matrix containing the equations
  ///   - [constants] is the vector with the known values
  ///   - [x0] is the initial guess (which is a vector)
  ///   - [precision] tells how accurate the algorithm has to be
  ///   - [maxSteps] the maximum number of iterations the algorithm
  ///
  /// `A` must be strictly diagonally dominant.
  factory JacobiSolver.flatMatrix({
    required List<double> equations,
    required List<double> constants,
    required List<double> x0,
    int maxSteps = 30,
    double precision = 1.0e-10,
  }) {
    // The initial vector with the guesses MUST have the same size as the matrix
    // of course
    if (x0.length != constants.length) {
      throw const SystemSolverException(
        'The length of the guesses vector '
        'must match the size of the square matrix.',
      );
    }

    return JacobiSolver._flatMatrix(
      equations: equations,
      constants: constants,
      x0: x0,
      maxSteps: maxSteps,
      precision: precision,
    );
  }

  /// Creates a [JacobiSolver] instance with
  JacobiSolver._({
    required List<List<double>> equations,
    required List<double> constants,
    required this.x0,
    this.maxSteps = 30,
    super.precision,
  }) : super(
          A: equations,
          b: constants,
          size: constants.length,
        );

  /// Creates a [JacobiSolver] instance.
  JacobiSolver._flatMatrix({
    required List<double> equations,
    required List<double> constants,
    required this.x0,
    this.maxSteps = 30,
    super.precision,
  }) : super.flatMatrix(
          A: equations,
          b: constants,
          size: constants.length,
        );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is JacobiSolver) {
      // The lengths of the coefficients must match
      if (x0.length != other.x0.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements are
      // equal, then the counter will match the actual length of the coefficients
      // list.
      var equalsCount = 0;

      for (var i = 0; i < x0.length; ++i) {
        if (x0[i] == other.x0[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return super == other &&
          equalsCount == x0.length &&
          maxSteps == other.maxSteps;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = super.hashCode;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < x0.length; ++i) {
      result = result * 37 + x0[i].hashCode;
    }

    return result * 37 + maxSteps.hashCode;
  }

  @override
  List<double> solve() {
    // Exit conditions for the method
    var k = 0;
    var diff = precision + 1;

    // Support lists
    final size = knownValues.length;
    final solutions = List<double>.from(x0);

    // Jacobi
    while ((diff >= precision) && (k < maxSteps)) {
      final oldSolutions = List<double>.from(solutions);

      for (var i = 0; i < size; ++i) {
        // Initial value of the solution
        solutions[i] = knownValues[i];

        for (var j = 0; j < size; ++j) {
          // Skip the diagonal
          if (i == j) {
            continue;
          }

          solutions[i] = solutions[i] - equations(i, j) * oldSolutions[j];
        }

        // New "refined" value of the solution
        solutions[i] = solutions[i] / equations(i, i);
      }

      ++k;
      diff = _euclideanNorm(oldSolutions, solutions);
    }

    return solutions;
  }

  /// The euclidean norm is the square root of the sum of the square terms of
  /// a vector. This method computes the euclidean norm on the difference of
  /// two vectors.
  double _euclideanNorm(List<double> vectorA, List<double> vectorB) {
    // The difference vector
    final difference = List<double>.generate(vectorA.length, (_) => 0);
    for (var i = 0; i < difference.length; ++i) {
      difference[i] = vectorA[i] - vectorB[i];
    }

    // Computing the euclidean norm
    final sum = difference.map((xi) => xi * xi).reduce((a, b) => a + b);

    return math.sqrt(sum);
  }
}
