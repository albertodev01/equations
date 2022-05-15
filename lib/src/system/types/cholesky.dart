import 'package:equations/equations.dart';
import 'package:equations/src/system/system.dart';

/// Implementation of the "Cholesky decomposition" algorithm for solving a
/// system of linear equations. It only works with Hermitian, positive-definite
/// matrices.
class CholeskySolver extends SystemSolver {
  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [matrix] is the matrix containing the equations
  ///   - [knownValues] is the vector with the known values
  ///   - the matrix must be Hermitian and positive-definite
  ///
  /// Note that, when applicable, the Cholesky decomposition is almost twice as
  /// efficient as the LU decomposition when it comes to linear systems solving.
  CholeskySolver({
    required super.matrix,
    required super.knownValues,
    super.precision,
  }) : super();

  @override
  List<double> solve() {
    final cholesky = matrix.choleskyDecomposition();

    // Solving Ly = b
    final L = cholesky.first.toListOfList();
    final b = knownValues;
    final y = SystemSolver.forwardSubstitution(L, b);

    // Solving Ux = y
    final transposedL = cholesky[1].toListOfList();
    final x = SystemSolver.backSubstitution(transposedL, y);

    return x;
  }
}
