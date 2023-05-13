import 'dart:math';

import 'package:equations/equations.dart';

/// Polynomial interpolation is the interpolation of a given data set by the
/// polynomial of lowest possible degree that passes through the points of the
/// data set.
///
/// This can also be seen as a generalization of linear interpolation.
base class PolynomialInterpolation extends Interpolation {
  /// Creates a [PolynomialInterpolation] instance from the given interpolation
  /// nodes.
  const PolynomialInterpolation({
    required super.nodes,
  });

  @override
  double compute(double x) {
    var result = 0.0;

    for (var i = 0; i < nodes.length; ++i) {
      var term = nodes[i].y;
      for (var j = 0; j < nodes.length; j++) {
        if (i != j) {
          term *= (x - nodes[j].x) / (nodes[i].x - nodes[j].x);
        }
      }
      result += term;
    }

    return result;
  }

  /// Computes the interpolation polynomial and returns it as an [Algebraic]
  /// object.
  Algebraic buildPolynomial() {
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
