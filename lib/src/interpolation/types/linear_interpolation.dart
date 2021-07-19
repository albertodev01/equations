import 'package:equations/equations.dart';

/// Linear interpolation is a method of curve fitting using linear polynomials
/// to construct new data points within the range of a discrete set of known
/// data points.
///
/// This can also be seen as a special case of polynomial interpolation where
/// the degree is set to 1.
class LinearInterpolation extends Interpolation {
  /// Creates a [LinearInterpolation] instance from the given interpolation
  /// nodes.
  ///
  /// There **must** only be 2 nodes.
  LinearInterpolation({
    required List<InterpolationNode> nodes,
  })  : assert(nodes.length == 2, 'There must exactly be 2 nodes!'),
        super(nodes);

  @override
  double compute(double x) {
    final node1 = nodes[0];
    final node2 = nodes[1];

    return node1.y +
        (node2.y - node1.y) * ((x - node1.x) / (node2.x - node1.x));
  }
}
