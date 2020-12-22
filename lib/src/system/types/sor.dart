import 'package:equations/equations.dart';
import 'package:equations/src/system/system.dart';

/// Implementation of the "Gaussian elimination" algorithm, also known as "row
/// reduction", for solving a system of linear equations.
class SOR extends SystemSolver {
  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [equations] is the matrix containing the equations
  ///   - [constants] is the vector with the known values
  SOR({
    required List<List<double>> equations,
    required List<double> constants,
  }) : super(A: equations, b: constants, size: constants.length);

  @override
  List<double> solve() {
    final solutions = <double>[];

    // Returning the results
    return solutions;
  }
}
