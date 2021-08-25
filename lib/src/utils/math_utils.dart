import 'dart:math';

import 'package:equations/equations.dart';

/// This mixin gathers reusable mathematical utilities that cannot be found in
/// the core `dart:math` package.
mixin MathUtils {
  /// Computes the base-2 logarithm of a real number.
  double log2(num value) => log(value) / log(2);

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
    //return (x.pow(2) + y.pow(2)).sqrt();
  }
}
