import 'package:equations/equations.dart';

/// Abstract class representing an **interpolation** strategy that finds new
/// data points based on a given discrete set of data points, called **nodes**.
/// The algorithms implemented by this package are:
///
///  - [LinearInterpolation];
///  - [PolynomialInterpolation];
///  - [NewtonInterpolation];
///  - [SplineInterpolation].
///
/// Subclasses of [Interpolation] should only override the `compute()` method.
abstract class Interpolation {
  /// The interpolation nodes.
  final List<InterpolationNode> nodes;

  /// Creates an [Interpolation] object with the given nodes.
  const Interpolation({
    required this.nodes,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Interpolation) {
      // The lengths of the coefficients must match.
      if (nodes.length != other.nodes.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements
      // are equal, then the counter will match the actual length of the
      // coefficients list.
      var equalsCount = 0;

      for (var i = 0; i < nodes.length; ++i) {
        if (nodes[i] == other.nodes[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType && equalsCount == nodes.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < nodes.length; ++i) {
      result = result * 37 + nodes[i].hashCode;
    }

    return result;
  }

  /// Returns the `y` value of the `y = f(x)` equation.
  ///
  /// The function `f` is built by interpolating the given [nodes] nodes. The
  /// [x] value is the point at which the function has to be evaluated.
  double compute(double x);
}
