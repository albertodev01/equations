import 'dart:math' as math;

import 'package:equations/equations.dart';

/// {@template complex}
/// A Dart representation of a complex number in the form `a + bi` where `a` is
/// the real part and `b` is the imaginary part.
///
/// A [Complex] object is **immutable**.
///
/// Multivalued functions ([sqrt], [nthRoot], [pow], [powComplex], [log] and
/// [phase]) return their principal value, which is based on an argument in the
/// range `(-pi, pi]`. The branch cut
/// is the negative real axis: a negative real number with a `-0.0` imaginary
/// part is treated as lying just below the axis, so its argument is `-pi`.
/// {@endtemplate}
final class Complex implements Comparable<Complex> {
  /// Creates a complex number with the given real and imaginary parts.
  const new(this.real, this.imaginary);

  /// Creates a complex with only the real part.
  ///
  /// The imaginary part is set to 0.
  const new fromReal(this.real) : imaginary = 0;

  /// Creates a complex with only the imaginary part.
  ///
  /// The real part is set to 0.
  const new fromImaginary(this.imaginary) : real = 0;

  /// This is the same as calling `Complex(0, 0)`.
  const new zero() : this(0, 0);

  /// This is the same as calling `Complex(0, 1)`.
  const new i() : this(0, 1);

  /// Creates a complex number from [Fraction] objects.
  factory fromFraction(Fraction real, Fraction imaginary) =>
      Complex(real.toDouble(), imaginary.toDouble());

  /// Creates a complex number from [MixedFraction] objects.
  factory fromMixedFraction(MixedFraction real, MixedFraction imag) =>
      Complex(real.toDouble(), imag.toDouble());

  /// Creates a complex number having only the real part expressed as a
  /// [Fraction] object.
  ///
  /// The imaginary part is set to 0.
  factory fromRealFraction(Fraction real) => Complex(real.toDouble(), 0);

  /// Creates a complex number having only the imaginary part expressed as a
  /// [Fraction] object.
  ///
  /// The real part is set to 0.
  factory fromImaginaryFraction(Fraction imaginary) =>
      Complex(0, imaginary.toDouble());

  /// Creates a complex number having only the real part expressed as a
  /// [MixedFraction] object.
  ///
  /// The imaginary part is set to 0.
  factory fromRealMixedFraction(MixedFraction real) =>
      Complex(real.toDouble(), 0);

  /// Creates a complex number having only the imaginary part expressed as a
  /// [MixedFraction] object.
  ///
  /// The real part is set to 0.
  factory fromImaginaryMixedFraction(MixedFraction imaginary) =>
      Complex(0, imaginary.toDouble());

  /// Creates a complex number from the given polar coordinates where [r] is the
  /// radius and [theta] is the angle.
  ///
  /// By default, the angle [theta] must be expressed in *radians* but setting
  /// `angleInRadians = false` allows the value to be in degrees.
  factory fromPolar({
    required double r,
    required double theta,
    bool angleInRadians = true,
  }) {
    final angle = angleInRadians ? theta : _degToRad(theta);

    return Complex(r * math.cos(angle), r * math.sin(angle));
  }

  /// The real part of the complex number.
  final double real;

  /// The imaginary part of the complex number.
  final double imaginary;

  /// Values whose magnitude is above this threshold (2^500) are scaled down
  /// before being squared, so that the square doesn't overflow.
  static final double _scaleUpperLimit = math.pow(2.0, 500).toDouble();

  /// Values whose magnitude is below this threshold (2^-500) are scaled up
  /// before being squared, so that the square doesn't underflow.
  static final double _scaleLowerLimit = math.pow(2.0, -500).toDouble();

  /// The scaling factor (2^600). Being a power of 2, scaling by it is exact.
  static final double _scaleFactor = math.pow(2.0, 600).toDouble();

  /// Above this threshold, `exp(-x)` is negligible compared to `exp(x)` in
  /// double precision (`exp(-40)` is about 4e-18).
  static const double _hyperbolicLargeThreshold = 20;

  /// Integer exponents up to this magnitude are computed by [pow] with
  /// repeated multiplications instead of logarithms.
  static const _maxIntegerPower = 1024;

  /// The products `(2k)(2k + 1)` used by the Taylor series of [_sinh], from the
  /// innermost (x^17 term) to the outermost (x^3 term). The first omitted term
  /// is below 1e-17 in relative terms when `|x| < 1`.
  static const _sinhTaylorDenominators = <int>[
    272,
    210,
    156,
    110,
    72,
    42,
    20,
    6,
  ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Complex &&
        real == other.real &&
        imaginary == other.imaginary;
  }

  @override
  int get hashCode => Object.hash(real, imaginary);

  /// {@macro natural_ordering_complex_numbers}
  ///
  /// This ordering is not consistent with `==`: two different numbers with the
  /// same modulus (such as `1` and `i`) compare as equal. A number with a `NaN`
  /// part is greater than any other number, as in [double.compareTo].
  @override
  int compareTo(Complex other) => abs().compareTo(other.abs());

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
  /// [fractionDigits] decimal digits. Each part is printed as it would be by
  /// calling `toStringAsFixed` on the [double] value:
  ///
  /// ```dart
  /// final example = Complex(5.123, 8.123);
  ///
  /// // Calling 'toStringAsFixed' on the `Complex` instance
  /// print(example.toStringAsFixed(1)); // 5.1 + 8.1i
  ///
  /// // The same result but with 'toStringAsFixed' calls on the single double
  /// // values of the complex value
  /// final real = example.real.toStringAsFixed(1);
  /// final imag = example.imaginary.toStringAsFixed(1);
  ///
  /// print('$real + ${imag}i'); // 5.1 + 8.1i
  /// ```
  ///
  /// A part that is zero after rounding is omitted, so
  /// `Complex(5, 0.04).toStringAsFixed(1)` returns `5.0`.
  String toStringAsFixed(int fractionDigits) =>
      _convertToString(fractionDigits: fractionDigits);

  /// Prints the real and the imaginary parts of the complex number as fractions
  /// with the best possible approximation.
  ///
  /// Throws a [FractionException] if a part is `NaN` or infinite.
  String toStringAsFraction() => _convertToString(asFraction: true);

  /// Prints the complex number wrapped in parentheses when both the real and
  /// the imaginary parts are non-zero. Otherwise, it's the same as [toString].
  String toStringWithParenthesis() {
    final value = toString();

    return real != 0 && imaginary != 0 ? '($value)' : value;
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

  /// Converts this complex number into a string.
  ///
  /// When [fractionDigits] is not `null`, both parts are rounded to that many
  /// decimal digits and [asFraction] is ignored. Otherwise, if [asFraction] is
  /// `true` the parts are converted into fractions.
  ///
  /// A part that is zero (after rounding) is omitted. When both parts are zero,
  /// only the real part is printed.
  String _convertToString({
    bool asFraction = false,
    int? fractionDigits,
  }) {
    var re = real;
    var im = imaginary;
    var format = _fixZero;

    if (fractionDigits != null) {
      re = double.parse(real.toStringAsFixed(fractionDigits));
      im = double.parse(imaginary.toStringAsFixed(fractionDigits));
      format = (value) => value.toStringAsFixed(fractionDigits);
    } else if (asFraction) {
      format = (value) => '${value.toFraction()}';
    }

    // Avoids printing '-0' or '-0.0'.
    if (re == 0) {
      re = 0;
    }

    if (im == 0) {
      return format(re);
    }

    if (re == 0) {
      return '${format(im)}i';
    }

    if (im < 0) {
      return '${format(re)} - ${format(-im)}i';
    }

    return '${format(re)} + ${format(im)}i';
  }

  /// When a value is a whole number, it's printed without the fractional part.
  /// For example, `_fixZero(5.0)` returns `"5"`.
  static String _fixZero(double value) {
    if (value == 0) {
      return '0';
    }

    // Whole numbers below 1e21 are printed by Dart with a trailing '.0', while
    // larger values use the exponential notation.
    final string = value.toString();

    return string.endsWith('.0')
        ? string.substring(0, string.length - 2)
        : string;
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

  /// Multiplies two complex numbers.
  Complex operator *(Complex other) {
    final realPart = real * other.real - imaginary * other.imaginary;
    final imaginaryPart = real * other.imaginary + imaginary * other.real;

    return Complex(realPart, imaginaryPart);
  }

  /// Divides two complex numbers.
  ///
  /// It uses Smith's algorithm, which avoids the overflow and the underflow of
  /// the textbook formula `(a + bi)(c - di) / (c^2 + d^2)` when the parts of
  /// [other] are very large or very small.
  ///
  /// Like the division of two [double] values, dividing by zero doesn't throw:
  /// the result has `NaN` parts. Use [reciprocal] to get an exception instead.
  Complex operator /(Complex other) {
    final c = other.real;
    final d = other.imaginary;

    if (c.abs() >= d.abs()) {
      final ratio = d / c;
      final den = c + d * ratio;

      return Complex(
        (real + imaginary * ratio) / den,
        (imaginary - real * ratio) / den,
      );
    }

    final ratio = c / d;
    final den = c * ratio + d;

    return Complex(
      (real * ratio + imaginary) / den,
      (imaginary * ratio - real) / den,
    );
  }

  /// Returns the negation of this complex number.
  Complex operator -() => negate;

  /// {@template natural_ordering_complex_numbers}
  /// There is no natural linear ordering for complex numbers. In fact, any
  /// square in an ordered field is >= 0 but in the complex field we have that
  /// _i^2 = -1_.
  ///
  /// A possible comparison strategy involves comparing the modulus/magnitude
  /// [abs] of the two complex numbers.
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
  ///  - (a - bi) / (a^2 + b^2)
  ///  - conj(z) / abs(z)^2
  ///
  /// Throws a [ComplexException] if this number is zero.
  Complex reciprocal() {
    if (isZero) {
      throw const ComplexException('The reciprocal of zero is undefined.');
    }

    return const Complex(1, 0) / this;
  }

  /// Computes the square root of _(a^2 + b^2)_ where `a` is the real part and
  /// `b` is the imaginary part.
  ///
  /// This is the modulus/magnitude/absolute value of the complex number. The
  /// parts are scaled when needed, so the result doesn't overflow or underflow
  /// unless the modulus itself is out of the [double] range.
  double abs() {
    final x = real.abs();
    final y = imaginary.abs();

    if (x.isInfinite || y.isInfinite) {
      return double.infinity;
    }

    final big = math.max(x, y);

    if (big > _scaleUpperLimit) {
      final xs = x / _scaleFactor;
      final ys = y / _scaleFactor;

      return math.sqrt(xs * xs + ys * ys) * _scaleFactor;
    }

    if (big < _scaleLowerLimit) {
      final xs = x * _scaleFactor;
      final ys = y * _scaleFactor;

      return math.sqrt(xs * xs + ys * ys) / _scaleFactor;
    }

    return math.sqrt(x * x + y * y);
  }

  /// Returns the argument (or phase) of this complex number, which is the angle
  /// between the positive real axis and the vector `(a, b)`.
  ///
  /// The result is in radians and is in the range `(-pi, pi]`, with the only
  /// exception of a negative real part and a `-0.0` imaginary part, which give
  /// `-pi`.
  double phase() => math.atan2(imaginary, real);

  /// Calculates the _base-e_ exponential of this complex number, where _e_ is
  /// the Euler constant.
  Complex exp() {
    final expReal = math.exp(real);

    // Avoids 'Infinity * 0 = NaN' in the imaginary part when the real part is
    // so large that 'exp(real)' overflows.
    if (imaginary == 0) {
      return Complex(expReal, imaginary);
    }

    return Complex(
      expReal * math.cos(imaginary),
      expReal * math.sin(imaginary),
    );
  }

  /// Calculates the principal natural logarithm of this complex number, which
  /// is `log(abs()) + i * phase()`. The imaginary part is in the range
  /// `(-pi, pi]` (see [phase]).
  ///
  /// The real part is accurate even when the modulus is close to 1 (for
  /// example, the real part of `log(1 + 1e-10i)` is `5e-21`) and doesn't
  /// overflow when the modulus is out of the [double] range.
  ///
  /// Throws a [ComplexException] if this number is zero.
  Complex log() {
    if (isZero) {
      throw const ComplexException('The logarithm of zero is undefined.');
    }

    final x = real.abs();
    final y = imaginary.abs();
    final big = math.max(x, y);
    final small = math.min(x, y);

    if (big.isInfinite) {
      return Complex(double.infinity, phase());
    }

    final double logModulus;

    if (big >= 0.5 && big <= 2) {
      // log|z| = log(|z|^2) / 2 = log1p(|z|^2 - 1) / 2. Here 'big - 1' is
      // exact, so |z|^2 - 1 = (big - 1)(big + 1) + small^2 has no
      // cancellation unless |z| is close to 1, where the result is tiny anyway.
      logModulus = _log1p((big - 1) * (big + 1) + small * small) / 2;
    } else {
      // log|z| = log(big) + log(1 + (small / big)^2) / 2, which can't
      // overflow. Here |log(big)| > log(2), which is more than twice the
      // second term, so there's no cancellation.
      final ratio = small / big;
      logModulus = math.log(big) + _log1p(ratio * ratio) / 2;
    }

    return Complex(logModulus, phase());
  }

  /// Calculates `log(1 + u)` accurately when `u` is small, which isn't the
  /// case of `math.log(1 + u)` because `1 + u` is rounded.
  ///
  /// The rounding error of `w = 1 + u` cancels out in `log(w) * u / (w - 1)`
  /// (see D. Goldberg, "What every computer scientist should know about
  /// floating-point arithmetic", Theorem 4).
  static double _log1p(double u) {
    final w = 1 + u;

    if (w == 1) {
      return u;
    }

    return math.log(w) * u / (w - 1);
  }

  /// Calculates the sine of this complex number.
  Complex sin() {
    // Avoids '0 * Infinity = NaN' in the real part when the imaginary part is
    // so large that 'cosh' overflows.
    if (real == 0) {
      return Complex(real, _sinh(imaginary));
    }

    return Complex(
      math.sin(real) * _cosh(imaginary),
      math.cos(real) * _sinh(imaginary),
    );
  }

  /// Calculates the cosine of this complex number.
  Complex cos() {
    // Avoids '0 * Infinity = NaN' in the imaginary part when the imaginary part
    // is so large that 'sinh' overflows. The zero keeps the sign it would have
    // with the general formula, '-sin(real) * sinh(imaginary)'.
    if (real == 0) {
      return Complex(_cosh(imaginary), -real * imaginary.sign);
    }

    return Complex(
      math.cos(real) * _cosh(imaginary),
      -math.sin(real) * _sinh(imaginary),
    );
  }

  /// Calculates the tangent of this complex number.
  ///
  /// It uses the identity
  ///
  /// ```text
  /// tan(a + bi) = (sin(a)cos(a) + i * sinh(b)cosh(b)) / (cos(a)^2 + sinh(b)^2)
  /// ```
  ///
  /// so that the result is accurate (and tends to `i` or `-i`) when the
  /// imaginary part is large.
  Complex tan() {
    final s = math.sin(real);
    final c = math.cos(real);

    if (imaginary.abs() > _hyperbolicLargeThreshold) {
      return Complex(
        4 * s * c * math.exp(-2 * imaginary.abs()),
        imaginary > 0 ? 1 : -1,
      );
    }

    final sh = _sinh(imaginary);
    final den = c * c + sh * sh;

    return Complex(s * c / den, sh * _cosh(imaginary) / den);
  }

  /// Calculates the cotangent of this complex number.
  ///
  /// It uses the identity
  ///
  /// ```text
  /// cot(a + bi) = (sin(a)cos(a) - i * sinh(b)cosh(b)) / (sin(a)^2 + sinh(b)^2)
  /// ```
  ///
  /// so that the result is accurate (and tends to `-i` or `i`) when the
  /// imaginary part is large. Since zero is a pole of the cotangent,
  /// `Complex.zero().cot()` has `NaN` parts.
  Complex cot() {
    final s = math.sin(real);
    final c = math.cos(real);

    if (imaginary.abs() > _hyperbolicLargeThreshold) {
      return Complex(
        4 * s * c * math.exp(-2 * imaginary.abs()),
        imaginary > 0 ? -1 : 1,
      );
    }

    final sh = _sinh(imaginary);
    final den = s * s + sh * sh;

    return Complex(s * c / den, -sh * _cosh(imaginary) / den);
  }

  /// Calculates the hyperbolic sine of this complex number, which is
  /// `sinh(a)cos(b) + i * cosh(a)sin(b)`.
  Complex sinh() {
    // Avoids 'Infinity * 0 = NaN' in the imaginary part when the real part is
    // so large that 'cosh' overflows.
    if (imaginary == 0) {
      return Complex(_sinh(real), imaginary);
    }

    return Complex(
      _sinh(real) * math.cos(imaginary),
      _cosh(real) * math.sin(imaginary),
    );
  }

  /// Calculates the hyperbolic cosine of this complex number, which is
  /// `cosh(a)cos(b) + i * sinh(a)sin(b)`.
  Complex cosh() {
    // Avoids 'Infinity * 0 = NaN' in the imaginary part when the real part is
    // so large that 'sinh' overflows. The zero keeps the sign it would have
    // with the general formula, 'sinh(real) * sin(imaginary)'.
    if (imaginary == 0) {
      return Complex(_cosh(real), imaginary * real.sign);
    }

    return Complex(
      _cosh(real) * math.cos(imaginary),
      _sinh(real) * math.sin(imaginary),
    );
  }

  /// Calculates the hyperbolic tangent of this complex number.
  ///
  /// It uses the identity `tanh(z) = -i * tan(iz)`, so it is accurate (and
  /// tends to `1` or `-1`) when the real part is large, like [tan].
  Complex tanh() {
    // iz = i(a + bi) = -b + ai, and -i(x + yi) = y - xi.
    final tan = Complex(-imaginary, real).tan();

    return Complex(tan.imaginary, -tan.real);
  }

  /// Calculates the hyperbolic cosine.
  ///
  /// For large values, it computes `exp(|x| / 2)^2 / 2` so that the result
  /// doesn't overflow before `cosh(x)` itself does.
  static double _cosh(double x) {
    final ax = x.abs();

    if (ax > _hyperbolicLargeThreshold) {
      final half = math.exp(ax / 2);
      return (half / 2) * half;
    }

    final e = math.exp(ax);
    return (e + 1 / e) / 2;
  }

  /// Calculates the hyperbolic sine.
  ///
  /// For `|x| < 1`, it uses the Taylor series (up to the x^17 term) because
  /// `(exp(x) - exp(-x)) / 2` suffers from cancellation when `x` is small. For
  /// large values, it computes `exp(|x| / 2)^2 / 2` so that the result doesn't
  /// overflow before `sinh(x)` itself does.
  static double _sinh(double x) {
    final ax = x.abs();

    if (ax < 1) {
      // Horner's scheme for x * (1 + x^2/(2*3) * (1 + x^2/(4*5) * (...))).
      final x2 = x * x;
      final series = _sinhTaylorDenominators.fold<double>(
        1,
        (sum, den) => 1 + x2 / den * sum,
      );

      return x * series;
    }

    final double result;

    if (ax > _hyperbolicLargeThreshold) {
      final half = math.exp(ax / 2);
      result = (half / 2) * half;
    } else {
      final e = math.exp(ax);
      result = (e - 1 / e) / 2;
    }

    return x < 0 ? -result : result;
  }

  /// Calculates the principal square root of this complex number, which is the
  /// root with a non-negative real part.
  ///
  /// The imaginary part of the result has the same sign as the imaginary part
  /// of this number (`-0.0` included), so `Complex(-4, 0).sqrt()` is `2i` while
  /// `Complex(-4, -0.0).sqrt()` is `-2i`.
  Complex sqrt() {
    final a = real;
    final b = imaginary;

    if (b.isInfinite) {
      return Complex(double.infinity, b);
    }

    // On the real axis the result is exact.
    if (b == 0) {
      if (a >= 0) {
        return Complex(math.sqrt(a), b);
      }

      final root = math.sqrt(-a);
      return Complex(0, b.isNegative ? -root : root);
    }

    // The formula t = sqrt((|z| + |a|) / 2) never subtracts two numbers with
    // the same sign, so there is no cancellation. Halving each term before the
    // sum avoids overflow for very large values.
    final modulus = abs();
    final t = modulus > 1e300
        ? math.sqrt(modulus / 2 + a.abs() / 2)
        : math.sqrt((modulus + a.abs()) / 2);

    if (a >= 0) {
      return Complex(t, b / (2 * t));
    }

    return Complex(b.abs() / (2 * t), b < 0 ? -t : t);
  }

  /// Calculates the power having this complex number as base and a real value
  /// as exponent. The expression is in the form _(a + bi)^x_.
  ///
  /// When [x] is an integer (up to 1024 in magnitude), the result is computed
  /// with repeated multiplications, so for example `Complex.i().pow(2)` is
  /// exactly `-1`. Otherwise, the principal value `exp(x * log(z))` is
  /// returned.
  ///
  /// Raising any number (zero included) to `0` returns `1`. Raising zero to a
  /// positive power returns zero, while a negative power throws a
  /// [ComplexException].
  Complex pow(num x) {
    if (x.isNaN) {
      return const Complex(double.nan, double.nan);
    }

    if (x == 0) {
      return const Complex(1, 0);
    }

    if (isZero) {
      if (x > 0) {
        return const Complex.zero();
      }

      throw const ComplexException(
        'Zero raised to a negative power is undefined.',
      );
    }

    if (x.abs() <= _maxIntegerPower && x == x.truncate()) {
      return _integerPow(x.toInt());
    }

    final logModulus = x * math.log(abs());
    final angle = x * phase();
    final modulus = math.exp(logModulus);

    return Complex(modulus * math.cos(angle), modulus * math.sin(angle));
  }

  /// Calculates the power having this complex number as base and the complex
  /// number [w] as exponent. The expression is in the form
  /// _(a + bi)^(c + di)_.
  ///
  /// The principal value `exp(w * log(z))` is returned. When [w] is real, this
  /// is the same as calling [pow] with the real part of [w] (so integer
  /// exponents are exact).
  ///
  /// Raising any number (zero included) to `0` returns `1`. Raising zero to an
  /// exponent with a positive real part returns zero, while any other exponent
  /// throws a [ComplexException].
  Complex powComplex(Complex w) {
    if (w.imaginary == 0) {
      return pow(w.real);
    }

    if (isZero) {
      if (w.real > 0) {
        return const Complex.zero();
      }

      throw const ComplexException(
        'Zero raised to an exponent with a non-positive real part is '
        'undefined.',
      );
    }

    return (w * log()).exp();
  }

  /// Computes this number raised to the integer power [n] by repeated squaring.
  /// This number must not be zero when [n] is negative.
  Complex _integerPow(int n) {
    // Inverting the base first (rather than the result) avoids a spurious
    // overflow or underflow of the intermediate powers.
    var base = n < 0 ? reciprocal() : this;
    var exponent = n.abs();

    // Starting from 'null' rather than from 1 avoids a useless multiplication
    // (and 'Infinity * 0 = NaN' when a part of the base is infinite).
    Complex? result;

    while (true) {
      if (exponent.isOdd) {
        result = result == null ? base : result * base;
      }

      exponent >>= 1;

      if (exponent == 0) {
        return result!;
      }

      base = base * base;
    }
  }

  /// The sign of the current object is changed and the result is returned in a
  /// new [Complex] instance.
  Complex get negate => Complex(-real, -imaginary);

  /// Checks whether the complex number is zero.
  bool get isZero => real == 0 && imaginary == 0;

  /// Computes the principal n-th root of this object, which is the root whose
  /// argument is `phase() / n`. For `nth = 2`, this is the same as [sqrt].
  ///
  /// The other roots can be obtained by multiplying the principal root by the
  /// n-th roots of unity, `exp(2 * pi * k * i / n)` with `k = 1, ..., n - 1`.
  ///
  /// When [nth] is negative, the reciprocal of the principal `|nth|`-th root is
  /// returned. When [nth] is `1`, this number is returned.
  ///
  /// Throws a [ComplexException] if [nth] is zero, or if [nth] is negative and
  /// this number is zero.
  Complex nthRoot(int nth) {
    if (nth == 0) {
      throw const ComplexException('The 0-th root is undefined.');
    }

    if (nth < 0 && isZero) {
      throw const ComplexException(
        'A negative root of zero is undefined.',
      );
    }

    final n = nth.abs();
    final Complex root;

    if (n == 1) {
      root = this;
    } else if (n == 2) {
      root = sqrt();
    } else {
      final modulus = math.pow(abs(), 1.0 / n).toDouble();
      final angle = phase() / n;

      root = Complex(modulus * math.cos(angle), modulus * math.sin(angle));
    }

    return nth < 0 ? root.reciprocal() : root;
  }
}
