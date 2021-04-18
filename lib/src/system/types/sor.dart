import 'dart:math' as math;
import 'package:equations/equations.dart';

/// Solves a system of linear equations using the SOR iterative method.
/// The given input matrix, representing the system of linear equations, must
/// be square.
///
/// A theorem due to Kahan (1958) shows that SOR fails to converge if `w` is not
/// in the (0, 2) range.
class SORSolver extends SystemSolver {
  /// The relaxation factor `w` (omega).
  final double w;

  /// The maximum number of iterations to be made by the algorithm.
  final int maxSteps;

  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [equations] is the matrix containing the equations
  ///   - [constants] is the vector with the known values
  ///   - [precision] determines how accurate the algorithm has to be
  ///   - [w] is the relaxation factor
  ///   - [maxSteps] the maximum number of iterations the algorithm
  SORSolver({
    required List<List<double>> equations,
    required List<double> constants,
    required this.w,
    this.maxSteps = 30,
    double precision = 1.0e-10,
  }) : super(
          A: equations,
          b: constants,
          size: constants.length,
          precision: precision,
        );

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
  int get hashCode {
    var result = super.hashCode;

    result = 37 * result + w.hashCode;
    result = 37 * result + maxSteps.hashCode;

    return result;
  }

  @override
  List<double> solve() {
    // Exit conditions for the method
    var k = 0;
    var diff = precision + 1;

    // Support lists
    final size = knownValues.length;
    final phi = List<double>.generate(size, (_) => 0);

    // Jacobi
    while ((diff >= precision) && (k < maxSteps)) {
      for (var i = 0; i < size; ++i) {
        var sigma = 0.0;
        for (var j = 0; j < size; ++j) {
          if (j != i) {
            sigma += equations(i, j) * phi[j];
          }
        }
        phi[i] =
            (1 - w) * phi[i] + (w / equations(i, i)) * (knownValues[i] - sigma);
      }

      ++k;
      diff = _euclideanNorm(phi);
    }

    return phi;
  }

  /// The euclidean norm is the square root of the sum of the square terms of
  /// a vector. This method computes the euclidean norm on the difference of
  /// two vectors.
  double _euclideanNorm(List<double> phi) {
    // This is A*phi (where A is the source matrix)
    final difference = List<double>.generate(equations.rowCount, (_) => 0);

    for (var i = 0; i < equations.rowCount; ++i) {
      var sum = 0.0;
      for (var j = 0; j < equations.columnCount; ++j) {
        sum += equations(i, j) * phi[j];
      }
      difference[i] = sum;
    }

    // Making the difference between (A*phi) - b
    for (var i = 0; i < knownValues.length; ++i) {
      difference[i] -= knownValues[i];
    }

    // Computing the euclidean norm
    final sum = difference.map((xi) => xi * xi).reduce((a, b) => a + b);
    return math.sqrt(sum);
  }
}
