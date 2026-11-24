import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';
import 'package:equations/src/utils/math_utils.dart';

/// {@template monotone_cubic_spline}
/// Represents a monotone cubic spline from a given set of control points.
///
/// The spline is guaranteed to pass through each control point exactly. In
/// addition, if the control points are monotonic (either non-decreasing or
/// non-increasing), the interpolated values will also be monotonic.
/// {@endtemplate}
final class MonotoneCubicSpline extends SplineFunction with MathUtils {
  /// {@macro monotone_cubic_spline}
  const new({
    required super.nodes,
  });

  /// Computes the tangents of the spline at each node, using the
  /// Fritsch-Carlson method to preserve monotonicity.
  ///
  /// Throws an [InterpolationException] if the `x` values are not strictly
  /// increasing or if the `y` values are not monotonic.
  List<double> _computeTangents() {
    final tangents = List<double>.filled(nodes.length, 0);
    final secants = List<double>.filled(nodes.length - 1, 0);
    for (var i = 0; i < nodes.length - 1; ++i) {
      final h = nodes[i + 1].x - nodes[i].x;

      if (h <= 0) {
        throw const InterpolationException(
          'The control points must all have strictly increasing "x" values.',
        );
      }

      secants[i] = (nodes[i + 1].y - nodes[i].y) / h;
    }

    tangents.first = secants.first;
    for (var i = 1; i < nodes.length - 1; i++) {
      tangents[i] = (secants[i - 1] + secants[i]) * 0.5;
    }

    tangents.last = secants.last;
    for (var i = 0; i < nodes.length - 1; i++) {
      if (secants[i] == 0) {
        tangents[i] = 0;
        tangents[i + 1] = 0;
      } else {
        final a = tangents[i] / secants[i];
        final b = tangents[i + 1] / secants[i];

        if (a < 0 || b < 0) {
          throw const InterpolationException(
            'The control points must have monotonic "y" values.',
          );
        }

        final h = hypot(a, b);

        if (h > 3) {
          final t = 3 / h;
          tangents[i] *= t;
          tangents[i + 1] *= t;
        }
      }
    }

    return tangents;
  }

  @override
  double interpolate(double x) {
    if (x.isNaN) {
      return x;
    }
    final tangents = _computeTangents();

    if (x < nodes.first.x) {
      return nodes.first.y;
    }
    if (x >= nodes.last.x) {
      return nodes.last.y;
    }

    final i = findSegment(x);
    if (x == nodes[i].x) {
      return nodes[i].y;
    }

    final h = nodes[i + 1].x - nodes[i].x;
    final t = (x - nodes[i].x) / h;
    final k = 1 - t;

    return (nodes[i].y * (1 + t * 2) + h * tangents[i] * t) * k * k +
        (nodes[i + 1].y * (3 - t * 2) + h * tangents[i + 1] * (t - 1)) * t * t;
  }
}
