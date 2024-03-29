import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';

/// Represents a linear spline from a given set of control points. The interpolated
/// curve will be monotonic if the control points.
class LinearSpline extends SplineFunction {
  /// Creates a [LinearSpline] instance from the given nodes.
  const LinearSpline({
    required List<InterpolationNode> nodes,
  }) : super(nodes: nodes);

  @override
  double interpolate(double x) {
    // Linear spline creation
    final nodesM = List<double>.generate(nodes.length - 1, (_) => 0);

    for (var i = 0; i < nodes.length - 1; ++i) {
      nodesM[i] = (nodes[i + 1].y - nodes[i].y) / (nodes[i + 1].x - nodes[i].x);
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

    return nodes[i].y + nodesM[i] * (x - nodes[i].x);
  }
}
