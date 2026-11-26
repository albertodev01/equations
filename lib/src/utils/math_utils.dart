import 'dart:math' as math;

/// Computes `sqrt(x^2 + y^2)` without intermediate overflow.
///
/// The larger of the two absolute values is factored out, so that the square
/// of the ratio between them never overflows. As in the IEEE 754 `hypot`
/// function, the result is infinite when either [x] or [y] is infinite, even
/// if the other one is `NaN`.
///
/// This is an internal helper and it's not exported by the package.
double hypot(double x, double y) {
  if (x.isInfinite || y.isInfinite) {
    return double.infinity;
  }

  final absX = x.abs();
  final absY = y.abs();
  final larger = math.max(absX, absY);
  final smaller = math.min(absX, absY);

  if (larger == 0) {
    return 0;
  }

  final ratio = smaller / larger;
  return larger * math.sqrt(1 + ratio * ratio);
}
