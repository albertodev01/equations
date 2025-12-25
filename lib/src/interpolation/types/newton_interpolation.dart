import 'package:equations/equations.dart';
import 'package:equations/src/utils/factorial.dart';

/// {@template newton_interpolation}
/// Newton interpolation (also known as Newton's divided difference
/// interpolation) is a polynomial interpolation method that constructs an
/// interpolation polynomial for a given set of data points using divided
/// differences.
///
/// This implementation supports both **forward differences** and **backward
/// differences**:
///
/// - **Forward differences**: Best used when interpolating near the beginning
///   of the data set (i.e., when `x` is close to the first node's x-value).
///   The formula uses Newton's forward difference formula.
///
/// - **Backward differences**: Best used when interpolating near the end of
///   the data set (i.e., when `x` is close to the last node's x-value).
///   The formula uses Newton's backward difference formula.
///
/// ## Requirements
///
/// The interpolation nodes should be **equally spaced** for optimal accuracy.
/// While the algorithm will work with unequally spaced nodes, the results may
/// be less accurate.
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
  /// Required to compute the factorial of a number.
  static const _factorial = Factorial();

  /// When true, the algorithm uses forward differences.
  /// When false, the algorithm uses backward differences.
  ///
  /// **Forward differences** are typically more accurate when interpolating
  /// near the beginning of the data set, while **backward differences** are
  /// better for interpolation near the end of the data set.
  ///
  /// By default, this is set to `true`.
  final bool forwardDifference;

  /// {@macro newton_interpolation}
  ///
  /// The [nodes] should be equally spaced for best results. The
  /// [forwardDifference] parameter determines which difference formula to use.
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

  /// Computes the product `u(u-1)(u-2)...(u-(n-1))` used in Newton's
  /// interpolation formulas.
  ///
  /// This method computes the falling factorial `u(u-1)(u-2)...(u-(n-1))` which
  /// is used in both forward and backward difference formulas:
  ///
  /// - **Forward differences**: Directly uses `u(u-1)(u-2)...` where `u ≥ 0`
  ///   (when `x ≥ x₀`).
  ///
  /// - **Backward differences**: Uses the same formula, but since `u` is
  ///   typically negative (when `x < xₙ`), the pattern `u(u-1)(u-2)...` with
  ///   negative `u` produces the correct alternating signs needed for the
  ///   backward difference formula.
  ///
  /// The parameter [u] is the normalized value:
  /// - For forward differences: `u = (x - x₀)/h`
  /// - For backward differences: `u = (x - xₙ)/h`
  ///
  /// where `h` is the step size between nodes.
  ///
  /// The parameter [n] represents the order of the difference being computed
  /// (1 for first-order, 2 for second-order, etc.).
  double _computeU(double u, int n) {
    var temp = u;
    for (var i = 1; i < n; i++) {
      temp = temp * (u - i);
    }

    return temp;
  }

  /// Evaluates the interpolation polynomial at point [x] using Newton's forward
  /// difference formula.
  double _forwardEvaluation(RealMatrix differencesTable, double x) {
    // Start with f(x₀), the first value in the difference table
    var sum = differencesTable(0, 0);

    // Compute normalized x-value: u = (x - x₀) / h
    // where h is the step size between consecutive nodes
    final stepSize = nodes[1].x - nodes.first.x;
    final u = (x - nodes.first.x) / stepSize;

    // Add terms: u·Δf(x₀)/1! + u(u-1)·Δ²f(x₀)/2! + ...
    for (var i = 1; i < differencesTable.rowCount; i++) {
      final fact = _factorial.compute(i);
      sum += (_computeU(u, i) * differencesTable(0, i)) / fact;
    }

    return sum;
  }

  /// Evaluates the interpolation polynomial at point [x] using Newton's
  /// backward difference formula.
  double _backwardEvaluation(RealMatrix differencesTable, double x) {
    final size = nodes.length - 1;

    // Start with f(xₙ), the last value in the difference table
    var sum = differencesTable(size, 0);

    // Compute normalized x-value: u = (x - xₙ) / h
    // where h is the step size between consecutive nodes
    // For backward differences, use the spacing between the last two nodes
    final stepSize = nodes[size].x - nodes[size - 1].x;
    final u = (x - nodes[size].x) / stepSize;

    // Add terms: u·∇f(xₙ)/1! + u(u+1)·∇²f(xₙ)/2! + ...
    // Note: Since u is typically negative (x < xₙ), _computeU(u, i) with
    // negative u effectively computes u(u+1)(u+2)... for backward differences
    for (var i = 1; i < differencesTable.rowCount; i++) {
      final fact = _factorial.compute(i);
      sum += (_computeU(u, i) * differencesTable(size, i)) / fact;
    }

    return sum;
  }

  /// Computes the forward differences table and stores the results in a
  /// [RealMatrix] object.
  ///
  /// The first row (row 0) contains the differences used in Newton's forward
  /// difference formula.
  ///
  /// Returns a square matrix of size `n × n` where `n` is the number of nodes.
  RealMatrix forwardDifferenceTable() {
    final size = nodes.length;
    final table = List<List<double>>.generate(
      size,
      (_) => List<double>.generate(size, (_) => 0, growable: false),
      growable: false,
    );

    // Initialize the first column with the function values f(xᵢ)
    var index = 0;
    for (final node in nodes) {
      table[index++].first = node.y;
    }

    // Compute forward differences: Δᵏf(xᵢ) = Δᵏ⁻¹f(xᵢ₊₁) - Δᵏ⁻¹f(xᵢ)
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
  /// backward difference formula.
  ///
  /// Returns a square matrix of size `n × n` where `n` is the number of nodes.
  RealMatrix backwardDifferenceTable() {
    final size = nodes.length;
    final table = List<List<double>>.generate(
      size,
      (_) => List<double>.generate(size, (_) => 0, growable: false),
      growable: false,
    );

    // Initialize the first column with the function values f(xᵢ)
    var index = 0;
    for (final node in nodes) {
      table[index++].first = node.y;
    }

    // Compute backward differences: ∇ᵏf(xᵢ) = ∇ᵏ⁻¹f(xᵢ) - ∇ᵏ⁻¹f(xᵢ₋₁)
    // Process from bottom to top to ensure dependencies are computed first
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
