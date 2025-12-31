import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigen_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/single_value_decomposition.dart';

/// {@template matrix_decomposition}
/// Matrix decompositions, also known as matrix factorizations, refer to a
/// family of algorithms that factorize a matrix into a product of matrices.
///
/// Matrix decompositions are fundamental tools in linear algebra and numerical
/// analysis, used for solving systems of linear equations, computing matrix
/// inverses, finding eigenvalues, and many other applications.
///
/// See also:
///
///  - [QRDecomposition] - Decomposes a matrix into an orthogonal and upper
///    triangular matrix
///  - [SingleValueDecomposition] - Decomposes a matrix into singular values
///    and unitary matrices
///  - [EigenDecomposition] - Decomposes a matrix into eigenvalues and
///    eigenvectors
/// {@endtemplate}
abstract base class Decomposition<K, T extends Matrix<K>> {
  /// The matrix to be decomposed.
  final T matrix;

  /// {@macro matrix_decomposition}
  ///
  /// The [matrix] parameter must be a valid matrix that can be decomposed
  /// according to the specific decomposition algorithm being used.
  const Decomposition({required this.matrix});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Decomposition<K, T>) {
      return runtimeType == other.runtimeType && matrix == other.matrix;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => matrix.hashCode;

  /// Factorizes [matrix] and returns a list of matrices that, when multiplied
  /// together in order, reconstruct the original matrix.
  ///
  /// The exact number and meaning of the returned matrices depends on the
  /// specific decomposition algorithm. For example:
  ///
  /// - QR decomposition returns [Q, R] where Q is orthogonal and R is upper
  ///   triangular
  /// - SVD returns [E, U, V] where E contains singular values, U and V are
  ///   unitary matrices
  /// - Eigendecomposition returns [V, D, V^-1] where V contains eigenvectors
  ///   and D is a diagonal matrix of eigenvalues
  ///
  /// Returns a list of matrices that satisfy the decomposition equation.
  ///
  /// Throws a [MatrixException] if the matrix cannot be decomposed (e.g., if
  /// it is singular or does not meet the requirements of the decomposition).
  List<T> decompose();
}
