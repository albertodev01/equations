import 'package:equations/equations.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/result_wrapper.dart';

/// State emitted when the matrix has been analyzed and results are available.
class MatrixResultWrapper extends ResultWrapper {
  /// The transposed matrix.
  final RealMatrix transpose;

  /// The cofactor matrix.
  final RealMatrix cofactorMatrix;

  /// The inverse matrix.
  final RealMatrix inverse;

  /// The trace of the matrix.
  final double trace;

  /// The rank of the matrix.
  final int rank;

  /// The characteristic polynomial of the matrix.
  final Algebraic characteristicPolynomial;

  /// The eigenvalues of the matrix.
  final List<Complex> eigenvalues;

  /// The determinant of the matrix.
  final double determinant;

  /// Whether the matrix is diagonal or not.
  final bool isDiagonal;

  /// Whether the matrix is symmetric or not.
  final bool isSymmetric;

  /// Whether it's an identity matrix or not.
  final bool isIdentity;

  /// Creates an [MatrixResultWrapper] object.
  const MatrixResultWrapper({
    required this.transpose,
    required this.cofactorMatrix,
    required this.inverse,
    required this.trace,
    required this.rank,
    required this.characteristicPolynomial,
    required this.eigenvalues,
    required this.determinant,
    required this.isDiagonal,
    required this.isSymmetric,
    required this.isIdentity,
  });
}
