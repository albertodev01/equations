import 'package:equations/equations.dart';

/// {@template linear_interpolation}
/// Linear interpolation is a curve fitting method that uses linear polynomials
/// to construct new data points within the range of a discrete set of known
/// data points.
///
/// This can also be seen as a special case of polynomial interpolation where
/// the degree is set to 1. Values of `x` outside of the nodes' range are
/// extrapolated along the same line.
///
/// Exactly 2 nodes with distinct x values are required.
/// {@endtemplate}
base class LinearInterpolation extends Interpolation {
  /// {@macro linear_interpolation}
  ///
  /// In debug mode, an [AssertionError] is thrown if [nodes] does not contain
  /// exactly 2 nodes. In any mode, [compute] throws an [InterpolationException]
  /// if the nodes are invalid.
  const new({
    required super.nodes,
  }) : assert(nodes.length == 2, 'There must be exactly 2 nodes.');

  @override
  double compute(double x) {
    if (nodes.length != 2) {
      throw const InterpolationException('There must be exactly 2 nodes.');
    }

    final node1 = nodes.first;
    final node2 = nodes[1];

    if (node1.x == node2.x) {
      throw const InterpolationException(
        'The x values of the 2 nodes must be distinct.',
      );
    }

    return node1.y +
        (node2.y - node1.y) * ((x - node1.x) / (node2.x - node1.x));
  }
}
