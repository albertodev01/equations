import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/decomposition.dart';

/// {@template eigendecomposition_class_header}
/// Eigendecomposition, also known as spectral decomposition, is a decomposition
/// of a matrix A into a product `A = V x D x V^-1` where:
///
///  - V is a square matrix whose i<sup>th</sup> column is the eigenvector of A;
///  - D is the diagonal matrix whose diagonal elements are the corresponding
///    eigenvalues of A;
///  - V^-1 is the inverse of V.
///
/// Eigendecomposition is only possible for diagonalizable (non-defective)
/// matrices. For symmetric (Hermitian, if complex) matrices, the eigenvectors
/// are orthogonal and the decomposition is particularly stable.
/// {@endtemplate}
///
/// {@template eigendecomposition_characteristics}
/// The implementation uses different algorithms depending on the matrix type:
///
/// - **Symmetric matrices**: Uses Householder reduction to tridiagonal form,
///   followed by the QL algorithm for diagonalization
/// - **Non-symmetric matrices**: Uses Hessenberg reduction followed by
///   conversion to real Schur form
/// {@endtemplate}
abstract base class EigenDecomposition<K, T extends Matrix<K>>
    extends Decomposition<K, T> {
  /// {@macro eigendecomposition_class_header}
  const new({required super.matrix});

  /// Computes the `V`, `D` and `V^-1` matrices of the eigendecomposition
  /// algorithm.
  ///
  /// This method returns the matrices that satisfy the decomposition:
  ///
  ///  - A = V x D x V^-1
  ///
  /// where:
  /// - V is the matrix of eigenvectors (each column is an eigenvector)
  /// - D is the diagonal matrix of eigenvalues
  /// - V^-1 is the inverse of V
  ///
  /// The returned list contains:
  /// - `V` at index 0
  /// - `D` at index 1
  /// - `V^-1` at index 2
  ///
  /// Throws a [MatrixException] if the matrix is not square, if it contains
  /// NaN or infinite values, or if it is not diagonalizable. A matrix is
  /// considered not diagonalizable when `V` is singular or so ill-conditioned
  /// that `V x D x V^-1` doesn't reconstruct the matrix accurately (relative
  /// error above about `1e-8`), which happens with (nearly) defective
  /// matrices.
  @override
  List<T> decompose();
}
