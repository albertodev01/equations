import 'package:equations/equations.dart';

/// A solver for systems of linear equations whose coefficients are only real
/// numbers. There **must** be `n` equations in `n` unknowns.
///
/// The coefficients of the various equations are put inside a square matrix,
/// which is generally called `A`, and the known values are represented by a
/// vector, usually known as `b`. From this, we get an equation in the form
/// `Ax = b`.
///
/// The method [solve] returns the vector `x` of the `Ax = b` equation.
abstract class SystemSolver {
  /// The equations of the system to be solved.
  final RealMatrix matrix;

  /// The vector containing the known values of the equation.
  final List<double> knownValues;

  /// The accuracy of the algorithm.
  final double precision;

  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [matrix] is the matrix containing the equations
  ///   - [knownValues] is the vector with the known values
  ///
  /// An exception of type [SystemSolverException] is thrown if the matrix is
  /// not square.
  SystemSolver({
    required this.matrix,
    required this.knownValues,
    this.precision = 1.0e-10,
  }) {
    // Only square matrices are allowed
    if (!matrix.isSquareMatrix) {
      throw const SystemSolverException('The matrix must be square');
    }

    // The vector of known values must match the size of the matrix
    if (matrix.rowCount != knownValues.length) {
      throw const SystemSolverException(
        'The known values vector must have the '
        'same size as the matrix.',
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is SystemSolver) {
      // The lengths of the coefficients must match
      if (knownValues.length != other.knownValues.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements
      // are equal, then the counter will match the actual length of the
      // coefficients list.
      var equalsCount = 0;

      for (var i = 0; i < knownValues.length; ++i) {
        if (knownValues[i] == other.knownValues[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == knownValues.length &&
          matrix == other.matrix &&
          precision == other.precision;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < knownValues.length; ++i) {
      result = result * 37 + knownValues[i].hashCode;
    }

    result = result * 37 + matrix.hashCode;
    result = result * 37 + precision.hashCode;

    return result;
  }

  @override
  String toString() => matrix.toString();

  /// Prints the augmented matrix of this instance, which is the equations
  /// matrix plus the known values vector to the right. For example, if...
  ///
  /// A = [1, 2]
  ///     [4, 5]
  /// b = [3]
  ///     [6]
  ///
  /// ... then the `Ax = b` system represented by this instance is printed in
  /// the following way:
  ///
  /// [1, 2 | 3]
  /// [4, 5 | 6]
  String toStringAugmented() {
    final buffer = StringBuffer();

    // Printing the augmented matrix in the following format:
    // [1, 2 | 3]
    // [4, 5 | 6]
    for (var i = 0; i < matrix.rowCount; ++i) {
      // Leading opening [
      buffer.write('[');

      for (var j = 0; j < matrix.columnCount; ++j) {
        buffer.write(matrix(i, j));

        // Adding a comma only between two values
        if (j < matrix.columnCount - 1) {
          buffer.write(', ');
        }
      }

      // Adding the known value associated to the current equation
      buffer
        ..write(' | ')
        ..write(knownValues[i]);

      // Ending closing ]
      if (i < matrix.rowCount - 1) {
        buffer.writeln(']');
      } else {
        buffer.write(']');
      }
    }

    return buffer.toString();
  }

  /// Computes whether the system can be solved or not.
  ///
  /// A system can be solved (meaning that it has exactly ONE solution) if the
  /// determinant it not zero.
  bool hasSolution() => matrix.determinant() != 0;

  /// Back substitution is an iterative process that solves equation matrices
  /// in the form `Ux = b`, where `U` is an upper triangular matrix.
  ///
  /// In this case, [source] represents `U` and [vector] represents `b`.
  static List<double> backSubstitution(
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
  static List<double> forwardSubstitution(
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

  /// The dimension of the system (which is N equations in N unknowns).
  int get size => knownValues.length;

  /// Computes the determinant of the associated matrix.
  double determinant() => matrix.determinant();

  /// Solves the `Ax = b` equation and returns the `x` vector containing the
  /// solutions of the system.
  List<double> solve();
}
