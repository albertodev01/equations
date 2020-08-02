import 'package:equations/src/system/decomposition/decomposition.dart';
import 'package:equations/src/system/util/matrix.dart';

/// The LU decomposition factors a matrix as the product of a lower triangular
/// matrix (L) and an upper triangular matrix (U).
///
/// A given matrix _M_ is factorized so that it can be represented as _L x U_
/// where _x_ represents the matrix-product of _L_ and _U_.
class LU implements Decomposition {

  /// The LU decomposition algorithm
  const LU();

  @override
  Future<List<Matrix>> decompose(Matrix matrix) async {
    return [];
  }

}