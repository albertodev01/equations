import 'package:equations/equations.dart';
import 'package:equations/src/utils/factorial.dart';

/// Newton interpolation is an interpolation polynomial for a given set of data
/// points. It can be expressed using forward or backward divided differences.
base class NewtonInterpolation extends Interpolation {
  /// Required to compute the factorial of a number.
  static const _factorial = Factorial();

  /// When `true`, the Newton interpolation with forward differences is used.
  /// When `false`, the Newton interpolation with backward differences is used.
  ///
  /// By default, this is set to `true`.
  final bool forwardDifference;

  /// Creates a [NewtonInterpolation] instance from the given interpolation
  /// nodes.
  const NewtonInterpolation({
    required super.nodes,
    this.forwardDifference = true,
  });

  @override
  double compute(double x) {
    if (forwardDifference) {
      return _forwardEvaluation(forwardDifferenceTable(), x);
    }

    return _backwardEvaluation(backwardDifferenceTable(), x);
  }

  /// Computes the u of the formula, where `u = (x – a)/h`.
  double _computeU(double u, int n) {
    var temp = u;
    for (var i = 1; i < n; i++) {
      temp = temp * (u - i);
    }

    return temp;
  }

  /// Evaluates the function on a given [x] point using the forward differences
  /// table.
  double _forwardEvaluation(RealMatrix differencesTable, double x) {
    var sum = differencesTable(0, 0);
    final u = (x - nodes.first.x) / (nodes[1].x - nodes.first.x);

    for (var i = 1; i < differencesTable.rowCount; i++) {
      final fact = _factorial.compute(i);
      sum += (_computeU(u, i) * differencesTable(0, i)) / fact;
    }

    return sum;
  }

  /// Evaluates the function on a given [x] point using the backward differences
  /// table.
  double _backwardEvaluation(RealMatrix differencesTable, double x) {
    final size = nodes.length - 1;
    var sum = differencesTable(size, 0);
    final u = (x - nodes[size].x) / (nodes[1].x - nodes.first.x);

    for (var i = 1; i < differencesTable.rowCount; i++) {
      final fact = _factorial.compute(i);
      sum += (_computeU(u, i) * differencesTable(size, i)) / fact;
    }

    return sum;
  }

  /// Computes the forward differences table and stores the results in a
  /// [RealMatrix] object.
  RealMatrix forwardDifferenceTable() {
    final size = nodes.length;
    final table = List<List<double>>.generate(
      size,
      (_) => List<double>.generate(size, (_) => 0, growable: false),
      growable: false,
    );

    // Initializing the column
    var index = 0;
    for (final node in nodes) {
      table[index++].first = node.y;
    }

    // Forward difference table
    for (var i = 1; i < size; i++) {
      for (var j = 0; j < size - i; j++) {
        table[j][i] = table[j + 1][i - 1] - table[j][i - 1];
      }
    }

    return RealMatrix.fromData(
      columns: size,
      rows: size,
      data: table,
    );
  }

  /// Computes the backward differences table and stores the results in a
  /// [RealMatrix] object.
  RealMatrix backwardDifferenceTable() {
    final size = nodes.length;
    final table = List<List<double>>.generate(
      size,
      (_) => List<double>.generate(size, (_) => 0, growable: false),
      growable: false,
    );

    // Initializing the column
    var index = 0;
    for (final node in nodes) {
      table[index++].first = node.y;
    }

    // Backward difference table
    for (var i = 1; i < size; i++) {
      for (var j = size - 1; j >= i; j--) {
        table[j][i] = table[j][i - 1] - table[j - 1][i - 1];
      }
    }

    return RealMatrix.fromData(
      columns: size,
      rows: size,
      data: table,
    );
  }
}
