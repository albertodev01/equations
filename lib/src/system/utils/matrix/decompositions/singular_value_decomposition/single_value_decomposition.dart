import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/decomposition.dart';

/// {@template svd_class_header}
/// Singular Value Decomposition (SVD) is a decomposition of a matrix A into
/// a product `A = U x E x V^T` of:
///
///  - a unitary matrix U (left singular vectors);
///  - a rectangular diagonal matrix E with non-negative singular values on
///    the diagonal (ordered from largest to smallest);
///  - a unitary matrix V (right singular vectors), where V^T is the transpose.
///
/// The algorithm follows these steps:
///
///  1. Bidiagonalization of the input matrix using Householder reflections
///  2. Generation of U matrix from accumulated transformations
///  3. Generation of V matrix from accumulated transformations
///  4. Iterative refinement of singular values using QR-like iterations
///
/// Numerical stability is maintained using epsilon values and proper handling
/// of edge cases. The singular values are computed iteratively until
/// convergence.
/// {@endtemplate}
abstract base class SingleValueDecomposition<K, T extends Matrix<K>>
    extends Decomposition<K, T> {
  /// {@macro svd_class_header}
  ///
  /// The [matrix] can be any rectangular matrix. SVD always exists for any
  /// matrix, unlike some other decompositions.
  const SingleValueDecomposition({required super.matrix});

  /// Computes the `E`, `U` and `V` matrices of the SVD algorithm.
  ///
  /// This method returns the matrices that satisfy the decomposition:
  ///
  ///  - A = U x E x V^T
  ///
  /// where:
  /// - U is a unitary matrix containing the left singular vectors
  /// - E is a rectangular diagonal matrix with singular values on the diagonal
  ///   (ordered from largest to smallest)
  /// - V is a unitary matrix containing the right singular vectors
  /// - V^T is the transpose of V
  ///
  /// The returned list contains:
  /// - `E` at index 0 (the singular value matrix)
  /// - `U` at index 1 (left singular vectors)
  /// - `V` at index 2 (right singular vectors, not transposed)
  ///
  /// Returns a list of three matrices that satisfy the SVD decomposition.
  ///
  /// Throws an [ArgumentError] if the matrix dimensions are invalid, or an
  /// [Exception] if the SVD algorithm fails to converge or encounters
  /// numerical issues.
  @override
  List<T> decompose();
}
