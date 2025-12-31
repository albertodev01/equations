import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_functions/linear_spline.dart';
import 'package:equations/src/interpolation/utils/spline_functions/montone_cubic_spline.dart';

export 'spline_functions/linear_spline.dart';
export 'spline_functions/montone_cubic_spline.dart';

/// {@template spline_function}
/// A **spline** is a special function defined piecewise by polynomials.
///
/// In interpolating problems, spline interpolation is often preferred to
/// polynomial interpolation because it yields similar results, even when using
/// low-degree polynomials, while avoiding Runge's phenomenon for higher
/// degrees.
/// {@endtemplate}
abstract base class SplineFunction {
  /// The interpolation nodes.
  final List<InterpolationNode> nodes;

  /// {@macro spline_function}
  const SplineFunction({
    required this.nodes,
  });

  /// Creates an appropriate spline based on the properties of the given nodes.
  ///
  /// If the control points are monotonic then the resulting spline will
  /// preserve that. This method can either return:
  ///
  ///  - [MonotoneCubicSpline] if nodes are monotonic
  ///  - [LinearSpline] otherwise.
  ///
  /// The control points must all have increasing `x` values.
  ///
  /// If the [nodes] doesn't contain values sorted in increasing order, then an
  /// [InterpolationException] object is thrown.
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
      if (nodes.length != other.nodes.length) {
        return false;
      }
      for (var i = 0; i < nodes.length; ++i) {
        if (nodes[i] != other.nodes[i]) {
          return false;
        }
      }

      return runtimeType == other.runtimeType;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hashAll(nodes);

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
    var prev = nodes.first.x;

    // Making sure that all of the 'X' coordinates of the nodes are increasing.
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
    var prev = nodes.first.y;

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
