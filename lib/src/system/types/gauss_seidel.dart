import 'package:equations/equations.dart';

/// Solves a system of linear equations using the Gauss-Seidel iterative method.
/// The given input matrix, representing the system of linear equations, must
/// be square.
///
/// Note that the usage of [GaussSeidelSolver] is the same as using [SORSolver]
/// with `w = 1`.
class GaussSeidelSolver extends SystemSolver {
  /// The maximum number of iterations to be made by the algorithm.
  final int maxSteps;

  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [equations] is the matrix containing the equations
  ///   - [constants] is the vector with the known values
  ///   - [precision] determines how accurate the algorithm has to be
  ///   - [maxSteps] the maximum number of iterations the algorithm
  GaussSeidelSolver({
    required List<List<double>> equations,
    required List<double> constants,
    this.maxSteps = 30,
    double precision = 1.0e-10,
  }) : super(
            A: equations,
            b: constants,
            size: constants.length,
            precision: precision);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is GaussSeidelSolver) {
      return super == other && maxSteps == other.maxSteps;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = super.hashCode;

    result = 37 * result + maxSteps.hashCode;

    return result;
  }

  @override
  List<double> solve() {
    // When 'w = 1', the SOR method simplifies to the Gauss-Seidel method.
    final sor = SORSolver(
        equations: equations.toListOfList(), constants: knownValues, w: 1);

    return sor.solve();
  }
}
