import 'package:equations/equations.dart';

/// A mixin that contains utility methods for the [RealMatrix] class.
mixin RealMatrixUtils {
  /// Back substitution is an iterative process that solves equation matrices
  /// in the form `Ux = b`, where `U` is an upper triangular matrix.
  ///
  /// In this case, [source] represents `U` and [vector] represents `b`.
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

  /// Forward substitution is an iterative process that solves equation matrices
  /// in the form `Lx = b`, where `L` is a lower triangular matrix.
  ///
  /// In this case, [source] represents `L` and [vector] represents `b`.
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
