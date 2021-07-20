import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/real_matrix.dart';

/// Newton interpolation is an interpolation polynomial for a given set of data
/// points. It can be expressed using forward or backward divided differences.
class NewtonInterpolation extends Interpolation {
  /// When `true`, the Newton interpolation with forward differences is used.
  /// When `false`, the Newton interpolation with backward differences is used.
  ///
  /// By default, this is set to `true`.
  final bool forwardDifference;

  /// Creates a [NewtonInterpolation] instance from the given interpolation
  /// nodes.
  const NewtonInterpolation({
    required List<InterpolationNode> nodes,
    this.forwardDifference = true,
  }) : super(nodes);

  @override
  double compute(double x) {
    late final RealMatrix matrix;

    if (forwardDifference) {
      matrix = forwardDifferenceTable();
      return _forwardEvaluation(matrix, x);
    } else {
      matrix = backwardDifferenceTable();
      return _backwardEvaluation(matrix, x);
    }
  }

  /// Efficiently computes the factorial of a number using a cache.
  int _factorial(int n) {
    if (_factorialsCache.containsKey(n)) {
      return _factorialsCache[n]!;
    }

    return n * _factorial(n - 1);
  }

  /// Computes the u of the formula, where `u = (x – a)/h`.
  double _computeU(double u, int n) {
    var temp = u;
    for (int i = 1; i < n; i++) {
      temp = temp * (u - i);
    }
    return temp;
  }

  /// Evaluates the function on a given [x] point using the forward differences
  /// table.
  double _forwardEvaluation(RealMatrix differencesTable, double x) {
    var sum = differencesTable(0, 0);
    final u = (x - nodes[0].x) / (nodes[1].x - nodes[0].x);

    for (var i = 1; i < differencesTable.rowCount; i++) {
      sum += (_computeU(u, i) * differencesTable(0, i)) / _factorial(i);
    }

    return sum;
  }

  /// Evaluates the function on a given [x] point using the backward differences
  /// table.
  double _backwardEvaluation(RealMatrix differencesTable, double x) {
    final size = nodes.length - 1;
    var sum = differencesTable(size, 0);
    final u = (x - nodes[size].x) / (nodes[1].x - nodes[0].x);

    for (var i = 1; i < differencesTable.rowCount; i++) {
      sum += (_computeU(u, i) * differencesTable(size, i)) / _factorial(i);
    }

    return sum;
  }

  /// Computes the forward differences table and stores the results in a
  /// [RealMatrix] object.
  RealMatrix forwardDifferenceTable() {
    final size = nodes.length;
    final table = List<List<double>>.generate(
      size,
      (_) => List<double>.generate(size, (_) => 0),
    );

    // Initializing the column
    var index = 0;
    for (final node in nodes) {
      table[index++][0] = node.y;
    }

    // Forward difference table
    for (var i = 1; i < size; i++) {
      for (int j = 0; j < size - i; j++) {
        table[j][i] = table[j + 1][i - 1] - table[j][i - 1];
      }
    }

    return RealMatrix.fromData(columns: size, rows: size, data: table);
  }

  /// Computes the backward differences table and stores the results in a
  /// [RealMatrix] object.
  RealMatrix backwardDifferenceTable() {
    final size = nodes.length;
    final table = List<List<double>>.generate(
      size,
      (_) => List<double>.generate(size, (_) => 0),
    );

    // Initializing the column
    var index = 0;
    for (final node in nodes) {
      table[index++][0] = node.y;
    }

    // Forward difference table
    for (var i = 1; i < size; i++) {
      for (int j = size - 1; j >= i; j--) {
        table[j][i] = table[j][i - 1] - table[j - 1][i - 1];
      }
    }

    return RealMatrix.fromData(columns: size, rows: size, data: table);
  }
}

final _factorialsCache = <int, int>{
  0: 1,
  1: 1,
  2: 2,
  3: 6,
  4: 24,
  5: 120,
  6: 720,
  7: 5040,
  8: 40320,
  9: 362880,
  10: 3628800,
  11: 39916800,
  12: 479001600,
  13: 6227020800,
  14: 87178291200,
  15: 1307674368000,
  16: 20922789888000,
  17: 355687428096000,
  18: 6402373705728000,
  19: 121645100408832000,
  20: 2432902008176640000,
};
