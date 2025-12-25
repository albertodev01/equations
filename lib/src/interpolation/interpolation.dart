import 'package:equations/equations.dart';

/// {@template interpolation}
/// An abstract class that represents an interpolation strategy, used to find
/// new data points based on a given discrete set of data points (called nodes).
/// The available interpolation algorithms are:
///
///  - [LinearInterpolation];
///  - [PolynomialInterpolation];
///  - [NewtonInterpolation];
///  - [SplineInterpolation].
/// {@endtemplate}
abstract base class Interpolation {
  /// The interpolation nodes.
  final List<InterpolationNode> nodes;

  /// {@macro interpolation}
  const Interpolation({
    required this.nodes,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Interpolation) {
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

  /// Returns the `y` value of the `y = f(x)` equation.
  ///
  /// The function `f` is built by interpolating the given [nodes] nodes. The
  /// [x] value is the point at which the function has to be evaluated.
  double compute(double x);
}
