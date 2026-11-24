import 'package:equations/equations.dart';

/// A mixin that contains utility methods for solving linear systems using
/// triangular matrices.
///
/// This mixin provides forward and back substitution, which are the final
/// steps of solvers based on matrix decompositions such as the LU and the
/// Cholesky decompositions.
mixin RealMatrixUtils {
  /// Solves the linear system `Ux = b` using back substitution, where `U` is
  /// an upper triangular matrix.
  ///
  /// The [source] parameter is the `n x n` upper triangular matrix `U` (given
  /// as a list of rows) and [vector] is the known terms vector `b`, whose
  /// length must be `n`. Only the elements on and above the main diagonal of
  /// [source] are read.
  ///
  /// The system is solved starting from the last row and working backwards,
  /// using the previously computed values to find the remaining unknowns.
  /// The returned list contains the solution `x`.
  ///
  /// A [SystemSolverException] is thrown if [source] is not an `n x n`
  /// matrix or if an element on its main diagonal is zero.
  List<double> backSubstitution(
    List<List<double>> source,
    List<double> vector,
  ) {
    _validateTriangularSystem(source, vector);

    final size = vector.length;
    final solutions = List<double>.filled(size, 0);

    for (var i = size - 1; i >= 0; --i) {
      solutions[i] = vector[i];
      for (var j = i + 1; j < size; ++j) {
        solutions[i] = solutions[i] - source[i][j] * solutions[j];
      }
      solutions[i] = solutions[i] / source[i][i];
    }

    return solutions;
  }

  /// Solves the linear system `Lx = b` using forward substitution, where `L`
  /// is a lower triangular matrix.
  ///
  /// The [source] parameter is the `n x n` lower triangular matrix `L` (given
  /// as a list of rows) and [vector] is the known terms vector `b`, whose
  /// length must be `n`. Only the elements on and below the main diagonal of
  /// [source] are read.
  ///
  /// The system is solved starting from the first row and working forwards,
  /// using the previously computed values to find the remaining unknowns.
  /// The returned list contains the solution `x`.
  ///
  /// A [SystemSolverException] is thrown if [source] is not an `n x n`
  /// matrix or if an element on its main diagonal is zero.
  List<double> forwardSubstitution(
    List<List<double>> source,
    List<double> vector,
  ) {
    _validateTriangularSystem(source, vector);

    final size = vector.length;
    final solutions = List<double>.filled(size, 0);

    for (var i = 0; i < size; ++i) {
      solutions[i] = vector[i];
      for (var j = 0; j < i; ++j) {
        solutions[i] = solutions[i] - source[i][j] * solutions[j];
      }
      solutions[i] = solutions[i] / source[i][i];
    }

    return solutions;
  }

  /// Makes sure that [source] is an `n x n` matrix, where `n` is the length
  /// of [vector], and that there are no zeros on its main diagonal.
  ///
  /// Throws a [SystemSolverException] if any of these conditions is not met.
  void _validateTriangularSystem(
    List<List<double>> source,
    List<double> vector,
  ) {
    final size = vector.length;

    if (source.length != size || source.any((row) => row.length != size)) {
      throw const SystemSolverException(
        'The coefficients matrix must be square and its size must match the '
        'length of the known terms vector.',
      );
    }

    for (var i = 0; i < size; ++i) {
      if (source[i][i] == 0) {
        throw const SystemSolverException(
          'The triangular matrix has a zero on its main diagonal, so the '
          'system has no unique solution.',
        );
      }
    }
  }
}
