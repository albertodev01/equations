import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';
import 'package:equations/src/utils/math_utils.dart';

/// Represents a monotone cubic spline from a given set of control points.
///
/// The spline is guaranteed to pass through each control point exactly. In
/// addition, assuming the control points are monotonic, then the interpolated
/// values will also be monotonic.
class MonotoneCubicSpline extends SplineFunction with MathUtils {
  /// Creates a [MonotoneCubicSpline] instance from the given nodes.
  const MonotoneCubicSpline({
    required List<InterpolationNode> nodes,
  }) : super(nodes: nodes);

  @override
  double interpolate(double x) {
    // Monotonic cubic spline creation
    final nodesM = List<double>.generate(nodes.length, (_) => 0);
    final pointsD = List<double>.generate(nodes.length - 1, (_) => 0);

    // Slopes of secant lines between successive points
    for (var i = 0; i < nodes.length - 1; ++i) {
      final h = nodes[i + 1].x - nodes[i].x;

      if (h <= 0) {
        throw const InterpolationException(
          'The control points must all have strictly increasing "x" values.',
        );
      }

      pointsD[i] = (nodes[i + 1].y - nodes[i].y) / h;
    }

    // Initializing tangents as the average of the secants.
    nodesM[0] = pointsD[0];

    for (var i = 1; i < nodes.length - 1; i++) {
      nodesM[i] = (pointsD[i - 1] + pointsD[i]) * 0.5;
    }

    nodesM[nodes.length - 1] = pointsD[nodes.length - 2];

    // Updating tangents to preserve monotonicity.
    for (var i = 0; i < nodes.length - 1; i++) {
      if (pointsD[i] == 0) {
        // When successive 'Y' values are equals, manually set to 0
        nodesM[i] = 0;
        nodesM[i + 1] = 0;
      } else {
        final a = nodesM[i] / pointsD[i];
        final b = nodesM[i + 1] / pointsD[i];

        if (a < 0 || b < 0) {
          throw const InterpolationException(
            'The control points must have monotonic "y" values.',
          );
        }

        final h = hypot(a, b);

        if (h > 3) {
          final t = 3 / h;
          nodesM[i] *= t;
          nodesM[i + 1] *= t;
        }
      }
    }

    // Interpolating
    if (x.isNaN) {
      return x;
    }

    if (x < nodes[0].x) {
      return nodes[0].y;
    }

    if (x >= nodes[nodes.length - 1].x) {
      return nodes[nodes.length - 1].y;
    }

    // Finding the i-th element of the last point with smaller 'x'.
    // We are sure that this will be within the spline due to the previous
    // boundary tests.
    var i = 0;
    while (x >= nodes[i + 1].x) {
      ++i;

      if (x == nodes[i].x) {
        return nodes[i].y;
      }
    }

    // Cubic Hermite spline interpolation.
    final h = nodes[i + 1].x - nodes[i].x;
    final t = (x - nodes[i].x) / h;

    return (nodes[i].y * (1 + t * 2) + h * nodesM[i] * t) * (1 - t) * (1 - t) +
        (nodes[i + 1].y * (3 - t * 2) + h * nodesM[i + 1] * (t - 1)) * t * t;
  }
}
