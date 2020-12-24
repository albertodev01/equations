import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/algebraic/utils/sylvester_matrix.dart';

/// Laguerre's method can be used to numerically solve polynomials in the form
/// `P(x) = 0` where `P(x)` is a given polynomial. This method requires an initial
/// guess x<sub>0</sub> to start finding the roots.
///
/// Empirical evidence has shown that convergence failure is extremely rare so
/// this is a good root finding algorithm for polynomials.
///
/// The biggest advantage of Laguerre's method is that it will converge
/// **regardless** the value of the initial guess. For this reason, the
/// [initialGuess] parameter of this class is optional (it's defaulted to zero).
class Laguerre extends Algebraic {
  /// The initial guess from which the algorithm has to start finding the roots.
  /// It's defaulted to [Complex.zero()] because the method will work regardless
  /// the value of the initial guess.
  final Complex initialGuess;

  /// The accuracy of the algorithm.
  final double precision;

  /// The maximum steps to be made by the algorithm.
  final int maxSteps;

  /// Instantiates a new object to find all the roots of a polynomial equation
  /// using Laguerre's method. The polynomial can have both complex ([Complex])
  /// and real ([double]) values.
  ///
  ///   - [coefficients]: the coefficients of the polynomial;
  ///   - [initialGuess]: the initial guess from which the algorithm has to start
  ///   finding the roots;
  ///   - [precision]: the accuracy of the algorithm;
  ///   - [maxSteps]: the maximum steps to be made by the algorithm.
  ///
  /// Note that the coefficient with the highest degree goes first. For example,
  /// the coefficients of the `-5x^2 + 3x + i = 0` has to be inserted in the
  /// following way:
  ///
  /// ```dart
  /// final laguerre = Laguerre(
  ///   coefficients [
  ///     Complex.fromReal(-5),
  ///     Complex.fromReal(3),
  ///     Complex.i(),
  ///   ],
  /// );
  /// ```
  ///
  /// Since `-5` is the coefficient with the highest degree (2), it goes first.
  /// If the coefficients of your polynomial are only real numbers, consider
  /// using the [Laguerre.realEquation()] constructor instead.
  Laguerre({
    required List<Complex> coefficients,
    this.initialGuess = const Complex.zero(),
    this.precision = 1.0e-10,
    this.maxSteps = 1000,
  }) : super(coefficients);

  /// Instantiates a new object to find all the roots of a polynomial equation
  /// using Laguerre's method. The polynomial can have both complex ([Complex])
  /// and real ([double]) values.
  ///
  ///   - [coefficients]: the coefficients of the polynomial;
  ///   - [initialGuess]: the initial guess from which the algorithm has to start
  ///   finding the roots;
  ///   - [precision]: the accuracy of the algorithm;
  ///   - [maxSteps]: the maximum steps to be made by the algorithm.
  ///
  /// Note that the coefficient with the highest degree goes first. For example,
  /// the coefficients of the `-5x^2 + 3x + 1 = 0` has to be inserted in the
  /// following way:
  ///
  /// ```dart
  /// final laguerre = Laguerre(
  ///   coefficients [-5, 3, 1],
  /// );
  /// ```
  ///
  /// Since `-5` is the coefficient with the highest degree (2), it goes first.
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Laguerre()] constructor instead.
  Laguerre.realEquation({
    required List<double> coefficients,
    this.initialGuess = const Complex.zero(),
    this.precision = 1.0e-10,
    this.maxSteps = 8000,
  }) : super.realEquation(coefficients);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is Laguerre) {
      // The lengths of the coefficients must match
      if (coefficients.length != other.coefficients.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements are
      // equal, then the counter will match the actual length of the coefficients
      // list.
      var equalsCount = 0;

      for (var i = 0; i < coefficients.length; ++i) {
        if (coefficients[i] == other.coefficients[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == coefficients.length &&
          initialGuess == other.initialGuess &&
          precision == other.precision &&
          maxSteps == other.maxSteps;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = super.hashCode;

    result = 37 * result + initialGuess.hashCode;
    result = 37 * result + precision.hashCode;
    result = 37 * result + maxSteps.hashCode;

    return result;
  }

  @override
  int get degree => coefficients.length - 1;

  @override
  Algebraic derivative() {
    // Rather than always returning 'Laguerre', if the degree is <= 4 there's
    // the possibility to return a more convenient object
    switch (coefficients.length) {
      case 1:
        return Constant(a: coefficients[0]).derivative();
      case 2:
        return Linear(a: coefficients[0], b: coefficients[1]).derivative();
      case 3:
        return Quadratic(
          a: coefficients[0],
          b: coefficients[1],
          c: coefficients[2],
        ).derivative();
      case 4:
        return Cubic(
          a: coefficients[0],
          b: coefficients[1],
          c: coefficients[2],
          d: coefficients[3],
        ).derivative();
      case 5:
        return Quartic(
          a: coefficients[0],
          b: coefficients[1],
          c: coefficients[2],
          d: coefficients[3],
          e: coefficients[4],
        ).derivative();
      case 6:
        final coeffs = _derivativeOf(coefficients);
        return Quartic(
          a: coeffs[0],
          b: coeffs[1],
          c: coeffs[2],
          d: coeffs[3],
          e: coeffs[4],
        );
      default:
        return Laguerre(
            coefficients: _derivativeOf(coefficients),
            precision: precision,
            maxSteps: maxSteps);
    }
  }

  @override
  Complex discriminant() {
    // Say that P(x) is the polynomial represented by this instance and
    // P'(x) is the derivative of P. In order to calculate the discriminant of
    // a polynomial, we need to first compute the resultant Res(A, A') which
    // is equivalent to the determinant of the Sylvester matrix.
    final sylvester = SylvesterMatrix(coefficients: coefficients);

    // Computes Res(A, A') and then determines the sign according with the
    // degree of the polynomial.
    return sylvester.polynomialDiscriminant();
  }

  @override
  List<Complex> solutions() {
    // List that will contain the solutions
    final roots = <Complex>[];

    // The algorithm requires the coefficients to start from the one with the
    // lowest degree.
    final polyP = coefficients.reversed.toList();
    var polyQ = polyP;

    // Finding all the roots of the polynomial
    while (polyQ.length > 2) {
      var z = initialGuess;

      // Laguerre's method
      z = _laguerre(polyQ, z);
      z = _laguerre(polyP, z);
      polyQ = _horner(polyQ, z).polynomial;

      // Adding the new root to the results list
      roots.add(z);
    }

    // Safety check to avoid 'RangeError'
    if (polyQ.length >= 2) {
      roots.add(polyQ[0].negate / polyQ[1]);
    }

    return roots;
  }

  /// Implementation of the Laguerre's method which requires the [poly] list of
  /// coefficients of the polynomial and an [initial] starting point.
  Complex _laguerre(List<Complex> poly, Complex initial) {
    final n = (poly.length - 1) * 1.0;
    var x = initial.copyWith();

    // Computing first and second derivatives for G and H coefficients
    final p1 = _derivativeOf(poly);
    final p2 = _derivativeOf(p1);

    // By default, 'maxSteps' is set to 1000 which is generally good enough
    for (var step = 0; step < maxSteps; step++) {
      final y0 = _horner(poly, x).value;

      // Avoiding division by zero errors. The _cmp function uses the given value
      // for 'precision' to understand which values should be considered zero.
      if (_compareTo(y0, Complex.zero()) == 0) {
        break;
      }

      final G = _horner(p1, x).value / y0;
      final H = G * G - _horner(p2, x).value - y0;
      final R =
          (Complex.fromReal(n - 1) * (H * Complex.fromReal(n) - G * G)).sqrt();
      final d1 = G + R;
      final d2 = G - R;
      final a = Complex.fromReal(n) / (_compareTo(d1, d2) > 0 ? d1 : d2);

      x -= a;

      // Avoiding division by zero errors. The _cmp function uses the given value
      // for 'precision' to understand which values should be considered zero.
      if (_compareTo(a, Complex.zero()) == 0) {
        break;
      }
    }

    return x;
  }

  /// Horner's method for polynomial evaluation.
  HornerResult _horner(List<Complex> a, Complex x0) {
    final n = a.length - 1;
    final b = List<Complex>.filled(max(1, n), Complex.zero());

    // Horner
    for (var i = n; i > 0; --i) {
      b[i - 1] = a[i] + (i < n ? b[i] * x0 : Complex.zero());
    }

    return HornerResult(b, a[0] + b[0] * x0);
  }

  /// Returns the coefficients of the derivative of a given polynomial.
  ///
  /// The [poly] parameter contains the coefficients of the polynomial whose
  /// derivative has to be computed.
  List<Complex> _derivativeOf(List<Complex> poly) {
    // The derivative
    final result = <Complex>[];

    // Evaluation of the derivative
    for (var i = 1; i < poly.length; ++i) {
      result.add(poly[i] * Complex.fromReal(i * 1.0));
    }

    return result;
  }

  /// Compares the modulus / absolute value / magnitude of two complex numbers
  /// according with the given precision.
  ///
  /// This method behaves like 'compareTo' from [Comparable]. It returns `-1`,
  /// `0` or `1` according with the natural ordering of the modulus of the complex
  /// numbers.
  int _compareTo(Complex x, Complex y) {
    final diff = x.abs() - y.abs();

    // -1 if x < y
    // +1 if x > y
    //  0 if x = y
    return diff < -precision ? -1 : (diff > precision ? 1 : 0);
  }

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  Laguerre copyWith({
    List<Complex>? coefficients,
    Complex? initialGuess,
    double? precision,
    int? maxSteps,
  }) =>
      Laguerre(
        coefficients: coefficients ?? this.coefficients.map((e) => e).toList(),
        initialGuess: initialGuess ?? this.initialGuess,
        precision: precision ?? this.precision,
        maxSteps: maxSteps ?? this.maxSteps,
      );
}
