import 'package:equations/src/interpolation/utils/spline_function.dart';

/// Represents a linear spline from a given set of control points. The
/// interpolated curve will be monotonic if the control points.
final class LinearSpline extends SplineFunction {
  /// Creates a [LinearSpline] object from the given nodes.
  const LinearSpline({
    required super.nodes,
  });

  @override
  double interpolate(double x) {
    // Linear spline creation
    final nodesM = List<double>.generate(
      nodes.length - 1,
      (i) => (nodes[i + 1].y - nodes[i].y) / (nodes[i + 1].x - nodes[i].x),
      growable: false,
    );

    // Interpolating
    if (x.isNaN) {
      return x;
    }

    if (x < nodes.first.x) {
      return nodes.first.y;
    }

    if (x >= nodes.last.x) {
      return nodes.last.y;
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

    return nodes[i].y + nodesM[i] * (x - nodes[i].x);
  }
}
