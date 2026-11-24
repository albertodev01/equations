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
  /// {@macro matrix_decomposition}
  ///
  /// The [matrix] parameter must be a valid matrix that can be decomposed
  /// according to the specific decomposition algorithm being used.
  const new({required this.matrix});

  /// The matrix to be decomposed.
  final T matrix;

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

  /// Factorizes [matrix] and returns the list of matrices of the
  /// factorization.
  ///
  /// The exact number, order and meaning of the returned matrices depends on
  /// the specific decomposition algorithm:
  ///
  /// - QR decomposition returns `[Q, R]`, where `A = Q x R`;
  /// - SVD returns `[E, U, V]`, where `A = U x E x V^H`;
  /// - Eigendecomposition returns `[V, D, V^-1]`, where `A = V x D x V^-1`.
  ///
  /// Throws a [MatrixException] if the matrix cannot be decomposed (for
  /// example, if it contains NaN or infinite values, or if it does not meet
  /// the requirements of the decomposition).
  List<T> decompose();
}
