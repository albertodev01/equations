import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';

/// Performs spline interpolation given a set of control points. The algorithm
/// can compute a "monotone cubic spline" or a "linear spline" based on the
/// properties of the control points.
class SplineInterpolation extends Interpolation {
  /// Creates a [SplineInterpolation] instance from the given interpolation
  /// nodes.
  const SplineInterpolation({
    required super.nodes,
  });

  @override
  double compute(double x) {
    final spline = SplineFunction.generate(
      nodes: nodes,
    );

    return spline.interpolate(x);
  }
}
