import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/decomposition.dart';

/// {@template svd_class_header}
/// Singular Value Decomposition (SVD) is a decomposition of an `m x n`
/// matrix A into a product `A = U x E x V^H` of:
///
///  - an `m x m` unitary matrix U (left singular vectors);
///  - an `m x n` rectangular diagonal matrix E with real, non-negative
///    singular values on the diagonal (ordered from largest to smallest);
///  - an `n x n` unitary matrix V (right singular vectors), where `V^H` is the
///    conjugate transpose of V.
///
/// For real matrices, U and V are orthogonal and `V^H` is simply the
/// transpose `V^T`. The SVD exists for any matrix.
/// {@endtemplate}
abstract base class SingleValueDecomposition<K, T extends Matrix<K>>
    extends Decomposition<K, T> {
  /// {@macro svd_class_header}
  ///
  /// The [matrix] can be any rectangular matrix. SVD always exists for any
  /// matrix, unlike some other decompositions.
  const new({required super.matrix});

  /// Computes the `E`, `U` and `V` matrices of the SVD algorithm.
  ///
  /// This method returns the matrices that satisfy the decomposition:
  ///
  ///  - A = U x E x V^H
  ///
  /// where:
  /// - U is a unitary matrix containing the left singular vectors
  /// - E is a rectangular diagonal matrix with singular values on the diagonal
  ///   (ordered from largest to smallest)
  /// - V is a unitary matrix containing the right singular vectors
  /// - V^H is the conjugate transpose of V (the transpose, for real matrices)
  ///
  /// The returned list contains:
  /// - `E` at index 0 (the singular value matrix)
  /// - `U` at index 1 (left singular vectors)
  /// - `V` at index 2 (right singular vectors, not transposed)
  ///
  /// Throws a [MatrixException] if the matrix contains NaN or infinite values,
  /// or if the algorithm doesn't converge.
  @override
  List<T> decompose();
}
