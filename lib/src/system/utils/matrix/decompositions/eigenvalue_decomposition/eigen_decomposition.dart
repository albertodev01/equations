import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/decomposition.dart';

/// {@template eigendecomposition_class_header}
/// Eigendecomposition, also known as spectral decomposition, is a decomposition
/// of a matrix A into a product `A = V x D x V^-1` where:
///
///   - V is a square matrix whose i<sup>th</sup> column is the eigenvector of A;
///   - D is the diagonal matrix whose diagonal elements are the corresponding
///   eigenvalues of A;
///   - V^-1 is the inverse of V.
/// {@endtemplate}
abstract class EigenDecomposition<K, T extends Matrix<K>>
    extends Decomposition<K, T> {
  /// Creates a [EigenDecomposition] object.
  const EigenDecomposition({
    required super.matrix,
  });

  /// Computes the `V`, `D` and `V^-1` matrices of the eigendecomposition
  /// algorithm. In particular, this method returns the `V`, `D and `V^-1`
  /// matrices of the
  ///
  ///  - A = V x D x V^-1
  ///
  /// relation. The returned list contains `V` at index 0, `D` at index 1 and
  /// `V^-1` at index 2.
  @override
  List<T> decompose();
}
