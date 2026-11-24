import 'dart:math';

import 'package:equations/equations.dart';

/// {@template polynomial_interpolation}
/// Polynomial interpolation using **Lagrange's interpolation formula** to find
/// the unique polynomial of degree `n-1` that passes through `n` given data
/// points.
///
/// The [compute] method uses the barycentric form of Lagrange's formula, which
/// evaluates the interpolating polynomial directly without solving a system
/// of equations.
///
/// ## Requirements
///
/// - **At least 2 nodes** are required for interpolation
/// - **All x-values must be finite and distinct** (otherwise an
///   [InterpolationException] is thrown)
/// - Nodes can be in any order (sorting is not required)
///
/// ## Limitations
///
/// - **Runge's phenomenon**: For large numbers of equally-spaced nodes, the
///   interpolating polynomial may oscillate wildly between nodes, especially
///   near the edges of the interval. Consider using [SplineInterpolation] for
///   large datasets.
/// - **Numerical stability**: The coefficients returned by [buildPolynomial]
///   can be very sensitive to rounding errors for large datasets or when
///   nodes are close together.
///
/// ## When to Use
///
/// - Small datasets (typically < 10-15 nodes)
/// - When you need the exact polynomial expression
/// - When nodes are not equally spaced
/// - When you need to evaluate at many different points (the polynomial can be
///   built once with [buildPolynomial] and reused)
/// {@endtemplate}
base class PolynomialInterpolation extends Interpolation {
  /// {@macro polynomial_interpolation}
  ///
  /// **Note**: Validation of nodes (checking for duplicates and minimum count)
  /// is performed lazily when [compute] or [buildPolynomial] is called. Invalid
  /// nodes will cause an [InterpolationException] to be thrown at that time.
  const new({
    required super.nodes,
  });

  /// Relative tolerance used by [buildPolynomial] to discard negligible
  /// leading coefficients.
  static const _trimTolerance = 1.0e-12;

  /// Validates that the nodes meet the requirements for polynomial
  /// interpolation.
  ///
  /// Throws an [InterpolationException] if:
  /// - There are fewer than 2 nodes
  /// - There are x values that are NaN or infinite
  /// - There are duplicate x-values in the nodes
  void _validateNodes() {
    if (nodes.length < 2) {
      throw const InterpolationException(
        'At least 2 nodes are required for polynomial interpolation.',
      );
    }

    final xValues = <double>{};
    for (final node in nodes) {
      if (!node.x.isFinite) {
        throw InterpolationException(
          'Invalid x value found: ${node.x}. All x values must be finite '
          'numbers.',
        );
      }

      // 'add' returns false when the value is already in the set
      if (!xValues.add(node.x)) {
        throw InterpolationException(
          'Duplicate x-value found: ${node.x}. All x-values must be distinct '
          'for polynomial interpolation.',
        );
      }
    }
  }

  /// Evaluates the Lagrange interpolation polynomial at the given point [x].
  ///
  /// This method uses the **barycentric form** of Lagrange's formula, which
  /// is numerically more stable than evaluating each Lagrange basis polynomial
  /// `L_i(x)` separately:
  ///
  /// ```txt
  /// w_i  = 1 / ((x_i - x_0) * ... * (x_i - x_(n-1)))   (skipping j = i)
  /// p(x) = sum(w_i * y_i / (x - x_i)) / sum(w_i / (x - x_i))
  /// ```
  ///
  /// Each call costs `O(n^2)` operations, where `n` is the number of nodes. To
  /// evaluate the same interpolation at many points, consider calling
  /// [buildPolynomial] once and evaluating the returned [Algebraic] instead.
  @override
  double compute(double x) {
    _validateNodes();

    for (final node in nodes) {
      if (x == node.x) {
        return node.y;
      }
    }

    var numerator = 0.0;
    var denominator = 0.0;

    for (var i = 0; i < nodes.length; i++) {
      var weight = 1.0;
      for (var j = 0; j < nodes.length; j++) {
        if (i != j) {
          weight /= nodes[i].x - nodes[j].x;
        }
      }

      final term = weight / (x - nodes[i].x);
      numerator += term * nodes[i].y;
      denominator += term;
    }

    return numerator / denominator;
  }

  /// Computes the interpolation polynomial and returns it as an [Algebraic]
  /// object.
  ///
  /// The polynomial is built in two steps, both costing `O(n^2)` operations
  /// and `O(n)` memory, where `n` is the number of nodes:
  ///
  /// 1. The **divided differences** `c_k = f[x_0, ..., x_k]` are computed, so
  ///    that the polynomial in Newton form is
  ///    `p(x) = c_0 + (x - x_0)(c_1 + (x - x_1)(c_2 + ...))`.
  /// 2. The Newton form is expanded from the innermost term outwards, which
  ///    gives the coefficients of `x^0, x^1, ..., x^(n-1)`.
  ///
  /// No linear system is solved, which is both faster and more accurate than
  /// solving the Vandermonde system with a general purpose solver.
  ///
  /// Even so, representing a polynomial by its coefficients becomes
  /// **ill-conditioned** for large numbers of nodes (more than 15-20): small
  /// changes in the data can produce large changes in the coefficients. For
  /// large datasets, consider using [SplineInterpolation] instead.
  Algebraic buildPolynomial() {
    _validateNodes();
    final n = nodes.length;

    // Divided differences, computed in place: c[k] = f[x_0, ..., x_k]
    final c = nodes.map((node) => node.y).toList(growable: false);
    for (var k = 1; k < n; k++) {
      for (var i = n - 1; i >= k; i--) {
        c[i] = (c[i] - c[i - 1]) / (nodes[i].x - nodes[i - k].x);
      }
    }

    // Expanding the Newton form from the innermost term outwards. At each
    // step q(x) becomes q(x) * (x - x_k) + c[k]. The value a[j] is the
    // coefficient of x^j.
    final a = List<double>.filled(n, 0)..first = c.last;
    for (var k = n - 2; k >= 0; k--) {
      final xk = nodes[k].x;
      for (var j = n - 1 - k; j >= 1; j--) {
        a[j] = a[j - 1] - xk * a[j];
      }
      a.first = c[k] - xk * a.first;
    }

    // Algebraic expects the coefficients from the highest degree to the lowest
    final coefficients = a.reversed.toList(growable: false);

    return Algebraic.fromReal(_trimLeadingCoefficients(coefficients));
  }

  /// Removes the leading coefficients of [coefficients] (sorted from the
  /// highest degree to the lowest) that are negligible.
  ///
  /// The coefficient `c` of `x^k` is negligible when its largest contribution
  /// over the nodes, `|c| * max(|x(i)|)^k`, is at most [_trimTolerance] times
  /// the largest absolute y value. This removes both exact zeros (which would
  /// make [Algebraic.fromReal] throw) and the rounding noise that can appear
  /// when the nodes lie on a polynomial of lower degree.
  ///
  /// At least one coefficient is always kept, so the zero polynomial is
  /// returned as `[0]`.
  List<double> _trimLeadingCoefficients(List<double> coefficients) {
    final maxX = nodes.map((node) => node.x.abs()).reduce(max);
    final maxY = nodes.map((node) => node.y.abs()).reduce(max);
    final threshold = _trimTolerance * maxY;

    var start = 0;
    while (start < coefficients.length - 1) {
      final degree = coefficients.length - 1 - start;
      final contribution = coefficients[start].abs() * pow(maxX, degree);

      if (contribution > threshold) {
        break;
      }

      start++;
    }

    return coefficients.sublist(start);
  }
}
