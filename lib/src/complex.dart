import 'dart:math' as math;

import 'package:fraction/fraction.dart';

import 'common/exceptions.dart';

/// A Dart representation of a complex number in the classic form _a + bi_.
class Complex implements Comparable<Complex> {
  /// The real part of the complex number
  final double real;

  /// The imaginary part of the complex number
  final double imaginary;

  /// Creates a complex number with the given real and imaginary parts
  const Complex(double real, double imaginary) :
    real = real,
    imaginary = imaginary;

  /// Creates a complex number having only the real part, meaning that the
  /// complex part is set to 0.
  const Complex.fromReal(double real) :
    real = real,
    imaginary = 0;

  /// Creates a complex number having only the imaginary part, meaning that the
  /// real part is set to 0.
  const Complex.fromImaginary(double imaginary) :
    real = 0,
    imaginary = imaginary;

  /// Creates a complex number by using a [Fraction] as parameter for the real
  /// and complex part.
  Complex.fromFraction(Fraction real, Fraction imaginary) :
    real = real.toDouble(),
    imaginary = imaginary.toDouble();

  /// Creates a complex number having only the real part, which is expressed as
  /// a [Fraction]. The imaginary part is set to 0.
  Complex.fromRealFraction(Fraction real) :
        real = real.toDouble(),
        imaginary = 0;

  /// Creates a complex number having only the imaginary part, which is expressed
  /// as a [Fraction]. The real part is set to 0.
  Complex.fromImaginaryFraction(Fraction imaginary) :
        real = 0,
        imaginary = imaginary.toDouble();

  /// Creates a complex number from the given polar coordinates where [r] is the
  /// radius and [theta] is the angle.
  ///
  /// By default the angle theta must be expressed in *radians* but setting
  /// `angleInRadians = false` allows the value to be in degrees.
  Complex.fromPolar(double r, double theta, {bool angleInRadians = true}) :
    real = r * math.cos(angleInRadians ? theta : degToRad(theta)),
    imaginary = r * math.sin(angleInRadians ? theta : degToRad(theta));

  /// Creates a complex number by using a [Fraction] as parameter for the real
  /// and complex part.
  const Complex.zero() : real = 0, imaginary = 0;

  /// Creates the imaginary unit _i_ which is simply _0 + 1i_
  const Complex.i() : real = 0, imaginary = 1;

  @override
  bool operator==(Object other) {
    return identical(this, other) ||
      other is Complex &&
      runtimeType == other.runtimeType &&
      real == other.real &&
      imaginary == other.imaginary;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + real.hashCode;
    result = 37 * result + imaginary.hashCode;
    return result;
  }

  @override
  String toString() => _convertToString();

  /// Prints the number representing the real and the imaginary parts as fractions
  /// with the best possible approximation
  String toStringAsFraction() => _convertToString(asFraction: true);

  /// Prints the complex number with opening and closing parenthesis in case the
  /// complex number has both real and imaginary part.
  String toStringWithParenthesis() {
    if (real == 0)
      return "${_fixZero(imaginary)}i";

    if (imaginary == 0)
      return _fixZero(real);

    return "(${toString()})";
  }

  /// Returns an instance of [PolarComplex] which contains the radius _r_ and the
  /// angle _phi_ of the complex number.
  PolarComplex toPolarCoordinates() => PolarComplex._(
    r: abs,
    phiRadians: phase,
    phiDegrees: radToDeg(phase),
  );

  /// Converts the complex number into a string. If [asFraction] is `true` then
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

    if (real == 0)
      return imaginaryPart;

    if (imaginary == 0)
      return realPart;

    if (imaginary < 0)
      return "$realPart - $imaginaryPartAbs";

    return "$realPart + $imaginaryPart";
  }

  /// When a value is a whole number (like 2.0) it's printed without the fractional
  /// part.
  ///
  /// For example, `_fixZero(5.0)` returns `"5"`.
  String _fixZero(double value) {
    if (value % 1 == 0)
      return "${value.truncate()}";

    return "$value";
  }

  /// Converts an angle from radians to degrees
  static double radToDeg(num value) => value * 180 / math.pi;

  /// Converts an angle from degrees to radians
  static double degToRad(num value) => value * math.pi / 180;

  @override
  int compareTo(Complex other) => 0;

  /// Calculates the sum between two complex numbers.
  Complex operator+(Complex other) =>
      Complex(real + other.real, imaginary + other.imaginary);

  /// Calculates the difference between two complex numbers.
  Complex operator-(Complex other) =>
      Complex(real - other.real, imaginary - other.imaginary);

  /// Calculates the product of two complex numbers.
  Complex operator*(Complex other) {
    var r = real * other.real - imaginary * other.imaginary;
    var i = real * other.imaginary + imaginary * other.real;

    return Complex(r, i);
  }

  /// Calculates the division of two complex numbers.
  Complex operator/(Complex other) => this * other.reciprocal;

  /// Puts the opposite sign to the imaginary part of the complex number.
  Complex get conjugate => Complex(real, -imaginary);

  /// Finds the multiplicative inverse (reciprocal) of a complex number.
  ///
  /// If you let Z be a complex in the standard form of _Z = a + bi_ then the
  /// reciprocal is 1/Z, which can also be written as:
  ///
  ///  - 1 / (a + bi)
  ///  - (x - yi) / (x<sup>2</sup> + y<sup>2</sup>)
  ///  - conj(a + bi) / modulo(a + bi)<sup>2</sup>
  Complex get reciprocal {
    if (isZero)
      throw ComplexException("The reciprocal of zero is undefined.");

    var scale = real * real + imaginary * imaginary;
    return Complex(real / scale, -imaginary / scale);
  }

  /// Computes the square root of _(a<sup>2</sup> + b<sup>2</sup>)_ where _a_
  /// is the real part and _b_ is the imaginary part.
  ///
  /// It is the modulus/magnitude/absolute value of the complex number.
  double get abs {
    if ((real != 0) || (imaginary != 0))
      return math.sqrt(real*real + imaginary*imaginary);

    return 0;
  }

  /// Converts rectangular coordinates to polar coordinates by computing an arc
  /// tangent of y/x in the range from -pi to pi.
  double get phase => math.atan2(imaginary, real);

  /// Calculates the _base-e_ exponential of a complex number z where _e_ is the
  /// famous Euler constant
  Complex get exp => Complex(math.exp(real) * math.cos(imaginary), math.exp(real) * math.sin(imaginary));

  /// Computes the sine of the complex number
  Complex get sin => Complex(math.sin(real) * _cosh(imaginary), math.cos(real) * _sinh(imaginary));

  /// Computes the cosine of the complex number
  Complex get cos => Complex(math.cos(real) * _cosh(imaginary), -math.sin(real) * _sinh(imaginary));

  /// Computes the tangent of the complex number
  Complex get tan => sin / cos;

  /// Computes the square root of a complex number
  Complex get sqrt {
    var r = math.sqrt(abs);
    var theta = phase / 2;

    return Complex(r * math.cos(theta), r * math.sin(theta));
  }

  /// Computes the power which has a complex number as base and a real value as
  /// exponent. The expression is in the form _(a + bi)<sup>x</sup>_
  Complex pow(num x) {
    final logRe = x * math.log(abs);
    final logIm = x * phase;

    var modAns = math.exp(logRe);
    return Complex(modAns * math.cos(logIm), modAns * math.sin(logIm));
  }

  /// Changes the sign to the imaginary part of the complex number
  Complex get negate => Complex(-real, -imaginary);

  /// Checks whether the complex number is zero
  bool get isZero => real == 0 && imaginary == 0;

  /// Computes the complex n-th root of the complex number.
  ///
  /// The returned root is the one with the smallest positive argument.
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
        var length = abs;
        var angle = phase;

        if (angle < 0)
          angle += math.pi * 2;

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

  /// The hyperbolic cosine (cosh(x))
  double _cosh(num x) => (math.exp(x) + math.exp(-x)) / 2;

  /// The hyperbolic sine (sinh(x))
  double _sinh(num x) => (math.exp(x) - math.exp(-x)) / 2;
  
}

/// Object returned by a [Complex] which represents the number in polar coordinates
class PolarComplex {

  /// The absolute value/modulus of the complex number
  final double r;

  /// The angle phi expressed in radians
  final double phiRadians;

  /// The angle phi expressed in degrees
  final double phiDegrees;

  /// Takes the radius [r] and the angle phi, expressed in both radians
  /// ([phiRadians]) and degrees ([phiDegrees]), of a complex number
  const PolarComplex._({
    this.r,
    this.phiRadians,
    this.phiDegrees
  });

}