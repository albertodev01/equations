/// A mixin that contains utility methods for solving linear systems using
/// triangular matrices.
///
/// This mixin provides efficient algorithms for forward and back substitution,
/// which are commonly used in matrix decomposition methods such as LU
/// decomposition, Cholesky decomposition, and Gaussian elimination.
mixin RealMatrixUtils {
  /// Solves a system of linear equations using back substitution.
  ///
  /// Back substitution is an iterative process that solves equation matrices
  /// in the form `Ux = b`, where `U` is an upper triangular matrix. This
  /// algorithm solves the system by starting from the last row and working
  /// backwards, using previously computed values to solve for the remaining
  /// unknowns.
  List<double> backSubstitution(
    List<List<double>> source,
    List<double> vector,
  ) {
    final size = vector.length;
    final solutions = List<double>.generate(size, (_) => 0, growable: false);

    for (var i = size - 1; i >= 0; --i) {
      solutions[i] = vector[i];
      for (var j = i + 1; j < size; ++j) {
        solutions[i] = solutions[i] - source[i][j] * solutions[j];
      }
      solutions[i] = solutions[i] / source[i][i];
    }

    return solutions;
  }

  /// Solves a system of linear equations using forward substitution.
  ///
  /// Forward substitution is an iterative process that solves equation matrices
  /// in the form `Lx = b`, where `L` is a lower triangular matrix. This
  /// algorithm solves the system by starting from the first row and working
  /// forwards, using previously computed values to solve for the remaining
  /// unknowns.
  List<double> forwardSubstitution(
    List<List<double>> source,
    List<double> vector,
  ) {
    final size = vector.length;
    final solutions = List<double>.generate(size, (_) => 0, growable: false);

    for (var i = 0; i < size; ++i) {
      solutions[i] = vector[i];
      for (var j = 0; j < i; ++j) {
        solutions[i] = solutions[i] - source[i][j] * solutions[j];
      }
      solutions[i] = solutions[i] / source[i][i];
    }

    return solutions;
  }
}
