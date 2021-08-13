import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/decomposition.dart';

/// Single Value Decomposition decomposition, also known as a SVD, is a
/// decomposition of a matrix A into a product `A = U x E x Vt` of:
///
///   - a square unitary matrix U
///   - a rectangular diagonal matrix E with positive values on the diagonal
///   - a square unitary matrix V
abstract class SingleValueDecomposition<K, T extends Matrix<K>>
    extends Decomposition<K, T> {
  /// Creates an instance of [SingleValueDecomposition] to apply SVD on the
  /// given matrix.
  const SingleValueDecomposition({
    required T matrix,
  }) : super(
          matrix: matrix,
        );

  /// Computes the `E`, `U` and `V` matrices of the SVG algorithm. In particular,
  /// this method returns the `E`, `U` and `V` matrices of the
  ///
  ///  - A = U x E x Vt
  ///
  /// relation, where 'Vt' is the transposed of V. The returned list contains `E`
  /// at index 0, `U` at index 1 and `V` at index 2.
  @override
  List<T> decompose();
}
