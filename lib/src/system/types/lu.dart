import 'package:equations/equations.dart';
import 'package:equations/src/system/system.dart';
import 'package:equations/src/system/utils/matrix_utils.dart';

/// Solves a system of linear equations using the 'LU decomposition' method.
/// The given input matrix, representing the system of linear equations, must
/// be square.
final class LUSolver extends SystemSolver with RealMatrixUtils {
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
    final y = forwardSubstitution(L, b);

    // Solving Ux = y
    final U = lu[1].toListOfList();

    return backSubstitution(U, y);
  }
}
