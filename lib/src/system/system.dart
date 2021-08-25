import 'package:collection/collection.dart';
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
  late final RealMatrix equations;

  /// The vector containing the known values of the equation.
  late final List<double> _knownValues;

  /// The accuracy of the algorithm.
  final double precision;

  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [size] is the total number of equations
  ///   - [A] is the matrix containing the equations
  ///   - [b] is the vector with the known values
  SystemSolver({
    required int size,
    required List<List<double>> A,
    required List<double> b,
    this.precision = 1.0e-10,
  }) {
    // Building the matrix
    equations = RealMatrix.fromData(
      rows: size,
      columns: size,
      data: A,
    );

    // The vector of known values must match the size of the matrix
    if (equations.rowCount != b.length) {
      throw const SystemSolverException('The known values vector must have the '
          'same size as the matrix.');
    }

    // Copying and storing internally the list of known values
    _knownValues = b.map((value) => value).toList();
  }

  /// Given an equation in the form `Ax = b`, `A` is a square matrix containing
  /// `n` equations in `n` unknowns and `b` is the vector of the known values.
  ///
  ///   - [size] is the total number of equations
  ///   - [A] is the flattened matrix containing the equations
  ///   - [b] is the vector with the known values
  SystemSolver.flatMatrix({
    required int size,
    required List<double> A,
    required List<double> b,
    this.precision = 1.0e-10,
  }) {
    // Building the matrix
    equations = RealMatrix.fromFlattenedData(
      rows: size,
      columns: size,
      data: A,
    );

    // The vector of known values must match the size of the matrix
    if (equations.rowCount != b.length) {
      throw const SystemSolverException('The known values vector must have the '
          'same size as the matrix.');
    }

    // Copying and storing internally the list of known values
    _knownValues = b.map((value) => value).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is SystemSolver) {
      // The lengths of the coefficients must match
      if (_knownValues.length != other._knownValues.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements are
      // equal, then the counter will match the actual length of the coefficients
      // list.
      var equalsCount = 0;

      for (var i = 0; i < _knownValues.length; ++i) {
        if (_knownValues[i] == other._knownValues[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == _knownValues.length &&
          equations == other.equations &&
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
    for (var i = 0; i < _knownValues.length; ++i) {
      result = 37 * result + _knownValues[i].hashCode;
    }

    result = 37 * result + equations.hashCode;
    result = 37 * result + precision.hashCode;

    return result;
  }

  @override
  String toString() => equations.toString();

  /// The vector containing the known values of the equation.
  List<double> get knownValues => UnmodifiableListView<double>(_knownValues);

  /// Prints the augmented matrix of this instance, which is the equations matrix
  /// plus the known values vector to the right. For example, if...
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
    for (var i = 0; i < equations.rowCount; ++i) {
      // Leading opening [
      buffer.write('[');

      for (var j = 0; j < equations.columnCount; ++j) {
        buffer.write(equations(i, j));

        // Adding a comma only between two values
        if (j < equations.columnCount - 1) {
          buffer.write(', ');
        }
      }

      // Adding the known value associated to the current equation
      buffer..write(' | ')..write(knownValues[i]);

      // Ending closing ]
      if (i < equations.rowCount - 1) {
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
  bool hasSolution() => equations.determinant() != 0;

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
  int get size => _knownValues.length;

  /// Computes the determinant of the associated matrix.
  double determinant() => equations.determinant();

  /// Solves the `Ax = b` equation and returns the `x` vector containing the
  /// solutions of the system.
  List<double> solve();
}
