import 'package:equations/equations.dart';

/// QR decomposition, also known as a QR factorization or QU factorization, is
/// a decomposition of a matrix A into a product `A = QR` of:
///
///   - an orthogonal matrix Q
///   - an upper triangular matrix R
abstract class QRDecomposition<K, T extends Matrix<K>> {
  /// The matrix to be decomposed in the Q*R product.
  final T matrix;

  /// Creates an instance of [QRDecomposition] to QR decompose the given [matrix].
  const QRDecomposition({
    required this.matrix,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is QRDecomposition<K, T>) {
      return runtimeType == other.runtimeType && matrix == other.matrix;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => matrix.hashCode;

  @override
  String toString() => '$matrix';

  /// For values in R, this method returns the square root of `1 + b/a` or
  /// `1 + a/b` without intermediate overflow or underflow.
  ///
  /// For values in C, this method returns the modulo of the complex number.
  K hypot(K a, K b);

  /// Computes the `Q` and `R` matrices of the QR decomposition algorithm. In
  /// particular, this method returns the `Q` and `R` matrices of the
  ///
  ///  - A = Q x R
  ///
  /// relation. The returned list contains `Q` at index 0 and `R` at index 1.
  List<T> decompose();
}
