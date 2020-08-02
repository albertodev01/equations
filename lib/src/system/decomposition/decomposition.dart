import 'package:equations/src/system/util/matrix.dart';

/// Implements the _Strategy Pattern_ in order to define a series of ways to
/// factorize a matrix into a product of matrices.
abstract class Decomposition {

  /// Performs matrix decomposition, which is representing a matrix as product
  /// of matrices.
  Future<List<Matrix>> decompose(Matrix matrix);

}