import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/decomposition.dart';

/// {@template qr_decomposition_class_header}
/// QR decomposition, also known as a QR factorization or QU factorization, is
/// a decomposition of an `m x n` matrix A into a product `A = QR`. With
/// `k = min(m, n)`, this library computes the **reduced** QR decomposition:
///
///  - `Q` is an `m x k` matrix with orthonormal columns (`Q^H x Q = I`, which
///    is `Q^T x Q = I` for real matrices). When `m <= n`, `Q` is square and
///    unitary (orthogonal, for real matrices);
///  - `R` is a `k x n` upper triangular (upper trapezoidal, when `k < n`)
///    matrix.
///
/// QR decomposition is widely used for solving linear systems, least squares
/// problems, and computing eigenvalues. The decomposition exists for any
/// matrix, including singular ones (in that case, some diagonal elements of
/// `R` are zero).
///
/// The algorithm uses Householder reflections to compute the decomposition,
/// which provides good numerical stability. The diagonal elements of `R` are
/// not normalized to be positive.
/// {@endtemplate}
abstract base class QRDecomposition<K, T extends Matrix<K>>
    extends Decomposition<K, T> {
  /// {@macro qr_decomposition_class_header}
  ///
  /// The [matrix] can be any rectangular matrix.
  const new({required super.matrix});

  /// Computes the `Q` and `R` matrices of the QR decomposition algorithm.
  ///
  /// This method returns the matrices that satisfy the decomposition:
  ///
  ///  - A = Q x R
  ///
  /// where, with `k = min(rowCount, columnCount)`:
  /// - `Q` is a `rowCount x k` matrix with orthonormal columns
  /// - `R` is a `k x columnCount` upper triangular matrix
  ///
  /// The returned list contains:
  /// - `Q` at index 0
  /// - `R` at index 1
  ///
  /// Throws a [MatrixException] if the matrix contains NaN or infinite values.
  @override
  List<T> decompose();
}
