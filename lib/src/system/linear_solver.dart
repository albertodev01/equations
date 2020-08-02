import 'package:equations/src/system/decomposition/decomposition.dart';
import 'package:equations/src/system/decomposition/lu_decomposition.dart';
import 'package:equations/src/system/util/matrix.dart';

class LinearSystem {
  final Matrix _matrix;

  const LinearSystem(Matrix system) : _matrix = system;

  LinearSystem.fromLists(List<List<double>> source) : _matrix = Matrix(source);

  Future<List<double>> solve({Decomposition decomposition = const LU()}) async {
    return [];
  }

}