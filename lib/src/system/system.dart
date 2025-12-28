import 'package:equations/equations.dart';

/// {@template system_solver}
/// An abstract class that represents a system of equations, which can be solved
/// using various algorithms that manipulate the data of a matrix and a vector.
///
/// System solvers of linear equations require the coefficients to be real
/// numbers and there **must** be `n` equations in `n` unknowns.
///
/// The coefficients of the various equations are put inside a square matrix,
/// generally called `A`. The known values are represented by a vector, usually
/// known as `b`. From this, we get an equation in the form `Ax = b`.
///
/// The method [solve] returns the `x` vector of the `Ax = b` equation.
///
/// ## Available Solvers
///
/// - [GaussianElimination]: Direct method using row reduction;
/// - [LUSolver]: Direct method using LU decomposition;
/// - [CholeskySolver]: Direct method for symmetric positive-definite matrices;
/// - [JacobiSolver]: Iterative method for diagonally dominant systems
/// - [GaussSeidelSolver]: Iterative method, faster than Jacobi;
/// - [SORSolver]: Iterative method with relaxation factor.
///
/// ## Recommendations
///
/// - General-purpose solvers: Use [GaussianElimination] or [LUSolver]
/// - For symmetric positive-definite matrices: Use [CholeskySolver] (fastest)
/// - For large sparse systems: Use iterative methods ([JacobiSolver],
///   [GaussSeidelSolver], or [SORSolver])
/// - For multiple systems with same matrix: Use [LUSolver]
/// {@endtemplate}
///
/// {@template systems_constructor_intro}
/// Given an equation in the form `Ax = b`, `A` is a square matrix containing
/// `n` equations in `n` unknowns and `b` is the vector of the known values.
/// This class can only be built with square matrices.
/// {@endtemplate}
abstract base class SystemSolver {
  /// The equations to be solved.
  ///
  /// This is the coefficient matrix `A` in the equation `Ax = b`. It must be
  /// a square matrix (same number of rows and columns).
  final RealMatrix matrix;

  /// The vector containing the known values of the equations.
  ///
  /// This is the vector `b` in the equation `Ax = b`. The length of this vector
  /// must match the number of rows (or columns) of the [matrix].
  final List<double> knownValues;

  /// The algorithm accuracy.
  ///
  /// This value determines the precision required for convergence in iterative
  /// methods, or the tolerance used for numerical checks in direct methods.
  /// Defaults to `1.0e-10`.
  ///
  /// For iterative solvers, the algorithm stops when the change between
  /// iterations is less than this value. For direct solvers, this value is used
  /// to detect singular or near-singular matrices.
  final double precision;

  /// {@macro system_solver}
  ///
  /// {@macro systems_constructor_intro}
  ///
  /// Parameters:
  ///   - [matrix] is the matrix with the equations (must be square);
  ///   - [knownValues] is the vector with the known values (must match matrix
  ///     size);
  ///   - [precision] is the algorithm accuracy (defaults to `1.0e-10`).
  ///
  /// Throws a [SystemSolverException] if:
  ///   - The matrix is not square, or
  ///   - The [knownValues] vector length doesn't match the matrix size.
  SystemSolver({
    required this.matrix,
    required this.knownValues,
    this.precision = 1.0e-10,
  }) {
    // Only square matrices are allowed.
    if (!matrix.isSquareMatrix) {
      throw const SystemSolverException('The matrix must be square');
    }

    // The vector of known values must match the size of the matrix.
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
      if (knownValues.length != other.knownValues.length) {
        return false;
      }
      for (var i = 0; i < knownValues.length; ++i) {
        if (knownValues[i] != other.knownValues[i]) {
          return false;
        }
      }

      return runtimeType == other.runtimeType &&
          matrix == other.matrix &&
          precision == other.precision;
    } else {
      return false;
    }
  }

  @override
  int get hashCode =>
      Object.hash(matrix, precision, Object.hashAll(knownValues));

  @override
  String toString() => matrix.toString();

  /// Returns a string representation of the **augmented matrix** of this
  /// system.
  ///
  /// The augmented matrix combines the coefficient matrix `A` with the known
  /// values vector `b` into a single matrix representation, separated by a
  /// vertical bar `|`. This format is commonly used in linear algebra to
  /// represent systems of equations.
  ///
  /// For example, if the system is:
  ///
  /// ```txt
  /// A = [1, 2]
  ///     [4, 5]
  /// b = [3]
  ///     [6]
  /// ```
  ///
  /// Then the augmented matrix representation is:
  ///
  /// ```txt
  /// [1, 2 | 3]
  /// [4, 5 | 6]
  /// ```
  ///
  /// This represents the system of equations:
  /// - `1x + 2y = 3`
  /// - `4x + 5y = 6`
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

      // Adding the known value associated to the current equation.
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
  /// determinant is not zero. If the determinant is zero, the matrix is
  /// singular and the system either has no solution or infinitely many
  /// solutions.
  ///
  /// Returns `true` if the system has a unique solution, `false` otherwise.
  ///
  /// Note: Some solvers (like [GaussianElimination] and [LUSolver]) will throw
  /// a [SystemSolverException] if the system has no solution when [solve] is
  /// called, even if this method returns `false`.
  bool hasSolution() => matrix.determinant() != 0;

  /// The dimension of the system (N equations in N unknowns).
  ///
  /// This is the number of equations (and unknowns) in the system. For a system
  /// with `n` equations in `n` unknowns, this returns `n`.
  int get size => knownValues.length;

  /// Computes the determinant of the associated matrix.
  ///
  /// The determinant is a scalar value that can be computed from the elements
  /// of a square matrix. It provides important information about the matrix:
  ///
  /// - If the determinant is zero, the matrix is singular (not invertible)
  /// - If the determinant is non-zero, the matrix is non-singular (invertible)
  ///
  /// A non-zero determinant indicates that the system `Ax = b` has a unique
  /// solution. Use [hasSolution] to check if the system can be solved.
  double determinant() => matrix.determinant();

  /// Solves the `Ax = b` equation and returns the `x` vector.
  ///
  /// This method uses the specific algorithm implemented by the concrete solver
  /// class to find the solution vector `x` that satisfies the equation
  /// `Ax = b`.
  ///
  /// Returns a list of [double] values representing the solution vector `x`.
  ///
  /// Throws a [SystemSolverException] if:
  ///   - The system has no solution (singular matrix), or
  ///   - The algorithm fails to converge (for iterative methods), or
  ///   - Numerical instability is detected during computation.
  ///
  /// Example:
  /// ```dart
  /// final solver = GaussianElimination(
  ///   matrix: RealMatrix.fromData(
  ///     rows: 2,
  ///     columns: 2,
  ///     data: [[2, 1], [1, 3]],
  ///   ),
  ///   knownValues: [5, 7],
  /// );
  ///
  /// final solution = solver.solve();
  /// // Returns: [1.6, 1.8] (approximately)
  /// ```
  List<double> solve();

  /// Checks if the matrix is diagonally dominant.
  ///
  /// A matrix A is diagonally dominant if for each row i:
  ///   |a_{ii}| ≥ Σ_{j≠i} |a_{ij}|
  static bool isDiagonallyDominant(RealMatrix matrix) {
    for (var i = 0; i < matrix.rowCount; ++i) {
      var rowSum = 0.0;
      final diagonalElement = matrix(i, i).abs();

      for (var j = 0; j < matrix.columnCount; ++j) {
        if (i != j) {
          rowSum += matrix(i, j).abs();
        }
      }

      if (diagonalElement < rowSum) {
        return false;
      }
    }
    return true;
  }
}
