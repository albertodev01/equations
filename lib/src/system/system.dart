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

  /// The vector containing the known values of the equation.
  List<double> get knownValues => UnmodifiableListView<double>(_knownValues);

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
    equations = RealMatrix.fromData(rows: size, columns: size, data: A);

    // The vector of known values must match the size of the matrix
    if (equations.rowCount != b.length) {
      throw const SystemSolverException("The known values vector must have the "
          "same size as the matrix.");
    }

    // Copying and storing internally the list of known values
    _knownValues = b.map((value) => value).toList();
  }

  /// The dimension of the system (which is N equations in N unknowns)
  int get size => _knownValues.length;

  /// Computes the determinant
  double determinant() => equations.determinant();

  /// Solves the `Ax = b` equation and returns the `x` vector containing the
  /// solutions of the system.
  List<double> solve();
}
