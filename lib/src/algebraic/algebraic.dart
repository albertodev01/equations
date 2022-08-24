import 'dart:math';

import 'package:equations/equations.dart';

/// The message thrown by the constructor to indicate that the polynomial cannot
/// correctly be created.
const _exceptionError = '''
To solve a polynomial equation (unless it's a constant), the coefficient with the highest degree cannot be zero. As such, make sure to pass a list that either:

 1. Contains a single value (like `[5]` or `[-2]`) to represent a polynomial whose degree is zero.
 2. Contains one or more values AND the first parameter is not zero (like `[1, 0]` or `[-6, -3, 2, 8]`).
 ''';

/// Abstract class representing an _algebraic equation_, also know as
/// _polynomial equation_, which has a single variable with a maximum degree.
///
/// The coefficients of the algebraic equations can be real numbers or complex
/// numbers. These are examples of an algebraic equations of third degree:
///
///   - x<sup>3</sup> + 5x + 2 = 0
///   - 2x<sup>3</sup> + (6+i)x + 8i = 0
///
/// This class stores the coefficients list starting from the one with the
/// **highest** degree.
abstract class Algebraic {
  /// The list with the polynomial coefficients.
  final List<Complex> coefficients;

  /// Creates a new algebraic equation by taking the coefficients of the
  /// polynomial starting from the one with the highest degree.
  ///
  /// For example, the equation `x^3 + 5x^2 + 3x - 2 = 0` would require a
  /// subclass of `Algebraic` to call the following...
  ///
  /// ```dart
  /// super([
  ///   Complex.fromReal(1), // x^3
  ///   Complex.fromReal(5), // x^2
  ///   Complex.fromReal(3), // x
  ///   Complex.fromReal(-2), // -2
  /// ]);
  /// ```
  ///
  /// ... because the coefficient with the highest degree goes first.
  ///
  /// If the coefficients of the polynomial are all real numbers, consider using
  /// the [Algebraic.realEquation] constructor which is more convenient.
  ///
  /// This constructor throws an [AlgebraicException] if the first element of
  /// [coefficients] is zero.
  Algebraic(this.coefficients) {
    // Unless this is a constant value, the coefficient with the highest degree
    // cannot be zero.
    if (!_isValid) {
      throw const AlgebraicException(_exceptionError);
    }
  }

  /// Creates a new algebraic equation by taking the coefficients of the
  /// polynomial starting from the one with the highest degree.
  ///
  /// For example, the equation `x^3 + 5x^2 + 3x - 2 = 0` would require a
  /// subclass of `Algebraic` to call the following...
  ///
  /// ```dart
  /// super.realEquation(1, 5, 3, 2);
  /// ```
  ///
  /// ... because the coefficient with the highest degree goes first.
  ///
  /// Use this constructor when the coefficients are all real numbers. If there
  /// were complex numbers as well, use the [Algebraic.new] default constructor
  /// instead.
  ///
  /// This constructor throws an [AlgebraicException] if the first element of
  /// [coefficients] is zero.
  Algebraic.realEquation(List<double> coefficients)
      : this(coefficients.map(Complex.fromReal).toList(growable: false));

  /// Creates an [Algebraic] subtype according with the length of the
  /// [coefficients] list. In particular:
  ///
  ///  - if the length is 1, a [Constant] object is returned;
  ///  - if the length is 2, a [Linear] object is returned;
  ///  - if the length is 3, a [Quadratic] object is returned;
  ///  - if the length is 4, a [Cubic] object is returned;
  ///  - if the length is 5, a [Quartic] object is returned;
  ///  - if the length is 6 or higher, a [DurandKerner] object is returned.
  ///
  /// If the length of [coefficients] was 3 for example, it would mean that
  /// you're trying to solve a quadratic equation (because a quadratic has
  /// exactly 3 coefficients). Another example:
  ///
  /// ```dart
  /// final linear = Algebraic.from(const [
  ///   Complex(1, 3),
  ///   Complex.i(),
  /// ]);
  /// ```
  ///
  /// In this case, `linear` is of type [Linear] because the given coefficients
  /// list represent the `(1 + 3i)x + i = 0` equation.
  ///
  /// Use this method when the coefficients can be complex numbers. If there
  /// were only real numbers, use the [Algebraic.fromReal] method which is more
  /// convenient.
  factory Algebraic.from(List<Complex> coefficients) {
    // Reminder: 'Complex' is immutable so there's no risk of getting undesired
    // side effects if 'coefficients' is altered
    switch (coefficients.length) {
      case 1:
        return Constant(
          a: coefficients.first,
        );
      case 2:
        return Linear(
          a: coefficients.first,
          b: coefficients[1],
        );
      case 3:
        return Quadratic(
          a: coefficients.first,
          b: coefficients[1],
          c: coefficients[2],
        );
      case 4:
        return Cubic(
          a: coefficients.first,
          b: coefficients[1],
          c: coefficients[2],
          d: coefficients[3],
        );
      case 5:
        return Quartic(
          a: coefficients.first,
          b: coefficients[1],
          c: coefficients[2],
          d: coefficients[3],
          e: coefficients[4],
        );
      default:
        return DurandKerner(
          coefficients: coefficients,
        );
    }
  }

  /// Creates an [Algebraic] subtype according with the length of the
  /// [coefficients] list. In particular:
  ///
  ///  - if the length is 1, a [Constant] object is returned;
  ///  - if the length is 2, a [Linear] object is returned;
  ///  - if the length is 3, a [Quadratic] object is returned;
  ///  - if the length is 4, a [Cubic] object is returned;
  ///  - if the length is 5, a [Quartic] object is returned;
  ///  - if the length is 6 or higher, a [DurandKerner] object is returned.
  ///
  /// If the length of [coefficients] was 3 for example, it would mean that
  /// you're trying to solve a quadratic equation (because a quadratic has
  /// exactly 3 coefficients). Another example:
  ///
  /// ```dart
  /// final linear = Algebraic.fromReal(const [0.5, 6]);
  /// ```
  ///
  /// In this case, `linear` is of type [Linear] because the given coefficients
  /// represent the `0.5x + 6 = 0` equation.
  ///
  /// Use this method when the coefficients are all real numbers. If there
  /// were complex numbers as well, use the [Algebraic.new] instead.
  factory Algebraic.fromReal(List<double> coefficients) => Algebraic.from(
        coefficients.map(Complex.fromReal).toList(growable: false),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Algebraic) {
      // The lengths of the coefficients must match.
      if (coefficients.length != other.coefficients.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements
      // are equal, then the counter will match the actual length of the
      // coefficients list.
      var equalsCount = 0;

      for (var i = 0; i < coefficients.length; ++i) {
        if (coefficients[i] == other.coefficients[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == coefficients.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < coefficients.length; ++i) {
      result = result * 37 + coefficients[i].hashCode;
    }

    return result;
  }

  @override
  String toString() => _convertToString();

  /// Returns a string representation of the polynomial where the coefficients
  /// are converted into their fractional representation.
  String toStringWithFractions() => _convertToString(asFraction: true);

  /// Represents the equation as a string. If [asFraction] is `true` then
  /// the coefficients are converted into their fractional representation with
  /// the best approximation possible.
  String _convertToString({bool asFraction = false}) {
    if (coefficients.length == 1) {
      final value = coefficients.first;

      if (asFraction) {
        return 'f(x) = ${value.toStringAsFraction()}';
      } else {
        return 'f(x) = ${value.toStringWithParenthesis()}';
      }
    } else {
      final sb = StringBuffer();
      var power = coefficients.length - 1;

      // Adding 'f(x) = ' at the beginning
      sb.write('f(x) = ');

      for (final c in coefficients) {
        //1. If it's a coefficient 0, then skip
        if (c.isZero) {
          --power;
          continue;
        }

        // Write the sign unless it's the first coefficient
        if (power != coefficients.length - 1) {
          sb.write(' + ');
        }

        //2. Write the complex
        if (asFraction) {
          // Add parenthesis if needed
          if ((c.real != 0) && (c.imaginary != 0)) {
            sb
              ..write('(')
              ..write(c.toStringAsFraction())
              ..write(')');
          } else {
            sb.write(c.toStringAsFraction());
          }
        } else {
          sb.write(c.toStringWithParenthesis());
        }

        //3. If it is power = 0 avoid it, we don't want x^0 (useless)
        if (power != 0) {
          if (power == 1) {
            sb.write('x');
          } else {
            sb
              ..write('x^')
              ..write(power);
          }
        }

        --power;
      }

      return sb.toString();
    }
  }

  /// A polynomial equation is **valid** if the coefficient associated to the
  /// variable of highest degree is different from zero. In other words, the
  /// polynomial is valid if `a` is different from zero.
  ///
  /// A [Constant] is an exception because a constant value has no variables
  /// with a degree.
  bool get _isValid => this is Constant || !coefficients.first.isZero;

  /// Evaluates the polynomial on the given [x] value.
  Complex evaluateOn(Complex x) {
    var value = const Complex.zero();
    var power = coefficients.length - 1;

    // Actual valuation
    for (final c in coefficients) {
      if (power != 0) {
        value += x.pow(power) * c;
      } else {
        value += c;
      }
      power--;
    }

    return value;
  }

  /// Evaluates the polynomial on the given decimal [x] value.
  Complex realEvaluateOn(double x) => evaluateOn(Complex.fromReal(x));

  /// Evaluates the integral of the the polynomial between [lower] and [upper].
  Complex evaluateIntegralOn(double lower, double upper) {
    var upperSum = const Complex.zero();
    var lowerSum = const Complex.zero();

    // The actual integration
    for (var n = coefficients.length - 1; n >= 0; --n) {
      final coeff = coefficient(n) ?? const Complex.zero();
      final denominator = Complex.fromReal(n + 1);

      upperSum += coeff * Complex.fromReal(upper).pow(n + 1) / denominator;
      lowerSum += coeff * Complex.fromReal(lower).pow(n + 1) / denominator;
    }

    return upperSum - lowerSum;
  }

  /// Determines whether the polynomial is real or not.
  ///
  /// If at least one coefficient is complex, then the polynomial is complex.
  bool get isRealEquation => coefficients.every((c) => c.imaginary == 0);

  /// Returns the coefficient of the polynomial at the given [index] position.
  /// For example:
  ///
  /// ```dart
  /// final quadratic = Quadratic(
  ///   a: Complex.fromReal(2),
  ///   b: Complex.fromReal(-6),
  ///   c: Complex.fromReal(5),
  /// );
  ///
  /// final a = quadratic[0] // a = Complex(2, 0)
  /// final b = quadratic[1] // b = Complex(-6, 0)
  /// final c = quadratic[2] // c = Complex(5, 0)
  /// ```
  ///
  /// An exception is thrown if the [index] is negative or if it doesn't
  /// correspond to a valid position.
  Complex operator [](int index) => coefficients[index];

  /// Returns the coefficient of the polynomial whose degree is [degree]. For
  /// example:
  ///
  /// ```dart
  /// final quadratic = Quadratic(
  ///   a: Complex.fromReal(2),
  ///   b: Complex.fromReal(-6),
  ///   c: Complex.fromReal(5),
  /// );
  ///
  /// final degreeZero = quadratic.coefficient(0) // Complex(5, 0)
  /// final degreeOne = quadratic.coefficient(1) // Complex(-6, 0)
  /// final degreeTwo = quadratic.coefficient(2) // Complex(2, 0)
  /// ```
  ///
  /// This method returns `null` if no coefficient of the given [degree] is
  /// found.
  Complex? coefficient(int degree) {
    // The coefficient of the given degree doesn't exist
    if ((degree < 0) || (degree > coefficients.length - 1)) {
      return null;
    }

    // Return the coefficient of degree 'degree'
    return coefficients[coefficients.length - degree - 1];
  }

  /// The sum of two polynomials is performed by adding the corresponding
  /// coefficients.
  ///
  /// The degrees of the two polynomials don't need to be the same. For example,
  /// you could sum a [Cubic] with a [Linear].
  Algebraic operator +(Algebraic other) {
    final maxDegree = max<int>(coefficients.length, other.coefficients.length);
    final newCoefficients = <Complex>[];

    // The sum of two polynomials is the sum of the coefficients with the same
    // degree
    for (var degree = maxDegree; degree >= 0; --degree) {
      final thisCoefficient = coefficient(degree) ?? const Complex.zero();
      final otherCoefficient =
          other.coefficient(degree) ?? const Complex.zero();
      final sum = thisCoefficient + otherCoefficient;

      if (!sum.isZero) {
        newCoefficients.add(sum);
      }
    }

    // Returning a new instance
    return Algebraic.from(newCoefficients);
  }

  /// The difference of two polynomials is performed by subtracting the
  /// corresponding coefficients.
  ///
  /// The degrees of the two polynomials don't need to be the same. For example,
  /// you could subtract a [Quadratic] and a [Quartic].
  Algebraic operator -(Algebraic other) {
    final maxDegree = max<int>(coefficients.length, other.coefficients.length);
    final newCoefficients = <Complex>[];

    // The difference of two polynomials is the difference of the coefficients
    // with the same degree
    for (var degree = maxDegree; degree >= 0; --degree) {
      final thisCoefficient = coefficient(degree) ?? const Complex.zero();
      final otherCoefficient =
          other.coefficient(degree) ?? const Complex.zero();
      final diff = thisCoefficient - otherCoefficient;

      if (!diff.isZero) {
        newCoefficients.add(diff);
      }
    }

    // Returning a new instance
    return Algebraic.from(newCoefficients);
  }

  /// The product of two polynomials is performed by multiplying the
  /// corresponding coefficients of the polynomials.
  ///
  /// The degrees of the two polynomials don't need to be the same. For example,
  /// you could multiply a [Constant] with a [DurandKerner].
  Algebraic operator *(Algebraic other) {
    // Generating the new list of coefficients
    final newLength = coefficients.length + other.coefficients.length - 1;
    final newCoefficients = List<Complex>.filled(
      newLength,
      const Complex.zero(),
    );

    // The product
    for (var i = 0; i < coefficients.length; ++i) {
      for (var j = 0; j < other.coefficients.length; ++j) {
        newCoefficients[i + j] += coefficients[i] * other.coefficients[j];
      }
    }

    // Returning a new instance
    return Algebraic.from(newCoefficients);
  }

  /// This operator divides a polynomial by another polynomial of the same or
  /// lower degree.
  ///
  /// The algorithm used to divide a polynomial by another is called "Polynomial
  /// long division" and it's implemented in the [PolynomialLongDivision] class.
  AlgebraicDivision operator /(Algebraic other) {
    final polyLongDivison = PolynomialLongDivision(
      polyNumerator: this,
      polyDenominator: other,
    );

    return polyLongDivison.divide();
  }

  /// The 'negation' operator changes the sign of every coefficient of the
  /// polynomial. For example:
  ///
  /// ```dart
  /// final poly1 = Linear.realEquation(a: 3, b: -5);
  /// final poly2 = -poly1; // poly2 = Linear.realEquation(a: -3, b: 5);
  /// ```
  ///
  /// As you can see, in `poly2` all the coefficients have the opposite sign.
  Algebraic operator -() =>
      Algebraic.from(coefficients.map((c) => -c).toList(growable: false));

  /// The polynomial discriminant, if it exists.
  Complex discriminant();

  /// Finds the roots (the solutions) of the associated _P(x) = 0_ equation.
  List<Complex> solutions();

  /// The derivative of the polynomial.
  Algebraic derivative();

  /// The degree of the polynomial.
  num get degree;
}
