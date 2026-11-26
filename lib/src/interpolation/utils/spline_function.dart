import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_functions/linear_spline.dart';
import 'package:equations/src/interpolation/utils/spline_functions/monotone_cubic_spline.dart';

export 'spline_functions/linear_spline.dart';
export 'spline_functions/monotone_cubic_spline.dart';

/// {@template spline_function}
/// A **spline** is a special function defined piecewise by polynomials.
///
/// In interpolation problems, spline interpolation is often preferred to
/// polynomial interpolation because it yields similar results, even when using
/// low-degree polynomials, while avoiding Runge's phenomenon for higher
/// degrees.
/// {@endtemplate}
abstract base class SplineFunction {
  /// {@macro spline_function}
  const new({
    required this.nodes,
  });

  /// Creates an appropriate spline based on the properties of the given nodes.
  ///
  /// If the control points are monotonic, then the resulting spline will
  /// preserve that. This method can either return:
  ///
  ///  - [MonotoneCubicSpline] if the `y` values of the nodes are monotonic
  ///    (either non-decreasing or non-increasing);
  ///  - [LinearSpline] otherwise.
  ///
  /// An [InterpolationException] is thrown if [nodes] contains fewer than 2
  /// control points or if their `x` values are not strictly increasing.
  factory generate({
    required List<InterpolationNode> nodes,
  }) {
    if (nodes.length < 2) {
      throw const InterpolationException(
        'There must be at least 2 control points.',
      );
    }

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

  /// The interpolation nodes.
  final List<InterpolationNode> nodes;

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

  static bool _isStrictlyIncreasing(List<InterpolationNode> nodes) {
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

  static bool _isMonotonic(List<InterpolationNode> nodes) {
    var nonDecreasing = true;
    var nonIncreasing = true;

    for (var i = 1; i < nodes.length; ++i) {
      final prev = nodes[i - 1].y;
      final curr = nodes[i].y;

      if (curr < prev) {
        nonDecreasing = false;
      }

      if (curr > prev) {
        nonIncreasing = false;
      }

      if (!nonDecreasing && !nonIncreasing) {
        return false;
      }
    }

    return true;
  }

  /// Finds, using a binary search, the index `i` of the segment containing [x]
  /// such that `nodes[i].x <= x < nodes[i + 1].x`.
  ///
  /// The caller must make sure that `nodes.first.x <= x < nodes.last.x`.
  int findSegment(double x) {
    var left = 0;
    var right = nodes.length - 2;

    while (left <= right) {
      final mid = (left + right) ~/ 2;
      if (x < nodes[mid].x) {
        right = mid - 1;
      } else if (x >= nodes[mid + 1].x) {
        left = mid + 1;
      } else {
        return mid;
      }
    }

    return left;
  }

  /// Estimates the `y` value of the `y = f(x)` equation using a spline.
  ///
  /// Clamps [x] to the domain of the spline.
  double interpolate(double x);
}
