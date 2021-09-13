import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_functions/linear_spline.dart';
import 'package:equations/src/interpolation/utils/spline_functions/montone_cubic_spline.dart';

export 'spline_functions/linear_spline.dart';
export 'spline_functions/montone_cubic_spline.dart';

/// A **spline** is a special function defined piecewise by polynomials. In
/// interpolating problems, spline interpolation is often preferred to polynomial
/// interpolation because it yields similar results, even when using low-degree
/// polynomials, while avoiding Runge's phenomenon for higher degrees.
abstract class SplineFunction {
  /// The interpolation nodes.
  final List<InterpolationNode> nodes;

  /// Creates an instance of [Interpolation] with the given nodes.
  const SplineFunction({
    required this.nodes,
  });

  /// Creates an appropriate spline based on the properties of the given nodes.
  ///
  /// If the control points are monotonic then the resulting spline will preserve
  /// that. This method can either return:
  ///
  ///  - [MonotoneCubicSpline] if nodes are monotonic
  ///  - [LinearSpline] otherwise.
  ///
  /// The control points must all have increasing `x` values.
  factory SplineFunction.generate({
    required List<InterpolationNode> nodes,
  }) {
    if (!_isStrictlyIncreasing(nodes)) {
      throw const InterpolationException(
        'The control points must all have increasing "x" values.',
      );
    }

    if (_isMonotonic(nodes)) {
      return MonotoneCubicSpline(nodes: nodes);
    } else {
      return LinearSpline(nodes: nodes);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is SplineFunction) {
      // The lengths of the coefficients must match
      if (nodes.length != other.nodes.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements are
      // equal, then the counter will match the actual length of the coefficients
      // list.
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

  @override
  String toString() => nodes.join(', ');

  /// Determines whether the `x` coordinates of the control points are
  /// increasing or not.
  static bool _isStrictlyIncreasing(List<InterpolationNode> nodes) {
    if (nodes.length < 2) {
      throw const InterpolationException(
        'There must be at least 2 control points.',
      );
    }

    // The "comparison" node.
    var prev = nodes[0].x;

    // Making sure that all of the 'X' coordinates of the nodes are increasing
    for (var i = 1; i < nodes.length; ++i) {
      final curr = nodes[i].x;

      if (curr <= prev) {
        return false;
      }

      prev = curr;
    }

    return true;
  }

  /// Determines whether the function is monotonic or not.
  static bool _isMonotonic(List<InterpolationNode> nodes) {
    // The "comparison" node.
    var prev = nodes[0].y;

    // Making sure that all of the 'y' coordinates of the nodes are increasing
    for (var i = 1; i < nodes.length; ++i) {
      final curr = nodes[i].y;

      if (curr < prev) {
        return false;
      }

      prev = curr;
    }

    return true;
  }

  /// Estimates the `y` value of the `y = f(x)` equation using a spline.
  ///
  /// Clamps [x] to the domain of the spline.
  double interpolate(double x);
}
