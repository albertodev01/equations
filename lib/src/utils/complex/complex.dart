import 'dart:math' as math;

import 'package:equations/equations.dart';

/// {@template complex}
/// A Dart representation of a complex number in the form `a + bi` where `a` is
/// the real part and `bi` is the imaginary (or complex) part.
///
/// A [Complex] object is **immutable**.
/// {@endtemplate}
final class Complex implements Comparable<Complex> {
  /// The real part of the complex number.
  final double real;

  /// The imaginary part of the complex number.
  final double imaginary;

  /// Creates a complex number with the given real and imaginary parts.
  const Complex(this.real, this.imaginary);

  /// Creates a complex with only the real part.
  ///
  /// The imaginary part is set to 0i.
  const Complex.fromReal(this.real) : imaginary = 0;

  /// Creates a complex with only the imaginary part.
  ///
  /// The real part is set to 0.
  const Complex.fromImaginary(this.imaginary) : real = 0;

  /// This is the same as calling `Complex(0, 0)`.
  const Complex.zero() : this(0, 0);

  /// This is the same as calling `Complex(0, 1)`.
  const Complex.i() : this(0, 1);

  /// Creates a complex number from [Fraction] objects.
  factory Complex.fromFraction(Fraction real, Fraction imaginary) =>
      Complex(real.toDouble(), imaginary.toDouble());

  /// Creates a complex number from [MixedFraction] objects.
  factory Complex.fromMixedFraction(MixedFraction real, MixedFraction imag) =>
      Complex(real.toDouble(), imag.toDouble());

  /// Creates a complex number having only the real part expressed as a
  /// [Fraction] object.
  ///
  /// The imaginary part is set to 0i.
  factory Complex.fromRealFraction(Fraction real) =>
      Complex(real.toDouble(), 0);

  /// Creates a complex number having only the imaginary part expressed as a
  /// [Fraction] object.
  ///
  /// The real part is set to 0.
  factory Complex.fromImaginaryFraction(Fraction imaginary) =>
      Complex(0, imaginary.toDouble());

  /// Creates a complex number having only the real part expressed as a
  /// [MixedFraction] object.
  ///
  /// The imaginary part is set to 0i.
  factory Complex.fromRealMixedFraction(MixedFraction real) =>
      Complex(real.toDouble(), 0);

  /// Creates a complex number having only the imaginary part expressed as a
  /// [MixedFraction] object.
  ///
  /// The real part is set to 0.
  factory Complex.fromImaginaryMixedFraction(MixedFraction imaginary) =>
      Complex(0, imaginary.toDouble());

  /// Creates a complex number from the given polar coordinates where [r] is the
  /// radius and [theta] is the angle.
  ///
  /// By default, the angle [theta] must be expressed in *radians* but setting
  /// `angleInRadians = false` allows the value to be in degrees.
  factory Complex.fromPolar({
    required double r,
    required double theta,
    bool angleInRadians = true,
  }) {
    final real = r * math.cos(angleInRadians ? theta : _degToRad(theta));
    final imaginary = r * math.sin(angleInRadians ? theta : _degToRad(theta));

    return Complex(real, imaginary);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Complex) {
      return runtimeType == other.runtimeType &&
          real == other.real &&
          imaginary == other.imaginary;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(real, imaginary);

  @override
  int compareTo(Complex other) {
    // Performing == on floating point values is not numerically stable.
    //
    // Instead, '>' and '<' are more reliable in terms of machine precision so
    // 0 is just a fallback.
    final thisAbs = abs();
    final otherAbs = other.abs();

    if (thisAbs > otherAbs) {
      return 1;
    }

    if (thisAbs < otherAbs) {
      return -1;
    }

    return 0;
  }

  /// {@macro algebraic_deep_copy}
  Complex copyWith({
    double? real,
    double? imaginary,
  }) => Complex(
    real ?? this.real,
    imaginary ?? this.imaginary,
  );

  @override
  String toString() => _convertToString();

  /// Prints the real and the imaginary parts of this [Complex] object with
  /// [fractionDigits] decimal digits. The output produced by this method is the
  /// same that would result in calling `toStringAsFixed` on a [double]:
  ///
  /// ```dart
  /// final example = Complex(5.123, 8.123);
  ///
  /// // Calling 'toStringAsFixed' on the `Complex` instance
  /// print(example.toStringAsFixed(1)); // 5.1 + 8.1i
  ///
  /// // The same result but with 'toStringAsFixed' calls on the single [double]
  /// // values of the complex value
  /// final real = example.real.toStringAsFixed(1);
  /// final imag = example.imaginary.toStringAsFixed(1);
  ///
  /// print("$real + $imag"); // 5.1 + 8.1i
  /// ```
  String toStringAsFixed(int fractionDigits) =>
      _convertToString(fractionDigits: fractionDigits);

  /// Prints the real and the imaginary parts of the complex number as fractions
  /// with the best possible approximation.
  String toStringAsFraction() => _convertToString(asFraction: true);

  /// Prints the complex number with opening and closing parenthesis in case the
  /// complex number had both real and imaginary part.
  String toStringWithParenthesis() {
    if (real == 0) {
      return '${_fixZero(imaginary)}i';
    }

    if (imaginary == 0) {
      return _fixZero(real);
    }

    return '($this)';
  }

  /// Converts this object into polar coordinates and wraps them in a new
  /// [PolarComplex] object.
  PolarComplex toPolarCoordinates() {
    final phi = phase();
    return PolarComplex(
      r: abs(),
      phiRadians: phi,
      phiDegrees: _radToDeg(phi),
    );
  }

  /// Converts this complex number into a string. If [asFraction] is `true` then
  /// the real and the imaginary part are converted into fractions.
  ///
  /// If you define `asFraction = true` and assign `fractionDigits` together,
  /// then `fractionDigit` takes precedence and ignores the `asFraction` value.
  String _convertToString({
    bool asFraction = false,
    int? fractionDigits,
  }) {
    var realPart = _fixZero(real);
    var imaginaryPart = '${_fixZero(imaginary)}i';
    var imaginaryPartAbs = '${_fixZero(imaginary.abs())}i';

    if (asFraction) {
      realPart = '${real.toFraction()}';
      imaginaryPart = '${imaginary.toFraction()}i';
      imaginaryPartAbs = '${imaginary.abs().toFraction()}i';
    }

    if (fractionDigits != null) {
      realPart = real.toStringAsFixed(fractionDigits);
      imaginaryPart = '${imaginary.toStringAsFixed(fractionDigits)}i';
      imaginaryPartAbs = '${imaginary.abs().toStringAsFixed(fractionDigits)}i';
    }

    if (real == 0) {
      return imaginaryPart;
    }

    if (imaginary == 0) {
      return realPart;
    }

    if (imaginary < 0) {
      return '$realPart - $imaginaryPartAbs';
    }

    return '$realPart + $imaginaryPart';
  }

  /// When a value is a whole number, it's printed without the fractional part.
  /// For example, `_fixZero(5.0)` returns `"5"`.
  String _fixZero(double value) {
    if (value % 1 == 0) {
      return '${value.truncate()}';
    }

    return '$value';
  }

  /// Converts an angle from radians to degrees.
  static double _radToDeg(num value) => value * 180 / math.pi;

  /// Converts an angle from degrees to radians.
  static double _degToRad(num value) => value * math.pi / 180;

  /// Sums two complex numbers.
  Complex operator +(Complex other) => Complex(
    real + other.real,
    imaginary + other.imaginary,
  );

  /// Subtracts two complex numbers.
  Complex operator -(Complex other) => Complex(
    real - other.real,
    imaginary - other.imaginary,
  );

  /// The products of two complex numbers.
  Complex operator *(Complex other) {
    final realPart = real * other.real - imaginary * other.imaginary;
    final imaginaryPart = real * other.imaginary + imaginary * other.real;

    return Complex(realPart, imaginaryPart);
  }

  /// Divides two complex numbers.
  Complex operator /(Complex other) {
    final realNum = (real * other.real) + (imaginary * other.imaginary);
    final imagNum = (imaginary * other.real) - (real * other.imaginary);
    final den = other.real * other.real + other.imaginary * other.imaginary;

    return Complex(realNum / den, imagNum / den);
  }

  /// Returns the negation of this complex number.
  Complex operator -() => negate;

  /// {@template natural_ordering_complex_numbers}
  /// There is no natural linear ordering for complex numbers. In fact, any
  /// square in an ordered field is >= 0 but in the complex field we have that
  /// _i<sup>2</sup> = -1_.
  ///
  /// A possible comparison strategy involves comparing the modulus/magnitude
  /// [abs] of the two complex number.
  ///
  /// In this implementation, we compare two [Complex] instances by looking at
  /// their modulus/magnitude.
  /// {@endtemplate}
  bool operator >(Complex other) => abs() > other.abs();

  /// {@macro natural_ordering_complex_numbers}
  bool operator >=(Complex other) => abs() >= other.abs();

  /// {@macro natural_ordering_complex_numbers}
  bool operator <(Complex other) => abs() < other.abs();

  /// {@macro natural_ordering_complex_numbers}
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
      throw const ComplexException('The reciprocal of zero is undefined.');
    }

    final scale = real * real + imaginary * imaginary;

    return Complex(real / scale, -imaginary / scale);
  }

  /// Computes the square root of _(a<sup>2</sup> + b<sup>2</sup>)_ where `a`
  /// is the real part and `b` is the imaginary part.
  ///
  /// This is is the modulus/magnitude/absolute value of the complex number.
  double abs() => math.sqrt(real * real + imaginary * imaginary);

  /// Converts rectangular coordinates to polar coordinates by computing an arc
  /// tangent of y/x in the range from -pi to pi.
  double phase() => math.atan2(imaginary, real);

  /// Calculates the _base-e_ exponential of a complex number z where _e_ is the
  /// Euler constant.
  Complex exp() {
    final expReal = math.exp(real);
    return Complex(
      expReal * math.cos(imaginary),
      expReal * math.sin(imaginary),
    );
  }

  /// Calculates the sine of this complex number.
  Complex sin() => Complex(
    math.sin(real) * _cosh(imaginary),
    math.cos(real) * _sinh(imaginary),
  );

  /// Calculates the cosine of this complex number.
  Complex cos() => Complex(
    math.cos(real) * _cosh(imaginary),
    -math.sin(real) * _sinh(imaginary),
  );

  /// Calculates the tangent of this complex number.
  Complex tan() => sin() / cos();

  /// Calculates the cotangent of this complex number.
  Complex cot() => cos() / sin();

  /// Calculates the hyperbolic cosine.
  ///
  /// Uses a more numerically stable computation for large values.
  double _cosh(num x) {
    if (x.abs() > 20) {
      // For large values, exp(-x) becomes negligible, so we can simplify
      return math.exp(x.abs()) / 2;
    }
    return (math.exp(x) + math.exp(-x)) / 2;
  }

  /// Calculates the hyperbolic sine.
  ///
  /// Uses a more numerically stable computation for large values.
  double _sinh(num x) {
    if (x.abs() > 20) {
      // For large positive values, exp(-x) becomes negligible
      // For large negative values, exp(x) becomes negligible
      final sign = x >= 0 ? 1 : -1;
      return sign * math.exp(x.abs()) / 2;
    }
    return (math.exp(x) - math.exp(-x)) / 2;
  }

  /// Calculates the square root of this complex number.
  Complex sqrt() {
    // In case this instance were a real, positive number, then we can simplify
    // the calculation.
    if ((imaginary == 0) && (real > 0)) {
      return Complex.fromReal(math.sqrt(real));
    }

    final r = math.sqrt(abs());
    final theta = phase() / 2;

    return Complex(r * math.cos(theta), r * math.sin(theta));
  }

  /// Calculates the power having a complex number as base and a real value as
  /// exponent. The expression is in the form _(a + bi)<sup>x</sup>_.
  Complex pow(num x) {
    final logRe = x * math.log(abs());
    final logIm = x * phase();

    final modAns = math.exp(logRe);

    return Complex(modAns * math.cos(logIm), modAns * math.sin(logIm));
  }

  /// The sign of the current object is changed and the result is returned in a
  /// new [Complex] instance.
  Complex get negate => Complex(-real, -imaginary);

  /// Checks whether the complex number is zero.
  bool get isZero => real == 0 && imaginary == 0;

  /// Computes the complex n-th root of this object. The returned root is the
  /// one with the smallest positive argument.
  Complex nthRoot(int nth) {
    var a = 0.0;
    var b = 0.0;
    var neg = false;
    var n = nth;

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

        if (angle < 0) {
          angle += math.pi * 2;
        }

        length = math.pow(length, 1.0 / n) as double;
        angle = angle / n;

        a = length * math.cos(angle);
        b = length * math.sin(angle);
      }
    }

    if (neg) {
      final den = a * a + b * b;
      a = a / den;
      b = -b / den;
    }

    return Complex(a, b);
  }
}
