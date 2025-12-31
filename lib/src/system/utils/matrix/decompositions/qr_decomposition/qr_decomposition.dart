import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/decomposition.dart';

/// {@template qr_decomposition_class_header}
/// QR decomposition, also known as a QR factorization or QU factorization, is
/// a decomposition of a matrix A into a product `A = QR` of:
///
///  - an orthogonal matrix Q (where Q^T Q = I);
///  - an upper triangular matrix R.
///
/// QR decomposition is widely used for solving linear systems, least squares
/// problems, and computing eigenvalues. The decomposition is unique if the
/// matrix has full column rank and R has positive diagonal entries.
///
/// The algorithm uses Householder reflections to compute the decomposition,
/// which provides good numerical stability.
/// {@endtemplate}
abstract base class QRDecomposition<K, T extends Matrix<K>>
    extends Decomposition<K, T> {
  /// {@macro qr_decomposition_class_header}
  ///
  /// The [matrix] can be any rectangular matrix. For best results, the matrix
  /// should have full column rank.
  const QRDecomposition({required super.matrix});

  /// Computes the `Q` and `R` matrices of the QR decomposition algorithm.
  ///
  /// This method returns the matrices that satisfy the decomposition:
  ///
  ///  - A = Q x R
  ///
  /// where:
  /// - Q is an orthogonal matrix (Q^T Q = I)
  /// - R is an upper triangular matrix
  ///
  /// The returned list contains:
  /// - `Q` at index 0
  /// - `R` at index 1
  ///
  /// Returns a list of two matrices that satisfy the QR decomposition.
  ///
  /// Throws a [MatrixException] if the matrix is numerically singular or if
  /// numerical issues occur during the decomposition.
  @override
  List<T> decompose();
}
