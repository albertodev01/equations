import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/decomposition.dart';

/// {@template qr_decomposition_class_header}
/// QR decomposition, also known as a QR factorization or QU factorization, is
/// a decomposition of a matrix A into a product `A = QR` of:
///
///  - an orthogonal matrix Q;
///
///  - an upper triangular matrix R.
/// {@endtemplate}
abstract base class QRDecomposition<K, T extends Matrix<K>>
    extends Decomposition<K, T> {
  /// Creates a [QRDecomposition] object.
  const QRDecomposition({
    required super.matrix,
  });

  /// Computes the `Q` and `R` matrices of the QR decomposition algorithm. In
  /// particular, this method returns the `Q` and `R` matrices of the
  ///
  ///  - A = Q x R
  ///
  /// relation. The returned list contains `Q` at index 0 and `R` at index 1.
  @override
  List<T> decompose();
}
