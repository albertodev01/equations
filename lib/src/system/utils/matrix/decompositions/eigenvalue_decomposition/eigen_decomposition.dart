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
/// Eigendecomposition is only possible for diagonalizable matrices. For
/// symmetric matrices, the eigenvectors are orthogonal and the decomposition
/// is particularly stable.
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
  ///
  /// {@macro eigendecomposition_characteristics}
  const EigenDecomposition({required super.matrix});

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
  /// Returns a list of three matrices that satisfy the eigendecomposition.
  ///
  /// Throws a [MatrixException] if the matrix is not diagonalizable or if
  /// numerical issues occur during the decomposition.
  @override
  List<T> decompose();
}
