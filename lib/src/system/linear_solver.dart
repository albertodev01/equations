import 'package:equations/src/system/decomposition/decomposition.dart';
import 'package:equations/src/system/decomposition/lu_decomposition.dart';
import 'package:equations/src/system/util/matrix.dart';

/// Reference = http://home.apache.org/~luc/commons-math-3.6-RC2-site/jacoco/org.apache.commons.math3.linear/
class LinearSystem {
  final Matrix _matrix;

  const LinearSystem(Matrix system) : _matrix = system;

  LinearSystem.fromLists(List<List<double>> source) : _matrix = Matrix(source);

  /// - Computers usually solve square systems of linear equations using LU decomposition,
  ///
  /// - When possible, prefer using Cholesky which is faster than LU
  ///
  /// - QR is good for ill-conditioned systems and non-square systems.
  ///   One particular application of the QR factorization is to find least squares
  ///   solutions to overdetermined systems, by solving the system of normal equations
  Future<List<double>> solve({Decomposition decomposition = const LU()}) async {
    return [];
  }

}