import 'package:equations/equations.dart';
import 'package:equations/src/system/system.dart';

/// Solves a system of linear equations using the 'LU decomposition' method.
/// The given input matrix, representing the system of linear equations, must
/// be square.
class LUSolver extends SystemSolver {
  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [equations] is the matrix containing the equations
  ///   - [constants] is the vector with the known values
  LUSolver({
    required List<List<double>> equations,
    required List<double> constants,
  }) : super(A: equations, b: constants, size: constants.length);

  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [equations] is the flattened matrix containing the equations
  ///   - [constants] is the vector with the known values
  LUSolver.flatMatrix({
    required List<double> equations,
    required List<double> constants,
  }) : super.flatMatrix(
          A: equations,
          b: constants,
          size: constants.length,
        );

  @override
  List<double> solve() {
    final lu = equations.luDecomposition();

    // Solving Ly = b
    final L = lu.first.toListOfList();
    final b = knownValues;
    final y = SystemSolver.forwardSubstitution(L, b);

    // Solving Ux = y
    final U = lu[1].toListOfList();
    final x = SystemSolver.backSubstitution(U, y);

    return x;
  }
}
