import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/single_value_decomposition.dart';

/// Matrix decompositions, also knows as matrix factorizations, refer to a
/// family of algorithms that a factorize a matrix into a product of matrices.
///
/// See also:
///
///  - [QRDecomposition]
///  - [SingleValueDecomposition]
abstract class Decomposition<K, T extends Matrix<K>> {
  /// The matrix to be decomposed.
  final T matrix;

  /// Creates an instance of [Decomposition] to factor the given [matrix].
  const Decomposition({
    required this.matrix,
  });

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

  @override
  String toString() => '$matrix';

  /// Factorizes [matrix] and returns, in order, the matrices to be multiplied.
  List<T> decompose();
}
