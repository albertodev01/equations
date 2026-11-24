import 'package:equations/src/interpolation/utils/spline_function.dart';

/// {@template linear_spline}
/// Represents a linear spline from a given set of control points. The
/// interpolated curve will be monotonic if the control points are monotonic.
/// {@endtemplate}
final class LinearSpline extends SplineFunction {
  /// {@macro linear_spline}
  const new({
    required super.nodes,
  });

  @override
  double interpolate(double x) {
    if (x.isNaN) {
      return x;
    }
    if (x < nodes.first.x) {
      return nodes.first.y;
    }
    if (x >= nodes.last.x) {
      return nodes.last.y;
    }

    final i = findSegment(x);
    final start = nodes[i];

    if (x == start.x) {
      return start.y;
    }

    final end = nodes[i + 1];
    final slope = (end.y - start.y) / (end.x - start.x);

    return start.y + slope * (x - start.x);
  }
}
