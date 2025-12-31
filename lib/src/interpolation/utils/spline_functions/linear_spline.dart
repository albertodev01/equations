import 'package:equations/src/interpolation/utils/spline_function.dart';

/// {@template linear_spline}
/// Represents a linear spline from a given set of control points. The
/// interpolated curve will be monotonic if the control points are monotonic.
/// {@endtemplate}
final class LinearSpline extends SplineFunction {
  /// Cached slopes (computed lazily on first use).
  List<double>? _nodesM;

  /// {@macro linear_spline}
  LinearSpline({
    required super.nodes,
  });

  /// Computes and caches the slopes for the spline.
  List<double> _computeSlopes() {
    if (_nodesM != null) {
      return _nodesM!;
    }

    final nodesM = List<double>.generate(
      nodes.length - 1,
      (i) => (nodes[i + 1].y - nodes[i].y) / (nodes[i + 1].x - nodes[i].x),
      growable: false,
    );

    _nodesM = nodesM;
    return nodesM;
  }

  /// Finds the segment index containing x using binary search.
  /// Returns the index i such that `nodes[i].x <= x < nodes[i+1].x`.
  int _findSegment(double x) {
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

  @override
  double interpolate(double x) {
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
    final i = _findSegment(x);

    if (x == nodes[i].x) {
      return nodes[i].y;
    }

    // Get cached slopes (computed on first use)
    final nodesM = _computeSlopes();

    return nodes[i].y + nodesM[i] * (x - nodes[i].x);
  }
}
