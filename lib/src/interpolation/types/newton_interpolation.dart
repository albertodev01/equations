import 'package:equations/equations.dart';

/// {@template newton_interpolation}
/// Newton interpolation based on **finite differences**. It builds the unique
/// polynomial of degree `n-1` that passes through `n` equally spaced nodes,
/// using either Newton's forward difference formula or Newton's backward
/// difference formula.
///
/// - **Forward differences**: best used when interpolating near the beginning
///   of the data set (that is, when `x` is close to the first node's x value).
///
/// - **Backward differences**: best used when interpolating near the end of
///   the data set (that is, when `x` is close to the last node's x value).
///
/// In exact arithmetic both formulas produce the same polynomial; they only
/// differ in how rounding errors accumulate.
///
/// ## Requirements
///
/// - **At least 2 nodes** are required.
/// - The nodes must be **equally spaced**: `x(i+1) - x(i)` must be the same
///   non-zero value `h` for every `i`. Finite difference formulas are not valid
///   for unequally spaced nodes, so an [InterpolationException] is thrown by
///   [compute] in that case. Use [PolynomialInterpolation] when the nodes are
///   not equally spaced.
///
/// ## Example
///
/// ```dart
/// const interpolation = NewtonInterpolation(
///   nodes: [
///     InterpolationNode(x: 45, y: 0.7071),
///     InterpolationNode(x: 50, y: 0.766),
///     InterpolationNode(x: 55, y: 0.8192),
///     InterpolationNode(x: 60, y: 0.866),
///   ],
///   forwardDifference: true, // Use forward differences
/// );
///
/// // Interpolate at x = 52
/// final result = interpolation.compute(52);
/// print(result); // Approximately 0.788
/// ```
/// {@endtemplate}
base class NewtonInterpolation extends Interpolation {
  /// {@macro newton_interpolation}
  ///
  /// The [nodes] must be equally spaced. The [forwardDifference] parameter
  /// determines which difference formula is used.
  ///
  /// **Note**: Validation of nodes (minimum count and equal spacing) is
  /// performed lazily when [compute] is called.
  const new({
    required super.nodes,
    this.forwardDifference = true,
  });

  /// Relative tolerance used to decide whether the nodes are equally spaced.
  static const _spacingTolerance = 1.0e-9;

  /// When true, the algorithm uses forward differences.
  /// When false, the algorithm uses backward differences.
  ///
  /// **Forward differences** are typically more accurate when interpolating
  /// near the beginning of the data set, while **backward differences** are
  /// better for interpolation near the end of the data set.
  ///
  /// By default, this is set to `true`.
  final bool forwardDifference;

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is NewtonInterpolation &&
      forwardDifference == other.forwardDifference;

  @override
  int get hashCode => Object.hash(super.hashCode, forwardDifference);

  @override
  double compute(double x) {
    final stepSize = _validateNodes();

    if (forwardDifference) {
      return _evaluate(
        forwardDifferenceTable(),
        0,
        (x - nodes.first.x) / stepSize,
        rising: false,
      );
    }

    return _evaluate(
      backwardDifferenceTable(),
      nodes.length - 1,
      (x - nodes.last.x) / stepSize,
      rising: true,
    );
  }

  /// Makes sure that there are at least 2 nodes and that they are equally
  /// spaced. Returns the common step size `h = x(i+1) - x(i)`.
  ///
  /// Throws an [InterpolationException] if:
  /// - There are fewer than 2 nodes
  /// - The step size is zero or not a finite number
  /// - The nodes are not equally spaced
  double _validateNodes() {
    if (nodes.length < 2) {
      throw const InterpolationException(
        'At least 2 nodes are required for Newton interpolation.',
      );
    }

    final stepSize = nodes[1].x - nodes.first.x;

    if (stepSize == 0 || !stepSize.isFinite) {
      throw const InterpolationException(
        'The x values of the nodes must be distinct and finite.',
      );
    }

    final tolerance = _spacingTolerance * stepSize.abs();

    for (var i = 2; i < nodes.length; i++) {
      final currentStep = nodes[i].x - nodes[i - 1].x;

      // Written as a negated '<=' so that NaN values are rejected as well.
      if (!((currentStep - stepSize).abs() <= tolerance)) {
        throw const InterpolationException(
          'The nodes must be equally spaced for Newton interpolation.',
        );
      }
    }

    return stepSize;
  }

  /// Evaluates Newton's forward or backward difference formula.
  ///
  /// The [row] of the [differencesTable] holds the differences used by the
  /// formula: `f(x0), Delta f(x0), Delta^2 f(x0), ...` for the forward formula
  /// and `f(xn), Nabla f(xn), Nabla^2 f(xn), ...` for the backward formula.
  ///
  /// The parameter [u] is the normalized value:
  /// - For forward differences: `u = (x - x0) / h`
  /// - For backward differences: `u = (x - xn) / h`
  ///
  /// where `h` is the step size between nodes and `x0`, `xn` are the first and
  /// the last node respectively. The result is:
  ///
  /// - forward: `f(x0) + u * Delta f(x0) / 1! + u(u-1) * Delta^2 f(x0) / 2!
  ///   + ...`
  /// - backward: `f(xn) + u * Nabla f(xn) / 1! + u(u+1) * Nabla^2 f(xn) / 2!
  ///   + ...`
  double _evaluate(
    RealMatrix differencesTable,
    int row,
    double u, {
    required bool rising,
  }) {
    final direction = rising ? 1 : -1;
    var sum = differencesTable(row, 0);
    var coefficient = 1.0;

    for (var k = 1; k < differencesTable.columnCount; k++) {
      coefficient *= (u + direction * (k - 1)) / k;
      sum += coefficient * differencesTable(row, k);
    }

    return sum;
  }

  /// Computes the forward differences table and stores the results in a
  /// [RealMatrix] object.
  ///
  /// The first row (row 0) contains the differences used in Newton's forward
  /// difference formula. Returns a square matrix of size `n x n` where `n` is
  /// the number of nodes.
  RealMatrix forwardDifferenceTable() {
    final size = nodes.length;
    final table = List<List<double>>.generate(
      size,
      (_) => List<double>.generate(size, (_) => 0, growable: false),
      growable: false,
    );

    // Initialize the first column with the function values f(x(i))
    var index = 0;
    for (final node in nodes) {
      table[index++].first = node.y;
    }

    // Forward differences:
    // Delta^k f(x(i)) = Delta^(k-1) f(x(i+1)) - Delta^(k-1) f(x(i))
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
  ///
  /// The last row (row `n-1`) contains the differences used in Newton's
  /// backward difference formula. Returns a square matrix of size `n x n`
  /// where `n` is the number of nodes.
  RealMatrix backwardDifferenceTable() {
    final size = nodes.length;
    final table = List<List<double>>.generate(
      size,
      (_) => List<double>.generate(size, (_) => 0, growable: false),
      growable: false,
    );

    // Initialize the first column with the function values f(x(i))
    var index = 0;
    for (final node in nodes) {
      table[index++].first = node.y;
    }

    // Backward differences:
    // Nabla^k f(x(i)) = Nabla^(k-1) f(x(i)) - Nabla^(k-1) f(x(i-1))
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
