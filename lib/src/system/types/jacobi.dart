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
  JacobiSolver({
    required List<List<double>> equations,
    required List<double> constants,
    required this.x0,
    this.maxSteps = 30,
    double precision = 1.0e-10,
  }) : super(
            A: equations,
            b: constants,
            size: constants.length,
            precision: precision) {
    // The initial vector with the guesses MUST have the same size as the matrix
    // of course
    if (x0.length != size) {
      throw const SystemSolverException("The length of the guesses vector "
          "must match the size of the square matrix.");
    }
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
          if (i == j) continue;

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
