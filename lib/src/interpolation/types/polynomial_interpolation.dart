import 'dart:math';

import 'package:equations/equations.dart';

/// {@template polynomial_interpolation}
/// Polynomial interpolation using **Lagrange's interpolation formula** to find
/// the unique polynomial of degree `n-1` that passes through `n` given data
/// points.
///
/// This implementation uses the Lagrange basis polynomial approach, which
/// directly constructs the interpolating polynomial without solving a system
/// of equations.
///
/// ## Requirements
///
/// - **At least 2 nodes** are required for interpolation
/// - **All x-values must be distinct** (duplicate x-values will cause division
///   by zero and throw an [InterpolationException])
/// - Nodes can be in any order (sorting is not required)
///
/// ## Limitations
///
/// - **Runge's phenomenon**: For large numbers of equally-spaced nodes, the
///   interpolating polynomial may oscillate wildly between nodes, especially
///   near the edges of the interval. Consider using [SplineInterpolation] for
///   large datasets.
/// - **Numerical stability**: The Vandermonde matrix approach used in
///   [buildPolynomial] can be ill-conditioned for large datasets or when nodes
///   are close together.
///
/// ## When to Use
///
/// - Small datasets (typically < 10-15 nodes)
/// - When you need the exact polynomial expression
/// - When nodes are not equally spaced
/// - When you need to evaluate at many different points (the polynomial can be
///   built once and reused)
/// {@endtemplate}
base class PolynomialInterpolation extends Interpolation {
  /// {@macro polynomial_interpolation}
  ///
  /// **Note**: Validation of nodes (checking for duplicates and minimum count)
  /// is performed lazily when [compute] or [buildPolynomial] is called. Invalid
  /// nodes will cause an [InterpolationException] to be thrown at that time.
  const PolynomialInterpolation({
    required super.nodes,
  });

  /// Validates that the nodes meet the requirements for polynomial
  /// interpolation.
  ///
  /// Throws an [InterpolationException] if:
  /// - There are fewer than 2 nodes
  /// - There are duplicate x-values in the nodes
  void _validateNodes() {
    if (nodes.length < 2) {
      throw const InterpolationException(
        'At least 2 nodes are required for polynomial interpolation.',
      );
    }

    // Check for duplicate x-values
    final xValues = <double>{};
    for (final node in nodes) {
      if (xValues.contains(node.x)) {
        throw InterpolationException(
          'Duplicate x-value found: ${node.x}. All x-values must be distinct '
          'for polynomial interpolation.',
        );
      }
      xValues.add(node.x);
    }
  }

  /// Evaluates the Lagrange interpolation polynomial at the given point [x].
  ///
  /// This method uses the Lagrange basis polynomial formula to compute the
  /// interpolated value. For each node `(xi, yi)`, it computes the Lagrange
  /// basis polynomial `L(x)` and multiplies it by `yi`, then sums all terms.
  ///
  /// The algorithm optimizes by computing denominators once per call and
  /// reusing them within the evaluation loop, avoiding repeated division
  /// operations.
  @override
  double compute(double x) {
    _validateNodes();

    // Early return: if x exactly matches a node's x-value, return its y-value
    for (var i = 0; i < nodes.length; i++) {
      if (x == nodes[i].x) {
        return nodes[i].y;
      }
    }

    // Precompute denominators once for this evaluation call
    // denominators[i][j] stores 1 / (nodes[i].x - nodes[j].x) for i != j
    final n = nodes.length;
    final denominators = List.generate(
      n,
      (i) => List.generate(n, (j) => 0.0, growable: false),
      growable: false,
    );

    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        if (i != j) {
          denominators[i][j] = 1.0 / (nodes[i].x - nodes[j].x);
        }
      }
    }

    // Compute using Lagrange interpolation formula
    var result = 0.0;

    for (var i = 0; i < nodes.length; i++) {
      var term = nodes[i].y;
      for (var j = 0; j < nodes.length; j++) {
        if (i != j) {
          term *= (x - nodes[j].x) * denominators[i][j];
        }
      }
      result += term;
    }

    return result;
  }

  /// Computes the interpolation polynomial and returns it as an [Algebraic]
  /// object.
  ///
  /// This method constructs the interpolating polynomial by solving a system
  /// of linear equations using the **Vandermonde matrix** approach. The
  /// Vandermonde matrix is constructed from the x-values of the nodes, and
  /// the system is solved using LU decomposition to find the polynomial
  /// coefficients.
  ///
  /// The Vandermonde matrix can be **ill-conditioned** for:
  /// - Large numbers of nodes (> 15-20)
  /// - Nodes that are close together
  /// - Equally-spaced nodes over large intervals
  ///
  /// In such cases, numerical errors may affect the accuracy of the computed
  /// coefficients. For large datasets, consider using [NewtonInterpolation] or
  /// [SplineInterpolation] instead.
  Algebraic buildPolynomial() {
    _validateNodes();
    final length = nodes.length * nodes.length;
    final matrixSource = List<double>.generate(length, (_) => 0);

    // Creating the Vandermonde matrix
    for (var i = 0; i < nodes.length; ++i) {
      for (var j = 0; j < nodes.length; ++j) {
        matrixSource[nodes.length * i + j] = pow(nodes[i].x, j) * 1.0;
      }
    }

    // Creating the known values vector
    final knownValues = nodes.map((node) => node.y).toList(growable: false);

    // Finding the coefficients by solving the system
    final lu = LUSolver(
      matrix: RealMatrix.fromFlattenedData(
        rows: nodes.length,
        columns: nodes.length,
        data: matrixSource,
      ),
      knownValues: knownValues,
    );

    final coefficients = lu.solve().reversed.toList(growable: false);

    return Algebraic.fromReal(coefficients);
  }
}
