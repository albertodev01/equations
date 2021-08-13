import 'dart:math';

import 'package:equations/equations.dart';

/// This mixin gathers reusable mathematical utilities that cannot be found in
/// the core `dart:math` package.
mixin MathUtils {
  /// Computes sqrt(x^2 + y^2) without under/overflow.
  double hypot(double x, double y) {
    var first = x.abs();
    var second = y.abs();

    if (y > x) {
      first = y.abs();
      second = x.abs();
    }

    if (first == 0.0) {
      return second;
    }

    final t = second / first;
    return first * sqrt(1 + t * t);
  }

  /// Computes sqrt(x^2 + y^2) without under/overflow.
  ///
  /// Uses the magnitude (modulo) of [x] and [y].
  Complex complexHypot(Complex x, Complex y) {
    var first = x.abs();
    var second = y.abs();

    if (y > x) {
      first = y.abs();
      second = x.abs();
    }

    if (first == 0.0) {
      return Complex.fromReal(second);
    }

    final t = second / first;
    return Complex.fromReal(first * sqrt(1 + t * t));
  }
}
