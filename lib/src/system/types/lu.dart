import 'package:equations/equations.dart';
import 'package:equations/src/system/system.dart';

/// Solves a system of linear equations using the 'LU decomposition' method.
/// The given input matrix, representing the system of linear equations, must
/// be square.
final class LUSolver extends SystemSolver {
  /// {@macro systems_constructor_intro}
  ///
  ///  - [matrix] is the matrix containing the equations;
  ///  - [knownValues] is the vector with the known values.
  LUSolver({
    required super.matrix,
    required super.knownValues,
  });

  @override
  List<double> solve() {
    final lu = matrix.luDecomposition();

    // Solving Ly = b
    final L = lu.first.toListOfList();
    final b = knownValues;
    final y = SystemSolver.forwardSubstitution(L, b);

    // Solving Ux = y
    final U = lu[1].toListOfList();

    return SystemSolver.backSubstitution(U, y);
  }
}
