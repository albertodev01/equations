import 'package:equations/equations.dart';
import 'package:equations/src/interpolation/utils/spline_function.dart';

/// {@template spline_interpolation}
/// Performs spline interpolation given a set of control points. The algorithm
/// can compute a "monotone cubic spline" or a "linear spline" based on the
/// properties of the control points.
///
/// See [SplineFunction] for more information.
/// {@endtemplate}
base class SplineInterpolation extends Interpolation {
  /// {@macro spline_interpolation}
  const SplineInterpolation({
    required super.nodes,
  });

  @override
  double compute(double x) =>
      SplineFunction.generate(nodes: nodes).interpolate(x);
}
