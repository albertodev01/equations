import 'package:equations/equations.dart';

/// Linear interpolation is a curve fitting method that uses linear polynomials
/// to construct new data points within the range of a discrete set of known
/// data points.
///
/// This can also be seen as a special case of polynomial interpolation where
/// the degree is set to 1.
base class LinearInterpolation extends Interpolation {
  /// Creates a [LinearInterpolation] object from the given interpolation
  /// nodes.
  ///
  /// There **must** only be 2 nodes.
  const LinearInterpolation({
    required super.nodes,
  }) : assert(nodes.length == 2, 'There must exactly be 2 nodes!');

  @override
  double compute(double x) {
    final node1 = nodes.first;
    final node2 = nodes[1];

    return node1.y +
        (node2.y - node1.y) * ((x - node1.x) / (node2.x - node1.x));
  }
}
