import 'dart:math';

import 'package:equations/equations.dart';

part 'types/constant.dart';
part 'types/cubic.dart';
part 'types/generic_algebraic.dart';
part 'types/linear.dart';
part 'types/quadratic.dart';
part 'types/quartic.dart';

/// The message thrown by the constructor to indicate that the polynomial cannot
/// be created correctly.
const _exceptionError = '''
To create a valid polynomial equation (except for constant values), the coefficient with the highest degree cannot be zero. Therefore, ensure that your list either:
 1. contains a single value (like `[5]` or `[-2]`) to represent a polynomial whose degree is zero (a constant value);
 2. contains one or more values AND the first parameter is not zero (for example, `[1, 0]` or `[-6, -3, 2, 8]`).
''';

/// A record type that holds the quotient and the remainder of a division
/// between two polynomials. When you use `operator/` on two [Algebraic]
/// objects, this type is returned. The quotient represents the result of the
/// division, while the remainder represents what's left after the division.
///
/// For example:
///
/// ```dart
/// final numerator = Algebraic.fromReal([1, -3, 2]);
/// final denominator = Algebraic.fromReal([1, 2]);
///
/// final res = numerator / denominator;
///
/// print(res.quotient); // f(x) = 1x + -5 (that is, x - 5)
/// print(res.remainder); // f(x) = 12
/// ```
typedef AlgebraicDivision = ({Algebraic quotient, Algebraic remainder});

/// {@template algebraic}
/// An abstract class that represents an _algebraic equation_, also known as
/// a _polynomial equation_, which has a single variable and a maximum degree.
///
/// The coefficients of the algebraic equations can be real numbers or complex
/// numbers. These are examples of algebraic equations of third degree:
///
/// - x^3 + 5x + 2 = 0
/// - 2x^3 + (6+i)x + 8i = 0
///
/// This class stores the coefficients list starting from the one with the
/// **highest** degree. For example, the equation `x^3 + 5x^2 + 3x - 2 = 0`
/// would require a subclass of [Algebraic] to call the following:
///
/// ```dart
/// super([
///   Complex.fromReal(1), // x^3
///   Complex.fromReal(5), // x^2
///   Complex.fromReal(3), // x
///   Complex.fromReal(-2), // constant value
/// ]);
/// ```
///
/// The constructor throws an [AlgebraicException] if [coefficients] is empty
/// or if its first element is zero. The only exception is [Constant], whose
/// single coefficient can be zero (the zero polynomial).
/// {@endtemplate}
sealed class Algebraic {
  /// {@macro algebraic}
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, consider using [Algebraic.realEquation] for a less
  /// verbose syntax.
  new(this.coefficients) {
    // Unless this is a constant value, the coefficient with the highest degree
    // cannot be zero.
    if (!_isValid) {
      throw const AlgebraicException(_exceptionError);
    }
  }

  /// {@macro algebraic}
  ///
  /// If the coefficients of your polynomial contain complex numbers, use the
  /// [Algebraic.new] constructor instead.
  new realEquation(List<double> coefficients)
    : this(
        coefficients.map(Complex.fromReal).toList(growable: false),
      );

  /// {@template algebraic_from}
  /// Creates an [Algebraic] object according to the length of [coefficients].
  /// In particular:
  ///
  ///  - if the length is 1, a [Constant] object is returned;
  ///  - if the length is 2, a [Linear] object is returned;
  ///  - if the length is 3, a [Quadratic] object is returned;
  ///  - if the length is 4, a [Cubic] object is returned;
  ///  - if the length is 5, a [Quartic] object is returned;
  ///  - if the length is 6 or higher, a [GenericAlgebraic] object is returned.
  ///
  /// For example:
  ///
  /// ```dart
  /// final linear = Algebraic.from(const [
  ///   Complex(1, 3),
  ///   Complex.i(),
  /// ]);
  /// ```
  ///
  /// In this case, `linear` is of type [Linear] because the given coefficients
  /// list represents the `(1 + 3i)x + i = 0` equation.
  /// {@endtemplate}
  ///
  /// Use this method when the coefficients can be complex numbers. If there
  /// are only real numbers, use the [Algebraic.fromReal] constructor which is
  /// more convenient.
  factory from(List<Complex> coefficients) {
    switch (coefficients.length) {
      case 1:
        return Constant(a: coefficients.first);
      case 2:
        return Linear(a: coefficients.first, b: coefficients[1]);
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
        return GenericAlgebraic(
          coefficients: coefficients,
        );
    }
  }

  /// {@macro algebraic_from}
  ///
  /// Use this method when the coefficients are all real numbers. If there are
  /// complex numbers as well, use the [Algebraic.from] constructor instead.
  factory fromReal(List<double> coefficients) => Algebraic.from(
    coefficients.map(Complex.fromReal).toList(growable: false),
  );

  /// The polynomial coefficients.
  final List<Complex> coefficients;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Algebraic) {
      if (coefficients.length != other.coefficients.length) {
        return false;
      }
      for (var i = 0; i < coefficients.length; ++i) {
        if (coefficients[i] != other.coefficients[i]) {
          return false;
        }
      }

      return runtimeType == other.runtimeType;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hashAll(coefficients);

  @override
  String toString() => _convertToString();

  /// Returns a string representation of the polynomial where the coefficients
  /// are converted into their fractional representation.
  ///
  /// This method provides a more readable representation of polynomials with
  /// rational coefficients by converting decimal values to fractions where
  /// possible.
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

  /// A polynomial equation is **valid** if the coefficient associated with the
  /// variable of highest degree is not zero. In other words, the polynomial is
  /// valid if the first coefficient in the list (which represents the highest
  /// degree term) is not zero.
  ///
  /// A [Constant] is a special case because a constant value has no variables
  /// with a degree.
  bool get _isValid {
    if (coefficients.isEmpty) {
      return false;
    }

    return this is Constant || !coefficients.first.isZero;
  }

  /// Evaluates the polynomial at the given complex value [x].
  ///
  /// This method computes P(x) where P is this polynomial and x is the given
  /// complex number. The evaluation is performed using Horner's method, which
  /// only needs additions and multiplications. This keeps the result exact
  /// whenever the intermediate values are representable, and avoids spurious
  /// imaginary parts when a real polynomial is evaluated at a negative value.
  ///
  /// Example:
  /// ```dart
  /// final poly = Quadratic.realEquation(a: 1, b: 2, c: 1); // x^2 + 2x + 1
  /// final result = poly.evaluateOn(Complex.fromReal(3));
  /// // result = Complex(16, 0) because 3^2 + 2(3) + 1 = 9 + 6 + 1 = 16
  /// ```
  Complex evaluateOn(Complex x) {
    var value = const Complex.zero();

    // Horner's method: ((a*x + b)*x + c)*x + ...
    for (final c in coefficients) {
      value = value * x + c;
    }

    return value;
  }

  /// Evaluates the polynomial at the given real value [x].
  ///
  /// This is a convenience method that converts the real number [x] to a
  /// complex number and calls [evaluateOn]. It's useful when you know you're
  /// working with real numbers and want to avoid the verbosity of creating
  /// [Complex] objects.
  ///
  /// Example:
  /// ```dart
  /// final poly = Linear.realEquation(a: 2, b: 3); // 2x + 3
  /// final result = poly.realEvaluateOn(5);
  /// // result = Complex(13, 0) because 2(5) + 3 = 13
  /// ```
  Complex realEvaluateOn(double x) => evaluateOn(Complex.fromReal(x));

  /// Evaluates the definite integral of the polynomial from [lower] to [upper].
  ///
  /// This method computes the integral of P(x)dx over `[lower, upper]`, where
  /// P is this polynomial. The integral is computed analytically: the
  /// antiderivative F(x) is built with the power rule and then
  /// F(upper) - F(lower) is evaluated using Horner's method. For example:
  ///
  /// ```dart
  /// final poly = Linear.realEquation(a: 2, b: 3); // 2x + 3
  /// final integral = poly.evaluateIntegralOn(0, 2);
  /// // integral = Complex(10, 0) because the integral of (2x + 3)dx from 0
  /// // to 2 is 10
  /// ```
  ///
  /// The method works with both real and complex coefficients, returning
  /// complex results when necessary.
  Complex evaluateIntegralOn(double lower, double upper) {
    final upperValue = Complex.fromReal(upper);
    final lowerValue = Complex.fromReal(lower);
    var upperSum = const Complex.zero();
    var lowerSum = const Complex.zero();

    // The coefficient of degree 'n' becomes c / (n + 1) in the antiderivative,
    // with degree 'n + 1'. The constant of integration is omitted because it
    // cancels out in F(upper) - F(lower). F is evaluated with Horner's method:
    // the last multiplication by x accounts for the missing constant term.
    for (var i = 0; i < coefficients.length; ++i) {
      final newPower = coefficients.length - i;
      final antiderivativeCoeff =
          coefficients[i] / Complex.fromReal(newPower.toDouble());

      upperSum = (upperSum + antiderivativeCoeff) * upperValue;
      lowerSum = (lowerSum + antiderivativeCoeff) * lowerValue;
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
  /// final a = quadratic[0]; // a = Complex(2, 0)
  /// final b = quadratic[1]; // b = Complex(-6, 0)
  /// final c = quadratic[2]; // c = Complex(5, 0)
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
  /// final degreeZero = quadratic.coefficient(0); // Complex(5, 0)
  /// final degreeOne = quadratic.coefficient(1); // Complex(-6, 0)
  /// final degreeTwo = quadratic.coefficient(2); // Complex(2, 0)
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
  /// you can sum a [Cubic] with a [Linear].
  ///
  /// If the leading coefficients cancel out, the degree of the result is
  /// lowered accordingly. If every coefficient cancels out, the zero
  /// polynomial (a [Constant] with value 0) is returned.
  Algebraic operator +(Algebraic other) {
    final maxDeg = max<int>(coefficients.length, other.coefficients.length) - 1;
    final coeffs = Iterable<int>.generate(maxDeg + 1, (i) => maxDeg - i).map(
      (degree) {
        return (coefficient(degree) ?? const Complex.zero()) +
            (other.coefficient(degree) ?? const Complex.zero());
      },
    );

    return Algebraic.from(_trimLeadingZeros(coeffs));
  }

  /// The difference of two polynomials is performed by subtracting the
  /// corresponding coefficients.
  ///
  /// The degrees of the two polynomials don't need to be the same. For example,
  /// you can subtract a [Quadratic] from a [Quartic].
  ///
  /// If the leading coefficients cancel out, the degree of the result is
  /// lowered accordingly. If every coefficient cancels out (for example,
  /// `p - p`), the zero polynomial (a [Constant] with value 0) is returned.
  Algebraic operator -(Algebraic other) {
    final maxDeg = max<int>(coefficients.length, other.coefficients.length) - 1;
    final coeffs = Iterable<int>.generate(maxDeg + 1, (i) => maxDeg - i).map(
      (degree) {
        return (coefficient(degree) ?? const Complex.zero()) -
            (other.coefficient(degree) ?? const Complex.zero());
      },
    );

    return Algebraic.from(_trimLeadingZeros(coeffs));
  }

  /// The product of two polynomials. Each coefficient of this polynomial is
  /// multiplied by each coefficient of [other], and the products with the same
  /// resulting degree are summed together (a discrete convolution).
  ///
  /// The degrees of the two polynomials don't need to be the same. For example,
  /// you can multiply a [Constant] with a [GenericAlgebraic]. Multiplying by
  /// the zero polynomial returns the zero polynomial.
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

    return Algebraic.from(_trimLeadingZeros(newCoefficients));
  }

  /// Removes the leading zero coefficients (the ones with the highest degree)
  /// from [coefficients]. Zeros in any other position are kept because they
  /// hold the place of their degree.
  ///
  /// If every coefficient is zero, a single zero is returned so that the
  /// result represents the zero polynomial.
  static List<Complex> _trimLeadingZeros(Iterable<Complex> coefficients) {
    final trimmed = coefficients
        .skipWhile((c) => c.isZero)
        .toList(growable: false);

    return trimmed.isEmpty ? const [Complex.zero()] : trimmed;
  }

  /// This operator divides a polynomial by another polynomial using the
  /// polynomial long division algorithm. The returned [AlgebraicDivision] type
  /// is a record type that contains both the quotient and the remainder of the
  /// division.
  ///
  /// The algorithm used to divide polynomials is implemented by the
  /// [PolynomialLongDivision] class. If the degree of [other] is higher than
  /// the degree of this polynomial, the quotient is 0 and the remainder is
  /// this polynomial.
  ///
  /// Throws a [PolynomialLongDivisionException] if [other] is the zero
  /// polynomial.
  AlgebraicDivision operator /(Algebraic other) {
    final polyLongDivision = PolynomialLongDivision(
      polyNumerator: this,
      polyDenominator: other,
    );

    return polyLongDivision.divide();
  }

  /// The unary minus operator changes the sign of every coefficient of the
  /// polynomial. For example:
  ///
  /// ```dart
  /// final poly1 = Linear.realEquation(a: 3, b: -5);
  /// final poly2 = -poly1; // poly2 = Linear.realEquation(a: -3, b: 5);
  /// ```
  Algebraic operator -() =>
      Algebraic.from(coefficients.map((c) => -c).toList(growable: false));

  /// Factors the polynomial over the complex numbers.
  ///
  /// Every non-constant polynomial with complex coefficients can be written as
  /// `a(x - r1)(x - r2)...(x - rn)`, where `a` is the leading coefficient and
  /// `r1, ..., rn` are the roots. This method returns those factors:
  ///
  ///  - a [Constant] holding the leading coefficient `a`, as the first element,
  ///    but only when `a` is not 1;
  ///  - one monic [Linear] factor `(x - ri)` for each root, in the order
  ///    returned by [solutions]. A root with multiplicity `k` appears `k`
  ///    times.
  ///
  /// The product of the returned factors is always equal to this polynomial
  /// (up to the precision of [solutions]). For example:
  ///
  /// ```dart
  /// final poly1 = Algebraic.fromReal([1, 0, -4]); // x^2 - 4
  /// final factors1 = poly1.factor();
  /// // [x - 2, x + 2]
  ///
  /// final poly2 = Algebraic.fromReal([2, 0, -8]); // 2x^2 - 8
  /// final factors2 = poly2.factor();
  /// // [2, x - 2, x + 2]
  ///
  /// final poly3 = Algebraic.fromReal([1, 0, 4]); // x^2 + 4
  /// final factors3 = poly3.factor();
  /// // [x - 2i, x + 2i]
  /// ```
  ///
  /// If the polynomial is a [Constant], it has no roots and a list containing
  /// only this polynomial is returned.
  ///
  /// For polynomials of degree 5 or higher, the roots are computed with a
  /// numerical method, so the linear factors are approximations.
  List<Algebraic> factor() {
    final roots = solutions();

    // Only constants have no roots (fundamental theorem of algebra).
    if (roots.isEmpty) {
      return [this];
    }

    final leadingCoefficient = coefficients.first;

    return [
      if (leadingCoefficient != const Complex.fromReal(1))
        Constant(a: leadingCoefficient),
      ...roots.map((root) => Linear(b: -root)),
    ];
  }

  /// Solves the inequality associated with this polynomial.
  ///
  /// The inequality type is specified by the [inequalityType] parameter, which
  /// can be one of the following (where P(x) represents this polynomial):
  ///
  ///  - [AlgebraicInequalityType.lessThan]: solves P(x) < 0
  ///  - [AlgebraicInequalityType.lessThanOrEqualTo]: solves P(x) <= 0
  ///  - [AlgebraicInequalityType.greaterThan]: solves P(x) > 0
  ///  - [AlgebraicInequalityType.greaterThanOrEqualTo]: solves P(x) >= 0
  ///
  /// The [precision] parameter (defaults to 1e-10) is the relative tolerance
  /// used to decide whether a value of x is a root: x is a root when
  /// `|P(x)| <= precision * S(x)`, where `S(x)` is the sum of the absolute
  /// values of the terms of P(x). The precision must be a positive number.
  ///
  /// Returns a list of [AlgebraicInequalitySolution] objects representing the
  /// intervals where the inequality is satisfied, sorted in ascending order.
  /// For `<=` and `>=` every returned interval includes its endpoints, while
  /// for `<` and `>` it excludes them. The returned list can be empty if the
  /// inequality is not satisfied for any real number.
  ///
  /// The roots are computed with [solutions], so for polynomials of degree 5
  /// or higher the endpoints of the intervals are approximations. See
  /// [AlgebraicInequalitySolver] for more details.
  ///
  /// Throws an [AlgebraicException] if:
  ///  - The polynomial has complex coefficients
  ///  - The precision parameter is not positive
  List<AlgebraicInequalitySolution> solveInequality({
    required AlgebraicInequalityType inequalityType,
    double precision = 1e-10,
  }) => AlgebraicInequalitySolver(
    polynomial: this,
    inequalityType: inequalityType,
    precision: precision,
  ).solve();

  /// The polynomial discriminant.
  ///
  /// The discriminant is a mathematical expression that provides information
  /// about the nature of the roots of a polynomial equation. Up to degree 4 it
  /// is computed with the closed-form formulas. For higher degrees, it is
  /// computed from the resultant of the polynomial and its derivative (the
  /// determinant of their Sylvester matrix).
  ///
  /// The discriminant is not defined for a [Constant], which returns a
  /// [Complex] whose real and imaginary parts are both `NaN`.
  Complex discriminant();

  /// Finds the roots (the solutions) of the associated _P(x) = 0_ equation.
  List<Complex> solutions();

  /// The derivative of the polynomial.
  Algebraic derivative();

  /// The degree of the polynomial.
  num get degree;
}
