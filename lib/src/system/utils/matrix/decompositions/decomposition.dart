import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigen_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/single_value_decomposition.dart';

/// {@template matrix_decomposition}
/// Matrix decompositions, also knows as matrix factorizations, refer to a
/// family of algorithms that a factorize a matrix into a product of matrices.
///
/// See also:
///
///  - [QRDecomposition]
///  - [SingleValueDecomposition]
///  - [EigenDecomposition]
/// {@endtemplate}
abstract base class Decomposition<K, T extends Matrix<K>> {
  /// The matrix to be decomposed.
  final T matrix;

  /// {@macro matrix_decomposition}
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

  @override
  String toString() => '$matrix';

  /// Factorizes [matrix] and returns, in order, the matrices to be multiplied
  /// to obtain the original one.
  List<T> decompose();
}
