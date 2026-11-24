import 'dart:math';

import 'package:equations/equations.dart';

/// This mixin gathers reusable mathematical utilities that cannot be found in
/// the core `dart:math` package.
mixin MathUtils {
  /// Computes sqrt(x^2 + y^2) without under/overflow.
  ///
  /// The larger of the two absolute values is factored out, so that squaring
  /// the ratio between the two never overflows.
  double hypot(double x, double y) {
    final absX = x.abs();
    final absY = y.abs();
    final first = max(absX, absY);
    final second = min(absX, absY);

    if (first == 0.0) {
      return 0;
    }

    final t = second / first;

    return first * sqrt(1 + t * t);
  }

  /// Computes sqrt(x^2 + y^2), where the squares and the square root are
  /// **complex** operations.
  ///
  /// This is **not** the norm of the vector `(x, y)`: for example, it returns
  /// zero when `x = 1` and `y = i`. To compute the norm, use [hypot] with the
  /// magnitudes of [x] and [y] instead.
  Complex complexHypot(Complex x, Complex y) {
    var first = x;
    var second = y;

    if (y > x) {
      first = y;
      second = x;
    }

    if (first == const Complex.zero()) {
      return second;
    }

    final t = second / first;

    return first * (const Complex.fromReal(1) + (t * t)).sqrt();
  }
}
