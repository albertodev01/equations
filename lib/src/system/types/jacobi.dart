import 'package:equations/src/system/system.dart';

/// TODO
class Jacobi extends SystemSolver {
  /// TODO
  Jacobi({
    required List<List<double>> equations,
    required List<double> constants,
  }) : super(A: equations, b: constants, size: constants.length);

  @override
  List<double> solve() {
    return [];
  }
}
