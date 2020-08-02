import 'package:equations/src/system/util/matrix.dart';

/// Implements the _Strategy Pattern_ in order to define a series of ways to
/// factorize a matrix into a product of matrices.
abstract class Decomposition {
  Future<List<Matrix>> decompose();
}