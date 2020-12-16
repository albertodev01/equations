import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';

/// A Dart representation of a complex number in the form `a + bi` where `a` is
/// the real part and `bi` is the imaginary (or complex) part.
///
/// New instances of [Complex] can be created either by using the various
/// constructors or by using the extension method on [num].
class Complex implements Comparable<Complex> {
  /// The real part of the complex number.
  final double real;

  /// The imaginary part of the complex number.
  final double imaginary;

  /// Creates a complex number with the given real and imaginary parts.
  const Complex(double real, double imaginary)
      : real = real,
        imaginary = imaginary;

  /// Creates a complex number having only the real part, meaning that the
  /// imaginary part is set to 0.
  const Complex.fromReal(double real)
      : real = real,
        imaginary = 0;

  /// Creates a complex number having only the imaginary part, meaning that the
  /// real part is set to 0.
  const Complex.fromImaginary(double imaginary)
      : real = 0,
        imaginary = imaginary;

  /// Creates a complex number from [Fraction] objects as parameter for the real
  /// and imaginary part.
  Complex.fromFraction(Fraction real, Fraction imaginary)
      : real = real.toDouble(),
        imaginary = imaginary.toDouble();

  /// Creates a complex number from [MixedFraction] objects as parameter for the
  /// real and imaginary part.
  Complex.fromMixedFraction(MixedFraction real, MixedFraction imaginary)
      : real = real.toDouble(),
        imaginary = imaginary.toDouble();

  /// Creates a complex number having only the real part, which is expressed as
  /// a [Fraction]. The imaginary part is set to 0.
  Complex.fromRealFraction(Fraction real)
      : real = real.toDouble(),
        imaginary = 0;

  /// Creates a complex number having only the imaginary part, which is expressed
  /// as a [Fraction]. The real part is set to 0.
  Complex.fromImaginaryFraction(Fraction imaginary)
      : real = 0,
        imaginary = imaginary.toDouble();

  /// Creates a complex number having only the real part, which is expressed as
  /// a [MixedFraction]. The imaginary part is set to 0.
  Complex.fromRealMixedFraction(MixedFraction real)
      : real = real.toDouble(),
        imaginary = 0;

  /// Creates a complex number having only the imaginary part, which is expressed
  /// as a [MixedFraction]. The real part is set to 0.
  Complex.fromImaginaryMixedFraction(MixedFraction imaginary)
      : real = 0,
        imaginary = imaginary.toDouble();

  /// Creates a complex number from the given polar coordinates where [r] is the
  /// radius and [theta] is the angle.
  ///
  /// By default the angle theta must be expressed in *radians* but setting
  /// `angleInRadians = false` allows the value to be in degrees.
  Complex.fromPolar(double r, double theta, {bool angleInRadians = true})
      : real = r * math.cos(angleInRadians ? theta : degToRad(theta)),
        imaginary = r * math.sin(angleInRadians ? theta : degToRad(theta));

  /// This is the same as calling `Complex(0, 0)`.
  const Complex.zero() : this(0, 0);

  /// This is the same as calling `Complex(0, 1)`.
  const Complex.i() : this(0, 1);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is Complex) {
      return runtimeType == other.runtimeType &&
          real == other.real &&
          imaginary == other.imaginary;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;
    result = 37 * result + real.hashCode;
    result = 37 * result + imaginary.hashCode;
    return result;
  }

  @override
  int compareTo(Complex other) {
    // I don't perform == on floating point values because it's not reliable.
    // Instead, '>' and '<' are more reliable in terms of machine precision so
    // 0 is just a fallback.
    if (abs() > other.abs()) return 1;
    if (abs() < other.abs()) return -1;
    return 0;
  }

  /// Creates a **deep** copy of this object with the given fields replaced
  /// with the new values.
  Complex copyWith({
    double? real,
    double? imaginary,
  }) =>
      Complex(real ?? this.real, imaginary ?? this.imaginary);

  @override
  String toString() => _convertToString();

  /// Prints the number representing the real and the imaginary parts as fractions
  /// with the best possible approximation
  String toStringAsFraction() => _convertToString(asFraction: true);

  /// Prints the complex number with opening and closing parenthesis in case the
  /// complex number had both real and imaginary part.
  String toStringWithParenthesis() {
    if (real == 0) return "${_fixZero(imaginary)}i";

    if (imaginary == 0) return _fixZero(real);

    return "($this)";
  }

  /// Returns an instance of [PolarComplex] which contains the radius `r` and the
  /// angle `phi` of the complex number.
  PolarComplex toPolarCoordinates() => PolarComplex(
        r: abs(),
        phiRadians: phase(),
        phiDegrees: radToDeg(phase()),
      );

  /// Converts this complex number into a string. If [asFraction] is `true` then
  /// the real and the imaginary part are converted into fractions rather than
  /// being "normal" double values.
  String _convertToString({bool asFraction = false}) {
    var realPart = _fixZero(real);
    var imaginaryPart = "${_fixZero(imaginary)}i";
    var imaginaryPartAbs = "${_fixZero(imaginary.abs())}i";

    if (asFraction) {
      realPart = "${real.toFraction()}";
      imaginaryPart = "${imaginary.toFraction()}i";
      imaginaryPartAbs = "${imaginary.abs().toFraction()}i";
    }

    if (real == 0) {
      return imaginaryPart;
    }

    if (imaginary == 0) {
      return realPart;
    }

    if (imaginary < 0) {
      return "$realPart - $imaginaryPartAbs";
    }

    return "$realPart + $imaginaryPart";
  }

  /// When a value is a whole number, it's printed without the fractional part.
  /// For example, `_fixZero(5.0)` returns `"5"`.
  String _fixZero(double value) {
    if (value % 1 == 0) return "${value.truncate()}";

    return "$value";
  }

  /// Converts an angle from radians to degrees
  static double radToDeg(num value) => value * 180 / math.pi;

  /// Converts an angle from degrees to radians
  static double degToRad(num value) => value * math.pi / 180;

  /// Calculates the sum between two complex numbers.
  Complex operator +(Complex other) =>
      Complex(real + other.real, imaginary + other.imaginary);

  /// Calculates the difference between two complex numbers.
  Complex operator -(Complex other) =>
      Complex(real - other.real, imaginary - other.imaginary);

  /// Calculates the product of two complex numbers.
  Complex operator *(Complex other) {
    var realPart = real * other.real - imaginary * other.imaginary;
    var imaginaryPart = real * other.imaginary + imaginary * other.real;

    return Complex(realPart, imaginaryPart);
  }

  /// Calculates the division of two complex numbers.
  Complex operator /(Complex other) => this * other.reciprocal();

  /// There is no natural linear ordering for complex numbers. In fact, any
  /// square in an ordered field is >= 0 but in the complex field we have that
  /// _i<sup>2</sup> = -1_.
  ///
  /// A possible comparison strategy involves comparing the modulus/magnitude
  /// [abs] of the two complex number.
  ///
  /// In this implementation, we compare two [Complex] instances by looking at
  /// their modulus/magnitude.
  bool operator >(Complex other) => abs() > other.abs();

  /// There is no natural linear ordering for complex numbers. In fact, any
  /// square in an ordered field is >= 0 but in the complex field we have that
  /// _i<sup>2</sup> = -1_.
  ///
  /// A possible comparison strategy involves comparing the modulus/magnitude
  /// [abs] of the two complex number.
  ///
  /// In this implementation, we compare two [Complex] instances by looking at
  /// their modulus/magnitude.
  bool operator >=(Complex other) => abs() >= other.abs();

  /// There is no natural linear ordering for complex numbers. In fact, any
  /// square in an ordered field is >= 0 but in the complex field we have that
  /// _i<sup>2</sup> = -1_.
  ///
  /// A possible comparison strategy involves comparing the modulus/magnitude
  /// [abs] of the two complex number.
  ///
  /// In this implementation, we compare two [Complex] instances by looking at
  /// their modulus/magnitude.
  bool operator <(Complex other) => abs() < other.abs();

  /// There is no natural linear ordering for complex numbers. In fact, any
  /// square in an ordered field is >= 0 but in the complex field we have that
  /// _i<sup>2</sup> = -1_.
  ///
  /// A possible comparison strategy involves comparing the modulus/magnitude
  /// [abs] of the two complex number.
  ///
  /// In this implementation, we compare two [Complex] instances by looking at
  /// their modulus/magnitude.
  bool operator <=(Complex other) => abs() <= other.abs();

  /// The sign of the imaginary part of current object is changed and the result
  /// is returned in a new [Complex] instance.
  Complex conjugate() => Complex(real, -imaginary);

  /// Finds the multiplicative inverse (reciprocal) of the current instance and
  /// returns the result in a new [Complex] object.
  ///
  /// If you let `z` be a complex in the standard form of `z = a + bi` then the
  /// reciprocal is `1/z`, which can also be written as:
  ///
  ///  - 1 / (a + bi)
  ///  - (x - yi) / (x<sup>2</sup> + y<sup>2</sup>)
  ///  - conj(a + bi) / modulo(a + bi)<sup>2</sup>
  Complex reciprocal() {
    if (isZero) {
      throw ComplexException("The reciprocal of zero is undefined.");
    }

    var scale = real * real + imaginary * imaginary;
    return Complex(real / scale, -imaginary / scale);
  }

  /// Computes the square root of _(a<sup>2</sup> + b<sup>2</sup>)_ where `a`
  /// is the real part and `b` is the imaginary part.
  ///
  /// This is is the modulus/magnitude/absolute value of the complex number.
  double abs() {
    if ((real != 0) || (imaginary != 0)) {
      return math.sqrt(real * real + imaginary * imaginary);
    }

    return 0;
  }

  /// Converts rectangular coordinates to polar coordinates by computing an arc
  /// tangent of y/x in the range from -pi to pi.
  double phase() => math.atan2(imaginary, real);

  /// Calculates the _base-e_ exponential of a complex number z where _e_ is the
  /// famous Euler constant.
  Complex exp() => Complex(math.exp(real) * math.cos(imaginary),
      math.exp(real) * math.sin(imaginary));

  /// Calculates the sine of this complex number.
  Complex sin() => Complex(
      math.sin(real) * _cosh(imaginary), math.cos(real) * _sinh(imaginary));

  /// Calculates the cosine of this complex number.
  Complex cos() => Complex(
      math.cos(real) * _cosh(imaginary), -math.sin(real) * _sinh(imaginary));

  /// Calculates the tangent of this complex number.
  Complex tan() => sin() / cos();

  /// Calculates the cotangent of this complex number.
  Complex cot() => cos() / sin();

  /// Calculates the hyperbolic cosine.
  double _cosh(num x) => (math.exp(x) + math.exp(-x)) / 2;

  /// Calculates the hyperbolic sine.
  double _sinh(num x) => (math.exp(x) - math.exp(-x)) / 2;

  /// Calculates the square root of a complex number.
  Complex sqrt() {
    var r = math.sqrt(abs());
    var theta = phase() / 2;

    return Complex(r * math.cos(theta), r * math.sin(theta));
  }

  /// Calculates the power having a complex number as base and a real value as
  /// exponent. The expression is in the form _(a + bi)<sup>x</sup>_
  Complex pow(num x) {
    final logRe = x * math.log(abs());
    final logIm = x * phase();

    var modAns = math.exp(logRe);
    return Complex(modAns * math.cos(logIm), modAns * math.sin(logIm));
  }

  /// The sign of the current object is changed and the result is returned in a
  /// new [Complex] instance.
  Complex get negate => Complex(-real, -imaginary);

  /// Checks whether the complex number is zero
  bool get isZero => real == 0 && imaginary == 0;

  /// Computes the complex n-th root of the complex number. The returned root is
  /// the one with the smallest positive argument.
  Complex nthRoot(int n) {
    var a = 0.0, b = 0.0;
    var neg = false;

    if (n < 0) {
      n = -n;
      neg = true;
    }

    if (n == 0) {
      a = 1;
      b = 0;
    } else {
      if (n == 1) {
        a = real;
        b = imaginary;
      } else {
        var length = abs();
        var angle = phase();

        if (angle < 0) angle += math.pi * 2;

        length = math.pow(length, 1.0 / n) as double;
        angle = angle / n;

        a = length * math.cos(angle);
        b = length * math.sin(angle);
      }
    }

    if (neg) {
      var den = a * a + b * b;
      a = a / den;
      b = -b / den;
    }

    return Complex(a, b);
  }
}
