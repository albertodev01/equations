import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/decomposition.dart';

/// QR decomposition, also known as a QR factorization or QU factorization, is
/// a decomposition of a matrix A into a product `A = QR` of:
///
///   - an orthogonal matrix Q
///   - an upper triangular matrix R
abstract class QRDecomposition<K, T extends Matrix<K>>
    extends Decomposition<K, T> {
  /// Creates an instance of [QRDecomposition] to QR decompose the given [matrix].
  const QRDecomposition({
    required T matrix,
  }) : super(
          matrix: matrix,
        );

  /// Computes the `Q` and `R` matrices of the QR decomposition algorithm. In
  /// particular, this method returns the `Q` and `R` matrices of the
  ///
  ///  - A = Q x R
  ///
  /// relation. The returned list contains `Q` at index 0 and `R` at index 1.
  @override
  List<T> decompose();
}
