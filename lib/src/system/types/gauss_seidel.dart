import 'package:equations/equations.dart';

/// Solves a system of linear equations using the Gauss-Seidel iterative method.
/// The given input matrix, representing the system of linear equations, must
/// be square.
///
/// Gauss-Seidel is the same as SOR when `w` = 1.
/// with `w = 1`.
final class GaussSeidelSolver extends SystemSolver {
  /// The maximum number of iterations to be made by the algorithm.
  final int maxSteps;

  /// {@macro systems_constructor_intro}
  ///
  ///  - [matrix] is the matrix containing the equations;
  ///  - [knownValues] is the vector with the known values;
  ///  - [precision] determines how accurate the algorithm has to be;
  ///  - [maxSteps] the maximum number of iterations the algorithm.
  ///
  /// By default, [maxSteps] is set to `30`.
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
    final sor = SORSolver(matrix: matrix, knownValues: knownValues, w: 1);

    return sor.solve();
  }
}
